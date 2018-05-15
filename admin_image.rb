class AdminImage < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :imageable, polymorphic: true, optional: true

  def preview
    return '' if image&.url.nil?

    image.url(:sm)
  end

  def original
    image.url
  end
end
