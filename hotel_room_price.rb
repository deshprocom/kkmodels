class HotelRoomPrice < ApplicationRecord
  attr_accessor :dates # 用于activeadmin的方法 t.input(dates) views/admin/room_prices/_form.html.haml

  belongs_to :hotel_room, required: false
  belongs_to :hotel, required: false
  belongs_to :sale_room_request, required: false
  # wday is the day of week (0-6, Sunday is zero).
  WDAYS = %w[sun mon tue wed thu fri sat].freeze
  validates :wday, inclusion: { in: WDAYS }, allow_nil: true
  validates :room_num_limit, presence: true

  after_initialize do
    self.date ||= Date.current unless is_master
  end

  scope :price_asc, -> { order(price: :asc) }

  # 每天剩余可售卖的数量
  def saleable_num
    room_num_limit - room_sales
  end

  def increase_sales(by)
    increment!(:room_sales, by)
  end

  def decrease_sales(by)
    decrement!(:room_sales, by)
  end
end
