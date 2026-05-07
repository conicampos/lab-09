class Treatment < ApplicationRecord
  belongs_to :appointment
  
  has_rich_text :clinical_notes

  validates :name, :administered_at, presence: true
end