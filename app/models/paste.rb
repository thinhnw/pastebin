class Paste < ApplicationRecord
  before_create :generate_slug

  has_one_attached :content_file

  private

  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(3) # Generates a unique identifier for the paste
  end
end
