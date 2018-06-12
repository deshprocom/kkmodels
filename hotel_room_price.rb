class HotelRoomPrice < ApplicationRecord
  belongs_to :hotel_room, required: false

  after_initialize do
    self.date ||= Date.current
  end
end
