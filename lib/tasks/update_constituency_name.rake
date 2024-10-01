namespace :update_constituency_name do
  desc 'Update constituency names for people from API'
  task :update => :environment do
    require 'net/http'
    require 'json'

    # Iterate through each person in the database
    Person.all.each do |person|
      # Make API call to get latest membership information
      member_id = person.member_id
      uri = URI("https://members-api.parliament.uk/api/Members/#{member_id}")
      response = Net::HTTP.get(uri)
      json_response = JSON.parse(response)

      # Extract constituency name from API response
      constituency_name = json_response.dig('value', 'latestHouseMembership', 'membershipFrom')

      # Update person's constituency name in the database if it's different
      if constituency_name.present? && person.constituency != constituency_name
        person.update(constituency: constituency_name)
        puts "Updated constituency name for person #{person.name} (ID: #{person.id})"
      end
    end
  end
end
