# Lab 6 — VetClinic: Forms and Full CRUD

## Objective

In this lab, you will extend the VetClinic application with the remaining RESTful actions — `new`, `create`, `edit`, `update`, and `destroy` — so users can manage records through the browser. You will build forms with `form_with`, protect mass assignment with **strong parameters**, surface validation errors back to the user, and wire the **flash partial** you prepared in Lab 5 to communicate the outcome of each action.

By the end of this lab, the VetClinic application will support full CRUD for Owners, Pets, Vets, and Appointments, with Treatments managed from the Appointment show page.

## Setup

In this lab you will continue working on the VetClinic application you built in Lab 5, but you must submit it in a **new repository**. Your Lab 5 repository will not be reviewed for this lab.

1. **Create a new, empty repository** on GitHub (no README, no .gitignore, no license — completely empty). Make sure it is **public** so the teaching assistant can review it.

2. In your local `vet_clinic` project from Lab 5, add the new repository as a remote and push your code:

```bash
cd vet_clinic
git remote add lab6 <your-new-repo-url>
git push -u lab6 main
```

3. Verify on GitHub that your code is now in the new repository.

4. From now on, push your Lab 6 work to this new remote:

```bash
git push lab6 main
```

5. **Submit the link to your new repository on Canvas.**

## Instructions

### 1. Expand Routes

Update `config/routes.rb` so that Owners, Pets, Vets, and Appointments expose the full set of RESTful actions (no longer restricted to `index` and `show`).

