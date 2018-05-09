class Hotel < ApplicationRecord
  include Publishable

  mount_uploader :logo, ImageUploader

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end
end
