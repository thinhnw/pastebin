class Paste < ApplicationRecord
  before_validation :generate_slug, on: :create
  has_one_attached :content_file
  belongs_to :user, optional: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :validate_file_attachment


  scope :ordered, -> { order(created_at: :desc) }

  def to_param
    slug
  end

  private
  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(3) # Generates a unique identifier for the paste
  end

  def validate_file_attachment
    return unless content_file.attached?
    if content_file.blob.byte_size > 1.kilobytes
      errors.add(:content_file, "size must be less than 1KB")
    end
  end
end
