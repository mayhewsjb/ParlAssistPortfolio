namespace :update do
  desc "Update Government Posts for MPs"
  task update_government_posts: :environment do
    require 'net/http'
    require 'uri'
    require 'json'

    Person.find_each do |person|
      next unless person.member_id

      url = URI("https://members-api.parliament.uk/api/Members/#{person.member_id}/Biography")
      response = Net::HTTP.get(url)
      data = JSON.parse(response) if response

      next unless data && data['value'] && data['value']['governmentPosts']

      data['value']['governmentPosts'].each do |post|
        next unless post['house'] == 1  # Ensure it's a House of Commons post

        GovernmentPost.find_or_create_by(person_id: person.id, api_id: post['id']) do |gov_post|
          gov_post.name = post['name']
          gov_post.start_date = post['startDate']
          gov_post.end_date = post['endDate'] || nil  # Set to nil if endDate is not present
          gov_post.additional_info = post['additionalInfo']
          gov_post.additional_info_link = post['additionalInfoLink']
        end
      end

      puts "Updated government posts for #{person.name}"
    end
  end
end
