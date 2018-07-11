class Hotel < ApplicationRecord
  include Publishable
  mount_uploader :logo, ImageUploader

  REGIONS_MAP = {
    'dangzai' => '氹仔区',
    'aomenbandao' => '澳门半岛',
  }.freeze
  validates :region, inclusion: { in: REGIONS_MAP.keys }, allow_blank: true
  validates :logo, presence: true, if: :new_record?
  has_many :comments, as: :target, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'
  has_many :hotel_rooms
  has_many :published_rooms, -> { where(published: true) }, class_name: 'HotelRoom'
  has_many :room_prices, class_name: 'HotelRoomPrice'

  scope :user_visible, -> { where(published: true) }
  scope :search_keyword, -> (keyword) { where('title like ?', "%#{keyword}%") }
  scope :where_region, -> (region) { where(region: region) }
  scope :price_desc, -> { order(start_price: :desc) }
  scope :price_asc, -> { order(start_price: :asc) }

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end

  def total_comments
    comments_count + replies_count
  end

<<<<<<< HEAD
  def wday_min_price(wday)
    room_prices.order(price: :asc).find_by(wday: wday)
=======
  def amap_navigation_url
    "https://uri.amap.com/navigation?to=#{amap_location},#{title}&src=kkapi&callnative=1"
>>>>>>> bcda7d9b86b2ad9de16d84913a7d4221ab1838d9
  end
end
