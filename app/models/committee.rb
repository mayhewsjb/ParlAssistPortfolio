class Committee < ApplicationRecord
  has_many :committee_memberships, dependent: :destroy
  has_many :people, through: :committee_memberships
end
