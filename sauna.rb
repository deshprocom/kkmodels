class Sauna < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude

  include Publishable
  mount_uploader :logo, ImageUploader

  validates :logo, presence: true, if: :new_record?
  has_many :sauna_images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'
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
end
