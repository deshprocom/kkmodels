class Coupon < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :coupon_temp, counter_cache: true
  scope :unclaimed, -> { where(coupon_status: 'init') } # 未兑换
  scope :used, -> { where('expire_time < ? or coupon_status = ?', Time.zone.now, 'used') } # 已过期或已使用
  scope :unused, -> { where('expire_time > ?', Time.zone.now).where('coupon_status = ? or coupon_status = ?', 'unused', 'refund') } # 未使用

  before_create do
    self.coupon_number = SecureRandom.hex(16)
  end

  def expired?
    expire_time && expire_time < Time.zone.now
  end

  def received_by_user(user, effect_day = 30)
    receive_time = Time.zone.now
    expire_day = self.expire_day || effect_day
    expire_time = receive_time + expire_day.days
    update(receive_time: receive_time,
           expire_day: expire_day,
           expire_time: expire_time,
           user_id: user.id,
           coupon_status: 'unused')
  end

  def conform_discount_rules?(order_price)
    return true if coupon_temp.reduce?

    return true if coupon_temp.rebate?

    return true if coupon_temp.full_reduce? && order_price >= coupon_temp.limit_price

    false
  end

  def discount_amount(order_price)
    if coupon_temp.reduce?
      return coupon_temp.reduce_price
    end

    if coupon_temp.rebate?
      return order_price - (order_price * coupon_temp.discount)
    end

    if coupon_temp.full_reduce? && order_price >= coupon_temp.limit_price
      return coupon_temp.reduce_price
    end

    0.0
  end
end
