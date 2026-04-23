class Pet < ApplicationRecord
  belongs_to :owner
  has_many :appointments

  validates :name, :species, :date_of_birth, :weight, presence: true
  validates :species, inclusion: { in: %w[dog cat rabbit bird reptile other] }
  validates :weight, numericality: { greater_than: 0 }
  validate :date_of_birth_cannot_be_in_the_future

  before_save :capitalize_name

  # Scope
  scope :by_species, ->(species) { where(species: species) }

  private
  def date_of_birth_cannot_be_in_the_future
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, "can't be in the future")
    end
  end

  def capitalize_name
    self.name = name.capitalize
  end
end 