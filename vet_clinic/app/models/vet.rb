class Vet < ApplicationRecord
  belongs_to :user, optional: true
  has_many :appointments, dependent: :destroy
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
