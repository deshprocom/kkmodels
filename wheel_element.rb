class WheelElement < ApplicationRecord
  scope :position_desc, -> { order(position: :desc) }
end
