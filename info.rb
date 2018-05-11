class Info < ApplicationRecord
  include Publishable
  include Stickable
  mount_uploader :image, ImageUploader

  belongs_to :info_type

  after_initialize do
    self.date ||= Date.current
  end

  def preview_image
    return '' if image&.url.nil?

    image.url(:sm)
  end
end
