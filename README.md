# Lab 8 - VetClinic (Authentication)

For this lab, I installed **Devise** to make the VetClinic application private. Now, you must have an account to view owners, vets, or appointments.

## Changes made:
* **User Model:** I added `first_name`, `last_name`, and `role` (using an enum).
* **Home Page:** I kept the pets index public so anyone can see the main page, but everything else requires a login.
* **Forms:** I styled the Devise views with Bootstrap to make them look good and added the name and last name fields to the sign-up form.
* **Navbar:** The navbar now shows the user's name and role when logged in, and shows the Sign In / Sign Up buttons when they are not. The sign-out button uses the DELETE method as required.

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


