class Unity < ApplicationRecord
  belongs_to :formation_module

  validates :name, presence: true
end
