class HotelOrder < ApplicationRecord
  belongs_to :user
  belongs_to :hotel_room
  has_many :checkin_infos

  serialize :room_items, JSON

  enum status: { unpaid: 'unpaid',
                 paid: 'paid',
                 confirmed: 'confirmed' }

  PAY_STATUSES = %w[unpaid paid].freeze
  validates :pay_status, inclusion: { in: PAY_STATUSES }

  def total_price_from_items
    room_items.map{|i| i['price'].to_f }.sum
  end

  def nights_num
    (checkout_date - checkin_date).to_i
  end
end
