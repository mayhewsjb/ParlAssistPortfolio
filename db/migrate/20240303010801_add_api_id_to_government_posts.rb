class AddApiIdToGovernmentPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :government_posts, :api_id, :integer
  end
end
