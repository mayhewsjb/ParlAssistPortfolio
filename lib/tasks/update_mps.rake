# lib/tasks/update_mps.rake
namespace :update do
  desc "Update MPs data from the Parliamentary API"
  task mps: :environment do
    require 'net/http'
    require 'cgi'

    Person.find_each do |person|
      name = CGI.escape(person.name)  # This ensures the name is URL-encoded properly
      url = "https://members-api.parliament.uk/api/Members/Search?Name=#{name}&skip=0&take=20"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)

      next if data['items'].empty?

      mp_data = data['items'].first['value']
      constituency_api_id = mp_data['latestHouseMembership']['membershipFromId']

      constituency = Constituency.find_or_create_by(api_id: constituency_api_id) do |c|
        c.name = mp_data['latestHouseMembership']['membershipFrom']
        # Set other necessary Constituency attributes here
      end

      person.update(constituency: constituency)
      # Update party and other fields as needed
    end

    puts "MPs data updated."
  end
end
