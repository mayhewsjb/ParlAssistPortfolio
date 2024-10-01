# lib/tasks/update_mp_membership_details.rake
require 'net/http'
require 'uri'
require 'json'

namespace :update do
  desc "Update membership details for MPs"
  task mp_membership_details: :environment do
    Person.find_each do |person|
      next if person.member_id.blank?

      url = "https://members-api.parliament.uk/api/Members/#{person.member_id}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)

      next if data['value'].nil?

      membership_data = data['value']['latestHouseMembership']

      person.update(
        membership_start_date: membership_data['membershipStartDate'],
        membership_end_date: membership_data['membershipEndDate'],
        active_status: membership_data['membershipStatus'] && membership_data['membershipStatus']['statusIsActive']
      )

      puts "Membership details updated for #{person.name}."
    end

    puts "All MP membership details updated."
  end
end
