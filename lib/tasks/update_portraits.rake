require 'net/http'
require 'uri'
require 'json'

namespace :update do
  desc "Update MPs' portrait urls with thumbnail urls"
  task update_portraits: :environment do
    Person.find_each do |person|
      next unless person.member_id

      uri = URI("https://members-api.parliament.uk/api/Members/#{person.member_id}/ThumbnailUrl")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)

      thumbnail_url = data['value'] if data && data['value']

      if thumbnail_url
        person.update(portrait_url: thumbnail_url)
        puts "Updated thumbnail for #{person.name}"
      else
        puts "No thumbnail found for #{person.name}"
      end
    end
  end
end
# this was altered to remove the portrait url and replace with thumnail so move with caution
