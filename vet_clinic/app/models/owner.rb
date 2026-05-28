class Owner < ApplicationRecord
  belongs_to :user, optional: true
  has_many :pets, dependent: :destroy
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