Treatments should be exposed as a **nested resource under appointments**, so URLs look like `/appointments/:appointment_id/treatments/new`. Treatments are always viewed in the context of their parent appointment, so they do **not** need an `index` action (the appointment show page already lists them) nor a `show` action (the treatment's details fit comfortably in that same list). Expose only the actions needed to manage them: `new`, `create`, `edit`, `update`, and `destroy`.

Read the Rails guide section on nested resources before deciding on the route structure: <https://guides.rubyonrails.org/routing.html#nested-resources>.

### 2. Controller Actions

For each of Owners, Pets, Vets, and Appointments, implement the standard seven actions (`index`, `show`, `new`, `create`, `edit`, `update`, `destroy`). For Treatments, implement only `new`, `create`, `edit`, `update`, and `destroy` — there is no `index` or `show` action.

The Treatments controller behaves slightly differently from the others because every action operates in the context of a parent appointment:

- A `before_action` should load the parent appointment from `params[:appointment_id]` and make it available to all actions (e.g., as `@appointment`).
- `new` and `edit` render forms scoped to that appointment.
- `create` builds the new treatment through the association (`@appointment.treatments.build(treatment_params)`) so the foreign key is set automatically and cannot be tampered with from the form.
- `update`, `destroy`, `create` (on success), and `create` (on failure when re-rendering) should all redirect or render in the context of the parent appointment — the success path redirects back to the appointment's show page (where the treatments list lives), and the failure path re-renders the treatment form with `@appointment` still loaded.

Each controller must:

- Use a `before_action` to load the record from `params[:id]` for the actions that need it (`show`, `edit`, `update`, `destroy`). Avoid duplicating `Model.find(params[:id])` across actions.
- Define a private `*_params` method that uses **strong parameters** (`params.require(...).permit(...)`) to whitelist only the attributes a user is allowed to set. Never permit foreign keys that should be derived from the URL (for example, `appointment_id` in `TreatmentsController` must come from `params[:appointment_id]`, not from form input).
- On successful `create`/`update`, redirect to the show page of the affected record and set `flash[:notice]` with a clear success message.
- On failed `create`/`update` (when validations reject the record), re-render the corresponding form with `status: :unprocessable_entity` so the validation errors are shown to the user. Do **not** redirect on failure.
- On successful `destroy`, redirect to the resource's index page and set `flash[:notice]`.

Read the Rails guide on strong parameters before writing the `*_params` methods: <https://guides.rubyonrails.org/action_controller_overview.html#strong-parameters>.

### 3. Forms

Create `new` and `edit` views for each resource. Both views should render a shared `_form.html.erb` partial so the form markup is defined exactly once per resource.

Each form must:

- Use `form_with(model: ...)` so Rails infers the URL and HTTP method automatically (POST for new records, PATCH for existing ones).
- Use the appropriate form helpers for each attribute type:
  - `text_field` for short strings (names, phone, email).
  - `text_area` for longer text (address, appointment reason, treatment notes).
  - `date_field` for dates without a time component (pet date of birth).
  - `datetime_field` for date-and-time values (appointment date, treatment `administered_at`).
  - `number_field` with `step:` for decimals (pet weight).
  - `collection_select` for foreign keys (a Pet's owner, an Appointment's pet and vet).
  - `select` with the enum's keys for the appointment status.
- Style inputs with Bootstrap's form classes (`form-control`, `form-select`, `form-label`, `mb-3` for spacing). Wrap each label/input pair in a `<div class="mb-3">`.
- Submit with a Bootstrap-styled button (`btn btn-primary`).

Read the Rails guide on `form_with` before starting: <https://guides.rubyonrails.org/form_helpers.html>.

### 4. Validation Error Display

When a form is re-rendered after a failed save, the user must see what went wrong.

Add a shared partial at `app/views/shared/_error_messages.html.erb` that takes a model object as a local variable and, if `object.errors.any?`, renders a Bootstrap `alert-danger` listing every full error message. Render this partial at the top of every `_form.html.erb` partial.

Additionally, mark each individual field that has an error so the user can see the offending input at a glance. Rails wraps invalid fields in a `<div class="field_with_errors">` automatically — override this behavior in `config/initializers/` so the wrapper instead adds Bootstrap's `is-invalid` class to the input itself, keeping the layout intact.

### 5. Links to the New Actions

Update your existing views from Lab 4 so users can reach the new pages:

- On each **index** page, add a "New ..." button at the top linking to the `new` action of that resource.
- On each **index** page, add an "Edit" and a "Delete" link/button to each row.
- On each **show** page, add an "Edit" and a "Delete" button.
- On the **Appointment show page**, add a "New treatment" link, plus "Edit" and "Delete" links on each existing treatment row.
- The "Delete" button must trigger a DELETE request and prompt for confirmation. Use the `button_to` helper with `method: :delete` and `data: { turbo_confirm: "Are you sure?" }` (or the equivalent without Hotwire if you have not enabled it). Do **not** use a plain `<a>` tag for destructive actions.

Read the Rails guide on link/button helpers and confirmations: <https://guides.rubyonrails.org/working_with_javascript_in_rails.html#confirmations>.

### 6. Flash Messages in Action

The flash partial you added to the layout in Lab 5 is now wired up to real actions. Verify that:

- After creating, updating, or deleting any record, the corresponding success message appears at the top of the next page.
- After a failed save, the validation errors appear inline in the form (this should **not** use the flash — flash is for outcomes that survive a redirect, while a failed save re-renders the same request).
- Manually triggering a `flash[:alert]` (for example, by adding a temporary `flash.now[:alert] = "Test"` in any action) renders with `alert-danger` styling.

### 7. Controller Tests

Add controller tests under `test/controllers/` using Minitest. For each of the five resources, write at least:

- One test that hits `index` and asserts a successful response.
- One test that hits `show` for an existing record.
- One test that creates a new record with valid params and asserts the redirect plus a flash notice.
- One test that attempts to create a record with invalid params and asserts the form is re-rendered with `:unprocessable_entity`.
- One test that updates an existing record with valid params and asserts the redirect.
- One test that destroys an existing record and asserts the redirect plus that the record is gone.

Use **fixtures** (under `test/fixtures/`) to provide a baseline of records for the tests. Make sure `rails test` runs green.

Read the Rails guide on controller and integration testing before starting: <https://guides.rubyonrails.org/testing.html#functional-tests-for-your-controllers>.

## Deliverables

- Full RESTful routes for Owners, Pets, Vets, and Appointments; nested non-display routes for Treatments under Appointments.
- Controllers implementing the seven (or five, for Treatments) standard actions, with strong parameters and `before_action` for record loading.
- Shared `_form.html.erb` partials for each resource, used by both `new` and `edit` views, styled with Bootstrap.
- A shared `_error_messages.html.erb` partial that surfaces validation errors at the top of each form, plus an initializer that marks invalid fields with `is-invalid`.
- "New", "Edit", and "Delete" links/buttons added to the Lab 4 index and show pages, with destructive actions confirmed and using the DELETE verb.
- Flash messages displayed after every successful create/update/destroy.
- A passing controller test suite covering happy and unhappy paths for each resource.
- Seeds still run cleanly on a fresh database (`rails db:drop db:create db:migrate db:seed`).
