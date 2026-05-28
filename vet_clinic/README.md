# VetClinic

VetClinic now uses Devise for authentication and Pundit for authorization.

## Authorization

The app enforces role-based authorization across owners, pets, vets, appointments, and treatments. Admin users have full CRUD access to every resource. Vet users can read owners, pets, and vets, can edit only their own vet profile, and can manage only appointments and treatments assigned to them. Owner users can manage only their own owner record, their own pets, and appointments for their own pets; they can list and view vets so they can book appointments. Unauthorized actions redirect safely with a flash message.

## Seeded Credentials

All seeded users use this password:

`password123`

Admin:

`admin@vetclinic.com`

Vet:

`vet@vetclinic.com`

Owner:

`owner@vetclinic.com`

## Database Setup

Run a fresh setup with:

```bash
bin/rails db:drop db:create db:migrate db:seed
```

The seed data links the owner-role user to an Owner with pets and appointments, links the vet-role user to a Vet with assigned appointments and treatments, and includes additional owners, pets, vets, and appointments for scope testing.

## Notes

No known deviations from the Lab 9 authorization matrix.
