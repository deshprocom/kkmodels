class WheelPrize < ApplicationRecord
  belongs_to :wheel_element
  has_many :cheap_prize_counts

  # validates :wheel_element, presence: true

  enum prize_type: { cheap: 'cheap', expensive: 'expensive', free: 'free' }
end