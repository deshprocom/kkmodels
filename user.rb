class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  mount_uploader :avatar, ImageUploader

  has_many :user_extras, dependent: :destroy
  has_many :shipping_addresses, -> { order(default: :desc).order(created_at: :desc) }
  has_one :weixin_user, dependent: :destroy
  has_one :counter, class_name: 'UserCounter', dependent: :destroy

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  def avatar_path
    avatar.url.presence || wx_avatar
  end
end
