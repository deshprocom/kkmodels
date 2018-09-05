class SaleRoomRequest < ApplicationRecord
  mount_uploader :card_img, ImageUploader
  belongs_to :hotel
  belongs_to :hotel_room, foreign_key: :room_id
  belongs_to :merchant_user, foreign_key: :user_id

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }

  enum status: { pending: 'pending', 'passed': 'passed', 'refused': 'refused', canceled: 'canceled' }

  def on_offer
    where(is_sold: false).where('checkin_date >= ?', Date.current).passed
  end

  def sold
    where(is_sold: true).passed
  end

  def unsold
    where(is_sold: false).where('checkin_date < ?', Date.current).passed
  end

  CAN_CANCEL_STATUSES = %w[pending passed].freeze
  def can_cancel?
    status.in?(CAN_CANCEL_STATUSES) && !is_sold
  end
end
