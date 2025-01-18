class Paste < ApplicationRecord
  has_one_attached :content_file

  before_validation :generate_slug, on: :create
  belongs_to :user, optional: true

  validates :title, presence: true, length: { maximum: 255 }
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
    if !content_file.attached?
      errors.add(:content_file, "can't be blank")
      return
    end
    if content_file.blob.byte_size > 1.kilobytes
      errors.add(:content_file, "size must be less than 1KB")
    end
  end
end
