class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  mount_uploader :avatar, AvatarUploader

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
