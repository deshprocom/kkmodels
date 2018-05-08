# 创建用户生成器
module UserCreator
  extend ActiveSupport::Concern

  module ClassMethods
    def create_by_mobile(mobile, password)
      user_attrs = new_user_attributes(mobile: mobile, password: password)
      User.create(user_attrs)
    end

    def create_by_email(email, password)
      user_attrs = new_user_attributes(email: email, password: password)
      User.create(user_attrs)
    end

    def new_user_attributes(user_attrs = {})
      default_attrs = user_attrs.dup
      password = default_attrs.delete(:password)
      password ||= ::Digest::MD5.hexdigest(SecureRandom.uuid)
      salt = SecureRandom.hex(6).slice(0, 6)
      salted_password = ::Digest::MD5.hexdigest("#{password}#{salt}")
      user_name = User.unique_username
      nick_name = user_name

      { user_uuid: SecureRandom.hex(16),
        user_name: user_name,
        nick_name: nick_name,
        password: salted_password,
        password_salt: salt,
        reg_date: Time.zone.now,
        last_visit: Time.zone.now }.merge!(default_attrs)
    end
  end
end
