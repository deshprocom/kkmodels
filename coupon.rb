class Coupon < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :coupon_temp, counter_cache: true
  scope :unclaimed, -> { where('receive_time IS NULL') }

  before_create do
    self.coupon_number = SecureRandom.hex(16)
  end
end
