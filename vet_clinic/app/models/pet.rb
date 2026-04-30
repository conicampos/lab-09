class Pet < ApplicationRecord
  belongs_to :owner
  has_many :appointments, dependent: :destroy
  
  validates :name, :species, presence: true

  
  def appointments_upcoming
    appointments.where('date >= ?', Time.now)
  end

  def appointments_past
    appointments.where('date < ?', Time.now)
  end
end