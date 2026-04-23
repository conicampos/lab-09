class Vet < ApplicationRecord
  has_many :appointments
  
  validates :first_name, :last_name, :specialization, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :normalize_email

  # Scope
  scope :by_specialization, ->(spec) { where(specialization: spec) }

  private
  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end 