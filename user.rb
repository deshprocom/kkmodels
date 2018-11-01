class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  include UserVisit
  include User::Favorite
  mount_uploader :avatar, ImageUploader
  extend Geocoder::Model::ActiveRecord
  reverse_geocoded_by :lat, :lng

  has_many :user_extras, dependent: :destroy
  has_many :shipping_addresses, -> { order(default: :desc).order(created_at: :desc) }
  has_one :weixin_user, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :actions, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :topic_notifications, dependent: :destroy
  has_one :counter, class_name: 'UserCounter', dependent: :destroy
  has_many :shop_orders, class_name: 'Shop::Order'
  has_one :j_user, dependent: :destroy
  has_many :integrals, dependent: :destroy
  has_many :hotel_orders, -> { where.not(status: 'deleted').order(id: :desc) }
  has_many :hotel_refund, -> { order(id: :desc) }
  has_many :coupons, dependent: :destroy
  has_one  :user_relation, dependent: :destroy
  has_many :pocket_moneys, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_one  :wheel_user_time, dependent: :destroy
  has_many :wheel_user_prizes, dependent: :destroy

  action_store :like,     :topic, counter_cache: true
  action_store :like,     :info,  counter_cache: true
  action_store :like,     :hotel, counter_cache: true
  action_store :follow,   :user,  counter_cache: 'followers_count', user_counter_cache: 'following_count'

  def avatar_path
    avatar.url.presence || wx_avatar
  end

  def action_likes
    actions.where(action_type: 'like')
  end

  def action_favorites
    actions.where(action_type: 'favorite')
  end

  def silenced!(reason, till)
    update(silenced: true,
           silence_at: Time.zone.now,
           silence_reason: reason,
           silence_till: till)
  end

  def silenced_and_till?
    silenced? && (silence_till.to_i > Time.zone.now.to_i)
  end

  def display_name
    nick_name
  end

  def p_user
    user_relation.p_user&.user
  end
  
  def take_pocket_moneys
    # 登录满7天并且分享次数大于2
    PocketMoney.new_user_register_award(self) if counter.login_days >= ENV['REQUIRED_LOGIN_DAYS'].to_i && counter.share_count >= 2
  end

  def mark_to_old_user!
    update(new_user: false)
    user_relation.update(new_user: false)
  end

  def usable_hotel_coupons
    @usable_hotel_coupons ||= coupons.unused
                                     .includes(:coupon_temp)
                                     .where(coupon_temps: {coupon_type: :hotel})
  end
end
