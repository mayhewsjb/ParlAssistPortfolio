# lib/tasks/calculate_constituency_area.rake
require 'httparty'

namespace :area do
  desc 'Calculate and save area for all people'
  task calculate: :environment do
    Person.all.each do |person|
      puts "Starting to process #{person.name} with member ID #{person.member_id}"

      response = HTTParty.get("https://members-api.parliament.uk/api/Members/#{person.member_id}")
      if response.success?
        puts "Successfully fetched member details for #{person.name}"
        constituency_id = response.parsed_response['value']['latestHouseMembership']['membershipFromId']
        puts "Constituency ID for #{person.name} is #{constituency_id}"

        geometry_response = HTTParty.get("https://members-api.parliament.uk/api/Location/Constituency/#{constituency_id}/Geometry")
        if geometry_response.success?
          puts "Successfully fetched geometry data for #{person.name}"
          geometry_data = geometry_response.parsed_response['value']

          # Parse the geometry data if it's a string
          geometry_data = JSON.parse(geometry_data) if geometry_data.is_a?(String)

          if geometry_data && geometry_data['type'] == 'Polygon'
            polygon_coordinates = geometry_data['coordinates'].first
            area_sq_meters = calculate_area(polygon_coordinates)
            area_sq_km = area_sq_meters / 1_000_000

            if person.update(area: area_sq_km)
              puts "Updated area for #{person.name}: #{area_sq_km} square kilometers."
            else
              puts "Failed to update area for #{person.name}."
            end
          else
            puts "Invalid or missing geometry data for #{person.name}."
          end
        else
          puts "Failed to fetch geometry data for #{person.name}."
        end
      else
        puts "Failed to fetch member details for #{person.name}."
      end
    end
  end

  def calculate_area(coordinates)
    return 0 if coordinates.length < 3 # Not a polygon

    area = 0.0
    coordinates.each_with_index do |coord, i|
      next_coord = coordinates[(i + 1) % coordinates.length]
      area += coord[0] * next_coord[1] - next_coord[0] * coord[1]
    end
    area.abs * 0.5 * 12364 # Rough conversion from lat/lon to square meters
  end
end
