class TopicImage < ApplicationRecord
  mount_uploader :image, ImageUploader

  def image_url
    return '' if image&.url.nil?

    image.url
  end

  def preview_image
    return '' if image&.path.nil?

    image.url(:sm)
  end
end