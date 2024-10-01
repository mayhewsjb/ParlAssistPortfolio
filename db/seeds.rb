# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Ensure there's at least one user in your database for this to work
user = User.find(1)

5.times do |i|
  person = Person.create!(
    name: "Person #{i + 1}",
    party: Person.parties.keys.sample, # Randomly assign a party from the defined enum
    constituency: "Constituency #{i + 1}",
    role: "Role #{i + 1}",
    notes: "Notes for Person #{i + 1}",
    user_id: user.id # Directly set the user ID for the created person
  )

  5.times do |j|
    person.updates.create!(
      content: "Update #{j + 1} for #{person.name}",
      user_id: user.id # Directly set the user ID for the created update
    )
  end
end

puts 'Seeded 5 people with 5 updates each, all belonging to user ID 1.'
