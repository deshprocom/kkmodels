class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
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
  has_many :shop_orders, class_name: Shop::Order
  has_one :j_user, dependent: :destroy
  has_many :integrals, dependent: :destroy

  action_store :like,     :topic, counter_cache: true
  action_store :like,     :info,  counter_cache: true
  action_store :like,     :hotel, counter_cache: true
  action_store :follow,   :user,  counter_cache: 'followers_count', user_counter_cache: 'following_count'

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  def avatar_path
    avatar.url.presence || wx_avatar
  end

  def action_likes
    actions.where(action_type: 'like')
  end

  def silenced!(reason, till)
    update(silenced: true,
           silence_at: Time.zone.now,
           silence_reason: reason,
           silence_till: till)
  end

  def silenced_and_till?
    silenced? && (silence_till > Time.zone.now)
  end
end
