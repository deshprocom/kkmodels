##
# 用户的唯一性(用户名, 手机号, 邮箱)检查器
module UserUniqueValidator
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    # 检查用户名是否存在
    #     username - 要检查的用户名
    #     exclude_user_uuid - 检查时要排除的用户, 避免检查用户自身
    #
    #  使用方法:
    #     User.username_exists?('abc123')
    def username_exists?(username, exclude_user_uuid = nil)
      user = User.by_uname(username)
      user.present? && (exclude_user_uuid.blank? || user.user_uuid != exclude_user_uuid)
    end

    ##
    # 检查手机号码是否存在
    #     mobile - 要检查的手机号码
    #     exclude_user_uuid - 检查时要排除的用户, 避免检查用户自身
    def mobile_exists?(mobile, exclude_user_uuid = nil)
      user = User.by_mobile(mobile)
      user.present? && (exclude_user_uuid.blank? || user.user_uuid != exclude_user_uuid)
    end

    ##
    # 检查邮箱是否存在
    #     email - 要检查的邮箱
    #     exclude_user_uuid - 检查时要排除的用户, 避免检查用户自身
    def email_exists?(email, exclude_user_uuid = nil)
      user = User.by_email(email)
      user.present? && (exclude_user_uuid.blank? || user.user_uuid != exclude_user_uuid)
    end
  end
end
