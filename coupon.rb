class Coupon < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :coupon_temp, counter_cache: true
  scope :unclaimed, -> { where(coupon_status: 'init') } # 未兑换
  scope :used, -> { where('expire_time < ? or coupon_status = ?', Time.zone.now, 'used') } # 已过期或已使用
  scope :unused, -> { where('coupon_status = ? or coupon_status = ?', 'unused', 'refund') } # 未使用

  before_create do
    self.coupon_number = SecureRandom.hex(16)
  end

  def expired?
    expire_time < Time.zone.now
  end

  def received_by_user(user, effect_day = 30)
    receive_time = Time.zone.now
    expire_day = self.expire_day || effect_day
    expire_time = receive_time + expire_day.day
    update(receive_time: receive_time,
           expire_day: expire_day,
           expire_time: expire_time,
           user_id: user.id,
           coupon_status: 'unused')
  end
end
