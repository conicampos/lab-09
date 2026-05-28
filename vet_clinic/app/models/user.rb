class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :owner, dependent: :nullify
  has_one :vet, dependent: :nullify

  # Validaciones
  validates :first_name, :last_name, presence: true

  # Enum para roles (importante el orden según el lab)
  enum :role, { owner: 0, vet: 1, admin: 2 }, default: :owner
end
