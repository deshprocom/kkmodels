# 用户密码验证器
module PasswordValidator
  # 有效的密码格式满足的条件
  # 验证是否是md5加密后的
  PWD_VALID_FORMAT_REGEX = /^[a-fA-F0-9]{32}$/
  extend ActiveSupport::Concern

  module ClassMethods
    def pwd_valid?(pwd)
      pwd.to_s.match? PasswordValidator::PWD_VALID_FORMAT_REGEX
    end
  end
end
