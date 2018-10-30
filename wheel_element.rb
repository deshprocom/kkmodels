class WheelElement < ApplicationRecord
  scope :position_desc, -> { order(position: :desc) }
  mount_uploader :image, ImageUploader
end
