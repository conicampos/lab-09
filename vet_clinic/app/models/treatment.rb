class Treatment < ApplicationRecord
  belongs_to :appointment
  validates :name, :administered_at, presence: true
end 