# Lab 5 — VetClinic: Validations, Enums, Scopes & Callbacks

## Objective

In this lab, you will strengthen the VetClinic data layer by adding **validations**, converting the appointment status into a proper **enum**, defining useful **scopes**, adding **callbacks** for data normalization, and eliminating **N+1 queries** from the views you built in Lab 4. By the end, the database will reject invalid data and your index pages will be more efficient.

This lab still focuses on the model layer and read-only views. Forms for creating and editing records will come in Lab 6.

## Setup

In this lab you will continue working on the VetClinic application you built in Lab 4, but you must submit it in a **new repository**. Your Lab 4 repository will not be reviewed for this lab.

1. **Create a new, empty repository** on GitHub (no README, no .gitignore, no license — completely empty). Make sure it is **public** so the teaching assistant can review it.

2. In your local `vet_clinic` project from Lab 4, add the new repository as a remote and push your code:

```bash
cd vet_clinic
git remote add lab5 <your-new-repo-url>
git push -u lab5 main
```

3. Verify on GitHub that your code is now in the new repository.

4. From now on, push your Lab 5 work to this new remote:

```bash
git push lab5 main
```

5. **Submit the link to your new repository on Canvas.**

## Instructions

### 1. Validations

Add validations to each model to enforce data integrity. Choose the appropriate validator for each rule (`presence`, `uniqueness`, `format`, `numericality`, `inclusion`, `length`, etc.).

**Owner**
- `first_name` and `last_name` are required.
- `email` is required, must have a valid email format, and must be unique.
- `phone` is required.

**Pet**
- `name` is required.
- `species` is required and must be one of: `dog`, `cat`, `rabbit`, `bird`, `reptile`, `other`.
- `date_of_birth` is required and cannot be in the future.
- `weight` is required and must be a number greater than 0.
- `owner` is required.

**Vet**
- `first_name` and `last_name` are required.
- `email` is required, must have a valid email format, and must be unique.
- `specialization` is required.

**Appointment**
- `date` is required.
- `reason` is required.
- `pet` and `vet` are required.
- `status` is required (see Enum section below).

**Treatment**
- `name` is required.
- `administered_at` is required.
- `appointment` is required.

Make sure your existing seed data still passes all validations. Update the seeds if necessary so that `rails db:seed` runs without errors on a fresh database.

### 2. Enum for Appointment Status

Convert the `status` integer attribute on `Appointment` into a Rails **enum** with the following values, in this order:

- `scheduled`
- `in_progress`
- `completed`
- `cancelled`

Update any places in your application that previously used the raw integer value (seeds, views) so they use the enum's symbolic name instead. Confirm from the Rails console that you can query appointments by status using the generated scope (e.g., `Appointment.completed`).

### 3. Scopes

A **scope** is a named, reusable query defined inside a model. Instead of sprinkling conditions like `where(...).order(...)` throughout your controllers and views, you give the query a short name and call it like a method on the class. This keeps query logic in one place (the model), makes your views easier to read, and lets you chain the scope with other query methods.

You define a scope with Rails' `scope` macro, giving it a name and a lambda that returns a relation. Scopes can take arguments when you need to filter by a value provided at call time.

Read the Rails guide section on scopes before starting this part: <https://guides.rubyonrails.org/active_record_querying.html#scopes>.

Define the following named scopes:

- `Appointment.upcoming` — appointments with a `date` in the future, ordered by date ascending.
- `Appointment.past` — appointments with a `date` in the past, ordered by date descending.
- `Pet.by_species(species)` — pets matching the given species.
- `Vet.by_specialization(specialization)` — vets matching the given specialization.

Use these scopes in at least two places in your views where they make sense (for example, showing only upcoming appointments on a vet's or pet's show page).

### 4. Callbacks

Add the following callbacks:

- **Owner** and **Vet**: normalize the `email` attribute to lowercase and strip whitespace before validation.
- **Pet**: capitalize the `name` attribute before saving.

