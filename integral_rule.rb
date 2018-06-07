class IntegralRule < ApplicationRecord
  mount_uploader :icon, ImageUploader

  def icon_path
    icon.url.presence || ""
  end
end
