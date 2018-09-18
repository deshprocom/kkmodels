class MerchantUser < ApplicationRecord
  include UserFinders
  include MerchantUserCreator

  has_many :sale_room_requests, foreign_key: :user_id
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  def self.mobile_exist?(mobile)
    by_mobile(mobile).present?
  end

  def decrease_revenue(by)
    decrement!(:revenue, by)
  end
end
