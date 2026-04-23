class Appointment < ApplicationRecord
  belongs_to :pet
  belongs_to :vet
  has_many :treatments

  enum :status, { scheduled: 0, in_progress: 1, completed: 2, cancelled: 3 }

  validates :date, :reason, :status, presence: true

  # Scopes
  scope :upcoming, -> { where('date > ?', Time.now).order(date: :asc) }
  scope :past, -> { where('date <= ?', Time.now).order(date: :desc) }
end 