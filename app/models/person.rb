class Person < ApplicationRecord
  attr_accessor :creating_user_id
  enum party: { Conservative: 0, Labour: 1, liberalDemocrats: 2, snp: 3, other: 4 }
  has_many :updates, dependent: :destroy
  has_many :committee_memberships, dependent: :destroy
  has_many :committees, through: :committee_memberships
  has_many :government_posts, dependent: :destroy
  belongs_to :region, optional: true

  # Removed belongs_to :user association
  # Removed attr_accessor :author_id as it's no longer needed

  # validates :member_id, presence: true, uniqueness: true
  # validates :active_status, inclusion: { in: [true, false] }

  after_create :create_initial_update

  def active_membership?
    active_status && (membership_end_date.nil? || membership_end_date.future?)
  end

  def last_name
    # This will split the name by spaces and return the last element.
    # It's a simplistic approach and might need adjustment for edge cases.
    name.split(' ').last
  end

  private

  def create_initial_update
    updates.create(content: "Automatic Update ** Person created **", user_id: creating_user_id)
  end
end
