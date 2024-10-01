# lib/tasks/import_mps.rake
namespace :import do
  desc "Import MPs from the 23.11.csv file, only for the Conservative party"
  task mps: :environment do
    require 'csv'

    # Specify the system or admin user ID here
    system_user_id = 1

    csv_path = Rails.root.join('lib', 'data', '23.11.csv')
    CSV.foreach(csv_path, headers: true) do |row|
      # Only process rows where the party is 'Conservative'
      next unless row['Party'].strip.casecmp('Conservative').zero?

      person = Person.new(
        name: row['Name (Display As)'],
        email: row['Email']
        # Add other fields as necessary
      )

      # Set the creating_user_id for the callback to work
      person.creating_user_id = system_user_id

      # Save the person, triggering the after_create callback
      person.save!
    end

    puts "Imported Conservative MPs from #{csv_path} and created initial updates"
  end
end
