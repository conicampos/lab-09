class Owner < ApplicationRecord
  has_many :pets
  
  validates :first_name, :last_name, :phone, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :normalize_email

  private
  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end 