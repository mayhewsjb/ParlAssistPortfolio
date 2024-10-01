class Tag < ApplicationRecord
  has_many :taggings
  has_many :updates, through: :taggings, source: :related_update

  validates :name, uniqueness: { case_sensitive: false }

  before_destroy :check_for_updates

  private

  def check_for_updates
    if updates.any?
      errors.add(:base, 'Cannot delete tag because it has one or more updates.')
      throw(:abort)
    end
  end
end
