class Pet < ApplicationRecord
  belongs_to :owner
  has_many :appointments, dependent: :destroy
  
  
  has_one_attached :photo

  validates :name, :species, presence: true
  
  
  validate :acceptable_photo

  def appointments_upcoming
    appointments.where('date >= ?', Time.now)
  end

  def appointments_past
    appointments.where('date < ?', Time.now)
  end

  private

  def acceptable_photo
    return unless photo.attached?

    unless photo.blob.byte_size <= 5.megabytes
      errors.add(:photo, "is too big (max 5MB)")
    end

    acceptable_types = ["image/jpeg", "image/png", "image/webp"]
    unless acceptable_types.include?(photo.content_type)
      errors.add(:photo, "must be a JPEG, PNG or WebP")
    end
  end
end