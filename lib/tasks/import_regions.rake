# lib/tasks/import_regions.rake
namespace :import do
  desc "Import region names from the Excel file"
  task import_regions: :environment do
    require 'roo'

    xlsx_path = Rails.root.join('lib', 'data', 'Region excel book.xlsx')
    xlsx = Roo::Excelx.new(xlsx_path.to_s)

    xlsx.each_row_streaming(offset: 0) do |row|
      next unless row[0].present?

      cell_value = row[0].cell_value.strip
      if cell_value.start_with?('Group')
        # Extract the region name while keeping the "Group" part
        region_name = cell_value.strip
        Region.find_or_create_by(name: region_name)
      end
    end

    puts "Region names have been imported."
  end
end
