class Tagging < ApplicationRecord
  belongs_to :related_update, class_name: 'Update'
  belongs_to :tag
end
