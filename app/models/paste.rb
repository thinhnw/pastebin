class Paste < ApplicationRecord
  before_validation :generate_slug, on: :create

  has_one_attached :content_file
  validate :content_file_size_validation

  belongs_to :user, optional: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  def content_file_size_validation
    if content_file.attached? && content_file.blob.byte_size > 1.kilobytes
      errors.add(:content, "should be less than 1KB")
    end
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(3) # Generates a unique identifier for the paste
  end
end
