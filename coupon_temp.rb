class CouponTemp < ApplicationRecord
  include Publishable
  has_many :coupons, dependent: :destroy
  mount_uploader :cover_link, ImageUploader

  enum coupon_type: { hotel: 'hotel', shop: 'shop', offline_store: 'offline_store' }
  enum discount_type: { reduce: 'reduce', full_reduce: 'full_reduce', rebate: 'rebate' }

  scope :published, -> { where(published: true) }
  scope :new_user, -> { where(new_user: true) }

  # 已经有用户领取的模版不可以删除
  def could_delete?
    coupon_received_count.zero?
  end

  # 待领取
  def self.unclaimed
    published.where(new_user: false).where(integral_on: true)
  end

  def claim?
    published && integral_on && !new_user && stock.positive?
  end

  def stock
    coupons_count - coupon_received_count
  end

  def preview_image
    return '' if cover_link&.url.nil?

    cover_link.url(:md)
  end

  def begin_date
    Date.current.strftime('%Y-%m-%d')
  end
  
  def end_date
    (Date.current + expire_day.days).strftime('%Y-%m-%d')
  end
end
