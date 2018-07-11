class HotelRoom < ApplicationRecord
  include Publishable

  belongs_to :hotel

  has_many :wday_prices,
          -> { where is_master: true },
          class_name: 'HotelRoomPrice'

  HotelRoomPrice::WDAYS.each do |wday|
    has_one "#{wday}_price".to_sym, -> { where(is_master: true, wday: wday) }, class_name: 'HotelRoomPrice'
  end

  has_many :prices,
           -> { where(is_master: false).order(date: :asc) },
           class_name: 'HotelRoomPrice'
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'

  def tags
    text_tags.split(/,\s*/)
  end

  def notes
    text_notes.split(/,\s*/)
  end
end
