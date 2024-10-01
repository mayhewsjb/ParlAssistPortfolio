class CommitteeMembership < ApplicationRecord
  belongs_to :person
  belongs_to :committee
end
