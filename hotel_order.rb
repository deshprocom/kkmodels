class HotelOrder < ApplicationRecord
  belongs_to :hotel_room
  has_many :checkin_infos

  serialize :room_items, JSON

  def total_price_from_items
    room_items.map{|i| i['price'].to_f }.sum
  end
end
