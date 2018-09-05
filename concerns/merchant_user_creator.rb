# 创建用户生成器
module MerchantUserCreator
  extend ActiveSupport::Concern

  module ClassMethods
    def create_by_mobile(mobile, ext = '86')
      user_attrs = new_user_attributes(mobile: mobile, ext: ext)
      MerchantUser.create(user_attrs)
    end

    def new_user_attributes(user_attrs = {})
      default_attrs = user_attrs.dup
      password = ::Digest::MD5.hexdigest(SecureRandom.uuid)
      salt = SecureRandom.hex(6).slice(0, 6)
      salted_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

      { user_uuid: SecureRandom.hex(16),
        password: salted_password,
        password_salt: salt,
        last_visit: Time.zone.now }.merge!(default_attrs)
    end
  end
end
