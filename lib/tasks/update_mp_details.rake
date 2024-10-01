# lib/tasks/update_conservative_mps.rake
require 'cgi'
require 'net/http'
require 'uri'
require 'json'

namespace :update do
  desc "Update details for Conservative MPs"
  task conservative_mps: :environment do
    Person.find_each do |person|
      normalized_name = person.name.gsub(/^(Mr|Mrs|Ms|Dr|Sir)\s+/, '').gsub(/\s+/, ' ')
      encoded_name = CGI.escape(normalized_name)

      url = "https://members-api.parliament.uk/api/Members/Search?Name=#{encoded_name}&skip=0&take=20"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)

      next if data['items'].empty?

      # Filter for active Conservative MPs
      active_conservative_mps = data['items'].select do |item|
        item['value']['latestParty']['abbreviation'].casecmp('con').zero? &&
        item['value']['latestHouseMembership']['membershipStatus'] &&
        item['value']['latestHouseMembership']['membershipStatus']['statusIsActive']
      end

      # Proceed if there's exactly one matching record
      if active_conservative_mps.size == 1
        mp_data = active_conservative_mps.first['value']
        constituency_data = mp_data['latestHouseMembership']
        constituency = Constituency.find_or_create_by(api_id: constituency_data['membershipFromId']) do |c|
          c.name = constituency_data['membershipFrom']
        end

        person.update(
          party: 'conservative',
          constituency: constituency,
          member_id: mp_data['id']
        )
      end
    end

    puts "Conservative MPs details updated."
  end
end
