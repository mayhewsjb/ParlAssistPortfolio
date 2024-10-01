# This really works for majority updating. Skips skidmore as no longer mp

namespace :update_majority do
  desc 'Update majority for people from API'
  task update: :environment do
    require 'net/http'
    require 'json'

    Person.find_each do |person|
      member_id = person.member_id
      uri = URI("https://members-api.parliament.uk/api/Members/#{member_id}/LatestElectionResult")

      begin
        response = Net::HTTP.get(uri)

        # Check if the response is valid JSON
        begin
          json_response = JSON.parse(response)
        rescue JSON::ParserError => e
          puts "Skipping invalid JSON response for person #{person.name} (ID: #{person.id})"
          next
        end

        # Extract majority from API response
        majority = json_response.dig('value', 'majority')

        # Update person's majority in the database if it's present
        if majority.present?
          person.update(majority: majority)
          puts "Updated majority for person #{person.name} (ID: #{person.id})"
        else
          puts "Majority data not found for person #{person.name} (ID: #{person.id}). Skipping..."
        end
      rescue StandardError => e
        puts "Error processing person #{person.name} (ID: #{person.id}): #{e.message}"
      end
    end
  end
end
