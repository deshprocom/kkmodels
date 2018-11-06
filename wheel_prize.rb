class WheelPrize < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :wheel_element
  has_many :cheap_prize_counts

  # validates :wheel_element, presence: true

  enum prize_type: { cheap: 'cheap', expensive: 'expensive', free: 'free' }

  def preview_image
    return '' if image&.url.nil?

    image.url(:sm)
  end
end
