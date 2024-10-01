# lib/tasks/assign_mps.rake

namespace :assign do
  desc "Assign MPs to their respective regions"
  task mps: :environment do
    # Define mappings of MPs to their regions
    mp_regions = {
      "Dr Lisa Cameron" => "Group 13 Wales + Scotland",
      "Sir Alok Sharma" => "Group 6 Berkshire + Buckinghamshire + Oxfordshire",
      "Mr Robin Walker" => "Group 11 Herefordshire + Shropshire + Staffordshire",
      "Nadhim Zahawi" => "Group 12 West Midlands + Warwickshire"
    }

    # Iterate over the mappings
    mp_regions.each do |mp_name, region_name|
      person = Person.find_by(name: mp_name)
      if person
        # If the person is found, find the corresponding region
        region = Region.find_by(name: region_name)
        if region
          # If the region is found, assign it to the person
          person.update(region: region)
          puts "Assigned #{mp_name} to #{region_name}"
        else
          # If the region is not found, print a message
          puts "Region not found for #{mp_name}"
        end
      else
        # If the person is not found, print a message
        puts "MP not found for #{mp_name}"
      end
    end
  end
end
