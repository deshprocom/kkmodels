class HotelRoomPrice < ApplicationRecord
  belongs_to :hotel_room, required: false
  belongs_to :hotel, required: false

  # wday is the day of week (0-6, Sunday is zero).
  WDAYS = %w[sun mon tue wed thu fri sat].freeze
  validates :wday, inclusion: { in: WDAYS }

  after_initialize do
    self.date ||= Date.current unless is_master
  end
end
