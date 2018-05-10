class Hotel < ApplicationRecord
  include Publishable
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'

  mount_uploader :logo, ImageUploader

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end
end
