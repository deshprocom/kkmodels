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
  scope :user_visible, -> { where(published: true) }
  scope :search_keyword, -> (keyword) { where('title like ?', "%#{keyword}%") }
  scope :where_region, -> (region) { where(region: region) }
  scope :position_desc, -> { order(position: :desc) }

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end

  def total_comments
    comments_count + replies_count
  end

  def amap_navigation_url
    "https://uri.amap.com/navigation?to=#{amap_location},#{title}&src=kkapi&callnative=1"
  end

  # priceable
  has_many :room_prices, class_name: 'HotelRoomPrice'
  scope :price_desc, -> (date) { order(s_wday_min_price(date) => :desc) }
  scope :price_asc, -> (date) { order(s_wday_min_price(date) => :asc) }

  def self.s_wday_min_price(date)
    "#{HotelRoomPrice::WDAYS[date.wday]}_min_price"
  end

  def wday_min_price(wday)
    room_prices.joins(:hotel_room).order(price: :asc)
      .find_by(hotel_rooms: { published: true }, wday: wday, is_master: true)
  end

  # 当前日期最低价格，剔除未发布的
  def date_min_price(date)
    room_prices.joins(:hotel_room).order(price: :asc)
      .find_by(hotel_rooms: { published: true }, date: date, is_master: false)
  end

  def default_wday_price(date)
    self.send(Hotel.s_wday_min_price date)
  end

  # 如果没有当天的最低价，则默认当天周几的最低价
  def min_price(date)
    date_min_price(date)&.price || default_wday_price(date)
  end
end
