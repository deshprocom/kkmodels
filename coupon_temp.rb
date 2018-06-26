class CouponTemp < ApplicationRecord
  has_many :coupons, dependent: :destroy

  enum coupon_type: { hotel: 'hotel', shop: 'shop', new_user: 'new_user' }
  enum discount_type: { reduce: 'reduce', full_reduce: 'full_reduce', rebate: 'rebate' }

  def could_delete?
    !coupons.where.not('receive_time IS NULL').exists?
  end
end