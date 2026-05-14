# Limpiar datos previos para evitar duplicados
puts "Cleaning database..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all

puts "Creating owners..."
o1 = Owner.create!(first_name: "Coni", last_name: "Campos", email: "coni@example.com", phone: "123456")
o2 = Owner.create!(first_name: "Juan", last_name: "Perez", email: "juan@example.com", phone: "654321")

puts "Creating vets..."
v1 = Vet.create!(first_name: "Gregory", last_name: "House", email: "house@clinic.com", specialization: "Diagnostics")

puts "Creating pets..."
# pet1: Perro
p1 = Pet.create!(name: "Rex", species: "dog", breed: "German Shepherd", owner: o1)
# pet2: Gato
p2 = Pet.create!(name: "Mittens", species: "cat", breed: "Persian", owner: o1)
# pet3: Gato
p3 = Pet.create!(name: "Luna", species: "cat", breed: "Siamese", owner: o2)

puts "Attaching photos from db/seeds/pets/..."
# Mapeo de mascotas a sus archivos correspondientes
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
    puts "✅ Photo #{item[:file]} attached to #{item[:record].name}"
  else
    puts "❌ Error: File not found at #{path}"
  end
end

puts "Creating appointments..."
a1 = Appointment.create!(
  date: DateTime.now + 1.day, 
  reason: "General Checkup", 
  status: "scheduled", 
  pet: p1, 
  vet: v1
)

puts "Creating treatments with Action Text..."
# B.2 & C.1: Notas con formato enriquecido
t1 = Treatment.create!(
  name: "Annual Vaccination",
  medication: "Rabigen Plus",
  dosage: "1ml",
  administered_at: Time.now,
  appointment: a1,
  clinical_notes: "<h1>Clinical Report</h1><p>The patient was <strong>calm</strong> during the procedure.</p><ul><li>Monitor temperature for 24h</li><li>Keep hydrated</li><li>Next booster in 12 months</li></ul>"
)

puts "Creating users..."
# Admin
User.find_or_create_by!(email: 'admin@vetclinic.com') do |u|
  u.first_name = "Admin"
  u.last_name = "User"
  u.password = "password123"
  u.role = :admin
end

# Vet
User.find_or_create_by!(email: 'vet@vetclinic.com') do |u|
  u.first_name = "Gregory"
  u.last_name = "House"
  u.password = "password123"
  u.role = :vet
end

# Owner
User.find_or_create_by!(email: 'owner@vetclinic.com') do |u|
  u.first_name = "Coni"
  u.last_name = "Campos"
  u.password = "password123"
  u.role = :owner
end
puts "Users created: admin@vetclinic.com, vet@vetclinic.com, owner@vetclinic.com (all password: password123)"

puts "Seeds finished successfully! 🐾"
