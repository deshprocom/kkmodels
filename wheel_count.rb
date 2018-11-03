class WheelCount < ApplicationRecord
  include WheelCountCreator
  include WheelCountIncrement
end
