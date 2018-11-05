class WheelCount < ApplicationRecord
  include WheelCountCreator
  include WheelCountIncrement

  enum count_type: { daily: 'daily', total: 'total' }
end
