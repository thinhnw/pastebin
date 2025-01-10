class Paste < ApplicationRecord
  before_validation :generate_slug, on: :create

  has_one_attached :content_file

  belongs_to :user, optional: true

  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(3) # Generates a unique identifier for the paste
  end
end
