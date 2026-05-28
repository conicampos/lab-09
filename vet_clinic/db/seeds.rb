# Reset demo data in dependency order.
puts "Cleaning database..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all
User.destroy_all

PASSWORD = "password123"

puts "Creating users..."
admin_user = User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@vetclinic.com",
  password: PASSWORD,
  role: :admin
)

vet_user = User.create!(
  first_name: "Gregory",
  last_name: "House",
  email: "vet@vetclinic.com",
  password: PASSWORD,
  role: :vet
)

owner_user = User.create!(
  first_name: "Coni",
  last_name: "Campos",
  email: "owner@vetclinic.com",
  password: PASSWORD,
  role: :owner
)

puts "Creating owners..."
o1 = Owner.create!(first_name: "Coni", last_name: "Campos", email: "coni@example.com", phone: "123456", user: owner_user)
o2 = Owner.create!(first_name: "Juan", last_name: "Perez", email: "juan@example.com", phone: "654321")

puts "Creating vets..."
v1 = Vet.create!(first_name: "Gregory", last_name: "House", email: "house@clinic.com", specialization: "Diagnostics", user: vet_user)
v2 = Vet.create!(first_name: "Meredith", last_name: "Grey", email: "grey@clinic.com", specialization: "Surgery")

puts "Creating pets..."
p1 = Pet.create!(name: "Rex", species: "dog", breed: "German Shepherd", owner: o1)
p2 = Pet.create!(name: "Mittens", species: "cat", breed: "Persian", owner: o1)
p3 = Pet.create!(name: "Luna", species: "cat", breed: "Siamese", owner: o2)

puts "Attaching photos from db/seeds/pets/..."
pet_photos = [
  { record: p1, file: "pet1.jpeg" },
  { record: p2, file: "pet2.jpeg" },
  { record: p3, file: "pet3.jpeg" }
]

pet_photos.each do |item|
  path = Rails.root.join("db", "seeds", "pets", item[:file])

  if File.exist?(path)
    item[:record].photo.attach(
      io: File.open(path),
      filename: item[:file],
      content_type: "image/jpeg"
    )
    puts "Photo #{item[:file]} attached to #{item[:record].name}"
  else
    puts "Error: File not found at #{path}"
  end
end

puts "Creating appointments..."
a1 = Appointment.create!(
  date: 1.day.from_now,
  reason: "General Checkup",
  status: "scheduled",
  pet: p1,
  vet: v1
)

a2 = Appointment.create!(
  date: 2.days.from_now,
  reason: "Dental Cleaning",
  status: "scheduled",
  pet: p2,
  vet: v2
)

a3 = Appointment.create!(
  date: 3.days.from_now,
  reason: "Skin Irritation",
  status: "in_progress",
  pet: p3,
  vet: v1
)

a4 = Appointment.create!(
  date: 4.days.from_now,
  reason: "Surgery Consultation",
  status: "scheduled",
  pet: p3,
  vet: v2
)

puts "Creating treatments with Action Text..."
Treatment.create!(
  name: "Annual Vaccination",
  medication: "Rabigen Plus",
  dosage: "1ml",
  administered_at: Time.current,
  appointment: a1,
  clinical_notes: "<h1>Clinical Report</h1><p>The patient was <strong>calm</strong> during the procedure.</p><ul><li>Monitor temperature for 24h</li><li>Keep hydrated</li><li>Next booster in 12 months</li></ul>"
)

Treatment.create!(
  name: "Antihistamine",
  medication: "Cetirizine",
  dosage: "5mg",
  administered_at: Time.current,
  appointment: a3,
  clinical_notes: "<p>Initial dose administered. Recheck if symptoms continue.</p>"
)

Treatment.create!(
  name: "Pre-op Bloodwork",
  medication: "N/A",
  dosage: "N/A",
  administered_at: Time.current,
  appointment: a4,
  clinical_notes: "<p>Baseline panel collected before surgery consultation.</p>"
)

puts "Seeded users:"
puts "Admin: admin@vetclinic.com / #{PASSWORD}"
puts "Vet: vet@vetclinic.com / #{PASSWORD}"
puts "Owner: owner@vetclinic.com / #{PASSWORD}"
puts "Seeds finished successfully."
