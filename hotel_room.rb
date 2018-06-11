class HotelRoom < ApplicationRecord
  belongs_to :hotel
  has_one :master,
          -> { where is_master: true },
          class_name: HotelRoomPrice
  accepts_nested_attributes_for :master, update_only: true

  has_many :prices,
           -> { where(is_master: false).order(date: :asc) },
           class_name: HotelRoomPrice
end
