class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validaciones
  validates :first_name, :last_name, presence: true

  # Enum para roles (importante el orden según el lab)
  enum :role, { owner: 0, vet: 1, admin: 2 }, default: :owner
end
