
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all



# 1. Create Owners
o1 = Owner.create!(first_name: "John", last_name: "Doe", email: "john.doe@example.com", phone: "555-1234")
o2 = Owner.create!(first_name: "Jane", last_name: "Smith", email: "jane.smith@example.com", phone: "555-5678")
o3 = Owner.create!(first_name: "Coni", last_name: "Campos", email: "coni.campos@example.com", phone: "555-9999")

# 2. Create Pets (with new whitelist)
p1 = Pet.create!(name: "Firulais", species: "dog", breed: "Quiltro", date_of_birth: 3.years.ago, weight: 25.5, owner: o1)
p2 = Pet.create!(name: "Mittens", species: "cat", breed: "Siamese", date_of_birth: 2.years.ago, weight: 4.5, owner: o2)
p3 = Pet.create!(name: "Bugs", species: "rabbit", breed: "Holland Lop", date_of_birth: 1.year.ago, weight: 2.1, owner: o1)
p4 = Pet.create!(name: "Tweety", species: "bird", breed: "Canary", date_of_birth: 4.years.ago, weight: 0.2, owner: o3)

# 3. Create Vets
v1 = Vet.create!(first_name: "Alice", last_name: "Zuniga", email: "alice.vet@clinic.com", specialization: "General Medicine")
v2 = Vet.create!(first_name: "Charlie", last_name: "Soto", email: "charlie.vet@clinic.com", specialization: "Surgery")



# Past and Completed (Will show in "Past Appointments")
a1 = Appointment.create!(date: 2.days.ago, reason: "Rabies Vaccination", status: "completed", pet: p2, vet: v2)
a2 = Appointment.create!(date: 5.days.ago, reason: "Annual Checkup", status: "completed", pet: p1, vet: v1)
a3 = Appointment.create!(date: 10.days.ago, reason: "Ear cleaning", status: "completed", pet: p3, vet: v1)

# Upcoming and Scheduled (Will show in "Upcoming Appointments")
a4 = Appointment.create!(date: 1.day.from_now, reason: "Dental Checkup", status: "scheduled", pet: p1, vet: v1)
a5 = Appointment.create!(date: 4.days.from_now, reason: "Follow-up surgery", status: "scheduled", pet: p4, vet: v2)
a6 = Appointment.create!(date: 1.week.from_now, reason: "Wound Review", status: "scheduled", pet: p3, vet: v1)

# Current and In-Progress
a7 = Appointment.create!(date: Time.now, reason: "Emergency - broken leg", status: "in_progress", pet: p2, vet: v2)

# 5. Create Treatments
Treatment.create!(
  name: "General Cleaning", 
  medication: "None", 
  dosage: "N/A", 
  notes: "Patient is healthy", 
  administered_at: 2.days.ago, 
  appointment: a1
)

