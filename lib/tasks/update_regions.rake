# This works - for all but 4 which are in the notes

require 'roo'

namespace :update_regions do
  desc "Find each person in the Excel sheet by name and constituency, report the location, and update the associated region if not already set"
  task find_people_and_groups: :environment do
    xlsx = Roo::Spreadsheet.open('./lib/data/Region excel book.xlsx')
    sheet = xlsx.sheet(0)
    not_found = []
    already_assigned = []

    Person.find_each do |person|
      puts "Searching for: #{person.name}"

      # Skip updating if the person already has a region_id
      if person.region_id.present?
        already_assigned << person.name
        puts "#{person.name} already has a region assigned."
        next
      end

      first_name, last_name = person.name.split
      excel_name = "#{last_name}, #{first_name}"

      found_row = nil
      row_number = 0

      # Search for the person by name
      sheet.each_row_streaming do |row|
        row_number += 1
        row.each_with_index do |cell, index|
          if cell.value.to_s.strip == excel_name
            puts "Found #{person.name} at row #{row_number}, column #{index + 1}"
            found_row = row_number
            break
          end
        end
        break if found_row
      end

      # If not found by name, search by constituency
      if found_row.nil?
        row_number = 0
        sheet.each_row_streaming do |row|
          row_number += 1
          row.each_with_index do |cell, index|
            if cell.value.to_s.strip == person.constituency
              puts "Found #{person.name}'s constituency at row #{row_number}, column #{index + 1}"
              found_row = row_number
              break
            end
          end
          break if found_row
        end
      end

      # Attempt to find and assign the group if the person or constituency was found
      if found_row
        group_name = nil
        found_row.downto(1) do |i|
          if sheet.cell(i, 1).to_s.include?("Group")
            group_name = sheet.cell(i, 1).to_s.strip
            puts "Associated group for #{person.name} is #{group_name} found at row #{i}"
            break
          end
        end

        if group_name
          region = Region.find_by(name: group_name)
          if region
            person.update(region_id: region.id)
            puts "Updated #{person.name}'s region to #{region.name}"
          else
            puts "Region not found in the database: #{group_name}"
            not_found << person.name
          end
        else
          not_found << "#{person.name} (group not found)"
        end
      else
        not_found << "#{person.name} (MP or constituency not found)"
      end
    end

    if not_found.any?
      puts "Persons not updated due to errors: "
      not_found.each { |person| puts person }
    end

    if already_assigned.any?
      puts "Persons already assigned a region (not updated):"
      already_assigned.each { |person| puts person }
    end
  end
end