### 5. Eliminate N+1 Queries

An **N+1 query** is one of the most common performance problems in Rails apps. It happens when you load a collection of `N` records with one query, and then — while rendering each one — trigger one additional query per record to fetch an associated object. So displaying 50 owners with their pet count ends up issuing 1 query for the owners plus 50 extra queries for the pets: 51 queries to render a single page.

The fix is **eager loading**: telling Active Record *in advance* which associations you'll need, so it can fetch them in a small, fixed number of queries instead of one per record. Rails provides `includes`, `preload`, and `eager_load` for this.

To detect N+1 queries, watch the Rails development log (`log/development.log` or the terminal running `rails server`) while you load a page. If you see the same `SELECT` statement repeated once per row in your table — with only the ID changing — that's an N+1. After adding eager loading, the same page should issue a small, constant number of queries regardless of how many records are displayed.

Read the "Eager Loading Associations" section of the Rails guide before starting this part: <https://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations>.

Review each of your index pages from Lab 4 and use `includes` (or equivalent) to preload associations that are rendered in the table. This should apply to at least:

- Owners index (preloading pets, since you display the pet count).
- Pets index (preloading owner).
- Appointments index (preloading pet and vet).

Verify in your development log that the number of queries does not grow with the number of records displayed.

### 6. Flash Messages

A **flash message** is a short piece of text that you want to show to the user on the *next* request — typically after an action like "Owner created successfully" or "This appointment could not be saved". Rails stores the message in a special hash called `flash`, which survives exactly one redirect and is then discarded automatically. That makes it the standard way to communicate the outcome of an action without cluttering the URL or the session.

The two conventional keys are:

- `flash[:notice]` — informational or success messages (e.g., "Pet was successfully updated").
- `flash[:alert]` — error or warning messages (e.g., "You must be signed in to do that").

In your controllers (starting in Lab 6) you will set these after actions like create, update, or destroy. The layout is responsible for displaying whatever is present in `flash` on each request.

Read the Rails guide section on the flash: <https://guides.rubyonrails.org/action_controller_overview.html#the-flash>.

In this lab you will only prepare the layout so it is ready for Lab 6. Add a **flash partial** under `app/views/layouts/` that renders `flash[:notice]` and `flash[:alert]` whenever they are present, and render this partial from your application layout so it appears on every page.

Style the partial using **Bootstrap's alert component** (see <https://getbootstrap.com/docs/5.3/components/alerts/>):

- Each flash message should be wrapped in a `<div>` with the base class `alert` plus a contextual class.
- Use `alert-success` for `flash[:notice]` (informational / success messages).
- Use `alert-danger` for `flash[:alert]` (errors / warnings).
- Include the `role="alert"` attribute for accessibility, as shown in the Bootstrap docs.
- Make the alerts **dismissible** (`alert-dismissible` + a close button with `data-bs-dismiss="alert"`), so the user can close them without navigating away.

You do not need to trigger any flash messages yet — just confirm that if you manually set one in the Rails console during a request it would render correctly.

### 7. Model Tests

Add tests for your validations using the default testing framework (`rails test` with Minitest). For each model, write at least:

- One test that confirms a valid record can be saved.
- One test per validation rule that confirms an invalid record is rejected and exposes the expected error on the expected attribute.

Your test suite should run green with `rails test`.

## Deliverables

- All five models have validations covering the rules listed above.
- `Appointment.status` is a Rails enum with the four values in the specified order.
- Scopes `Appointment.upcoming`, `Appointment.past`, `Pet.by_species`, and `Vet.by_specialization` are defined and used in at least two views.
- Callbacks normalize `Owner`/`Vet` emails and capitalize `Pet` names.
- Index views use eager loading to avoid N+1 queries.
- A flash partial is included in the application layout.
- A passing test suite that exercises every validation.
- Seeds run cleanly on a fresh database (`rails db:drop db:create db:migrate db:seed`).
