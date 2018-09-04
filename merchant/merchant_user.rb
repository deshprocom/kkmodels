class MerchantUser < ApplicationRecord
  include UserFinders
  include MerchantUserCreator

  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  def self.mobile_exist?(mobile)
    by_mobile(mobile).present?
  end
end
