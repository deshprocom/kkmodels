class CouponTemp < ApplicationRecord
  include Publishable
  has_many :coupons, dependent: :destroy

  enum coupon_type: { hotel: 'hotel', shop: 'shop', new_user: 'new_user' }
  enum discount_type: { reduce: 'reduce', full_reduce: 'full_reduce', rebate: 'rebate' }

  scope :published, -> { where(published: true) }
  scope :new_user, -> { where(new_user: true) }

  # 已经有用户领取的模版不可以删除
  def could_delete?
    coupon_received_count.positive?
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
end
