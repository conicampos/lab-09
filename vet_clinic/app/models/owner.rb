class Owner < ApplicationRecord
  has_many :pets, dependent: :destroy
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end