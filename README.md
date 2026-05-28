# Lab 9 - VetClinic (Authorization with Pundit)

For this lab, I installed **Pundit** to add authorization to the VetClinic application. Now, signed-in users can only access the records and actions allowed for their role.

## Changes made:
* **Pundit Setup:** I added Pundit, included it in `ApplicationController`, and added authorization checks for controller actions.
* **Policies:** I created policies for Owners, Pets, Vets, Appointments, and Treatments.
* **User Links:** I linked `Owner` and `Vet` records to `User` accounts using `user_id`.
* **Registration Disabled:** I removed open sign-up, so users must be created through seeds or the Rails console.
* **Authorization Rules:** Admins can manage everything. Vets can manage only their assigned appointments and treatments. Owners can manage only their own owner record, pets, and appointments.
* **Navbar and Buttons:** The navbar and action buttons now change depending on what the signed-in user is allowed to do.
* **Seeds:** I updated the seeds so the admin, vet, and owner users are linked to the correct demo data.

## Test Users (Seeds)

I added these users to the `db/seeds.rb` file. All of them use the same password: `password123`

| User | Email | Role |
| :--- | :--- | :--- |
| **Admin** | admin@vetclinic.com | Admin |
| **Veterinarian** | vet@vetclinic.com | Vet |
| **Owner** | owner@vetclinic.com | Owner |

## How to run the app:
1. `bundle install`
2. `bin/rails db:drop db:create db:migrate db:seed`
3. `bin/rails s`
