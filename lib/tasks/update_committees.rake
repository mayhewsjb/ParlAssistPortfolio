namespace :update do
  desc "Update committee memberships for MPs"
  task update_committees: :environment do
    require 'net/http'
    require 'uri'
    require 'json'

    Person.find_each do |person|
      next unless person.member_id

      url = URI("https://members-api.parliament.uk/api/Members/#{person.member_id}/Biography")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      next unless data['value'] && data['value']['committeeMemberships']

      data['value']['committeeMemberships'].each do |membership|
        committee = Committee.find_or_create_by(api_committee_id: membership['id']) do |c|
          c.name = membership['name']
          c.additional_info = membership['additionalInfo']
          c.additional_info_link = membership['additionalInfoLink']
        end

        CommitteeMembership.find_or_create_by(person: person, committee: committee) do |cm|
          cm.start_date = membership['startDate']
          cm.end_date = membership['endDate']
        end
      end

      puts "Updated committee memberships for #{person.name}"
    end
  end
end
