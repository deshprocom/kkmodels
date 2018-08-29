class Info < ApplicationRecord
  include Publishable
  include Stickable
  mount_uploader :image, ImageUploader

  validates :image, presence: true, if: :new_record?
  validate :coupon_ids_valid?, on: [:create, :update]

  belongs_to :info_type
  has_many   :comments, as: :target, dependent: :destroy
  has_one :view_toggle, as: :target, dependent: :destroy
  scope :search_keyword, ->(keyword) { where('title like ?', "%#{keyword}%") }

  after_initialize do
    self.date ||= Date.current
  end

  def coupons
    return [] if coupon_ids.blank?
    return @coupons if @coupons

    @coupons ||= CouponTemp.find(coupon_ids.split(','))
  end

  def preview_image
    return '' if image&.url.nil?

    image.url(:md)
  end

  def total_comments
    comments_count + replies_count
  end

  def increase_page_views
    increment!(:page_views)
  end

  def increase_view_increment(by)
    increment!(:view_increment, by)
  end

  def total_views
    page_views + view_increment
  end

  def coupon_ids_valid?
    coupon_ids.to_s.split(',').each do |id|
      return errors.add(:coupon_ids, '优惠券id无效') unless CouponTemp.exists?(id: id)
    end
  end
end
