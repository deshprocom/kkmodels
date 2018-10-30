class WheelPrize < ApplicationRecord
  belongs_to :wheel_element

  # validates :wheel_element, presence: true

  enum prize_type: { cheap: 'cheap', expensive: 'expensive', free: 'free' }
end
