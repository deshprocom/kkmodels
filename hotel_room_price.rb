class HotelRoomPrice < ApplicationRecord
  attr_accessor :dates # 用于activeadmin的方法 t.input(dates) views/admin/room_prices/_form.html.haml

  belongs_to :hotel_room, required: false
  belongs_to :hotel, required: false
  # wday is the day of week (0-6, Sunday is zero).
  WDAYS = %w[sun mon tue wed thu fri sat].freeze
  validates :wday, inclusion: { in: WDAYS }, allow_nil: true
  validates :date, uniqueness: { scope: :hotel_room_id }, allow_nil: true

  after_initialize do
    self.date ||= Date.current unless is_master
  end

  # 每天剩余可售卖的数量
  def saleable_num
    room_num_limit - room_sales
  end
end
