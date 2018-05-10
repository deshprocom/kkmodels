class AdminImage < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :imageable, polymorphic: true

  def preview
    return '' if image&.url.nil?

    image.url(:sm)
  end
end
