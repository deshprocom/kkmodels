class HotelRoom < ApplicationRecord
  include Publishable

  belongs_to :hotel
  has_one :master,
          -> { where is_master: true },
          class_name: HotelRoomPrice
  accepts_nested_attributes_for :master, update_only: true

  has_many :prices,
           -> { where(is_master: false).order(date: :asc) },
           class_name: HotelRoomPrice
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'
end
