class Update < ApplicationRecord
  belongs_to :person
  belongs_to :user

  has_many :taggings, foreign_key: 'related_update_id', dependent: :destroy
  has_many :tags, through: :taggings
end
