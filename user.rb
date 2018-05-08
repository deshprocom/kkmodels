class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  mount_uploader :avatar, AvatarUploader

  has_one :counter, class_name: 'UserCounter', dependent: :destroy

  def avatar_path
    avatar.url.presence || wx_avatar
  end
end
