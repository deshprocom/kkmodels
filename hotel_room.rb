class HotelRoom < ApplicationRecord
  attr_accessor :room_num_limit # 用于activeadmin的方法 t.input(room_num_limit)

  include Publishable

  belongs_to :hotel
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'

  def tags
    text_tags.split(/,\s*/)
  end

  def notes
    text_notes.split(/,\s*/)
  end

  # priceable
  has_many :hotel_room_prices, dependent: :delete_all
  has_many :wday_prices, -> { where is_master: true }, class_name: 'HotelRoomPrice'
  has_many :prices, -> { where(is_master: false).order(date: :asc) }, class_name: 'HotelRoomPrice'
  # 重复了 room_prices 是为了使用activeadmin的 admin/room_prices#index 方法
  has_many :room_prices, -> { where(is_master: false) }, class_name: 'HotelRoomPrice'
  HotelRoomPrice::WDAYS.each do |wday|
    has_one "#{wday}_price".to_sym,
            -> { where(is_master: true, wday: wday) },
            class_name: 'HotelRoomPrice'
  end

  def self.s_wday_price(date)
    "#{HotelRoomPrice::WDAYS[date.wday]}_price"
  end

  def wday_price(date)
    self.send(HotelRoom.s_wday_price date)
  end

  # 默认的 wday的room_num_list 都是一样的
  def room_num_limit
    @room_num_limit ||= wday_prices.first&.room_num_limit
  end
end
