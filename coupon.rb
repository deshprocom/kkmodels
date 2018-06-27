class Coupon < ApplicationRecord
  belongs_to :coupon_temp

  before_create do
    self.coupon_number = SecureRandom.hex(16)
  end
end
