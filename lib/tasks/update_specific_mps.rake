# lib/tasks/update_specific_mps.rake
namespace :update do
  desc "Update member_id for specific MPs"
  task specific_mps: :environment do
    # Define the mappings for specific MPs and their member_ids
    specific_mps = {
      'Paul Holmes' => 4803,
      'Mike Wood' => 4384,
      'Lee Anderson' => 4743
    }

    specific_mps.each do |name, member_id|
      person = Person.find_by(name: name)

      if person.nil?
        puts "Person with name '#{name}' not found."
      else
        if person.member_id.nil?
          person.update(member_id: member_id)
          puts "Updated member_id for #{name} successfully."
        else
          puts "#{name} already has a member_id, skipping update."
        end
      end
    end
  end
end
