# lib/tasks/update_conservative_mps.rake
require 'cgi'
require 'net/http'
require 'uri'
require 'json'

namespace :update do
  desc "Update details for Conservative MPs"
  task conservative_mps: :environment do
    Person.find_each do |person|
      # Normalize the name: remove titles and replace multiple spaces with a single space
      normalized_name = person.name.gsub(/^(Mr|Mrs|Ms|Dr|Sir)\s+/, '').gsub(/\s+/, ' ')
      encoded_name = CGI.escape(normalized_name)

      url = "https://members-api.parliament.uk/api/Members/Search?Name=#{encoded_name}&skip=0&take=20"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)

      next if data['items'].empty?

      mp_data = data['items'].first['value']

      # Check if the MP is Conservative and update details
      if mp_data['latestParty']['abbreviation'].casecmp('con').zero?
        # Update only the party and member_id fields
        person.update(
          party: 'Conservative',
          member_id: mp_data['id']
        )

        puts "Updated member id and party successfully for #{person.name}"
      end
    end

    puts "Conservative MPs details updated."
  end
end
