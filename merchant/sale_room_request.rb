class SaleRoomRequest < ApplicationRecord
  mount_uploader :card_img, ImageUploader
  belongs_to :hotel
  belongs_to :hotel_room, foreign_key: :room_id
  belongs_to :merchant_user, foreign_key: :user_id
  has_one :hotel_room_price
  has_one :room_request_withdrawal

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }

  enum status: { pending: 'pending', 'passed': 'passed', 'refused': 'refused', canceled: 'canceled' }

  def self.on_offer
    where(is_sold: false).where('checkin_date >= ?', Date.current).passed
  end

  def self.sold
    where(is_sold: true).passed
  end

  def self.unsold
    where(is_sold: false).where('checkin_date < ?', Date.current).passed
  end

  CAN_CANCEL_STATUSES = %w[pending passed].freeze
  def can_cancel?
    status.in?(CAN_CANCEL_STATUSES) && !is_sold
  end

  def create_room_price
    create_hotel_room_price(date: checkin_date,
                            room_num_limit: 1,
                            is_master: false,
                            price: price,
                            hotel_id: hotel_id,
                            hotel_room_id: room_id)
  end

  def to_refund
    update(is_sold: false)
    merchant_user.decrease_revenue(price)
  end

  def to_sold
    update(is_sold: true)
    merchant_user.increase_revenue(price)
  end

  def withdrawn_status
    return 'unsubmit' if room_request_withdrawal.nil?

    room_request_withdrawal.status
  end
end
