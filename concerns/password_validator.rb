# 用户密码验证器
module PasswordValidator
  # 有效的密码格式满足的条件
  # 1, 长度必须6 - 20位
  # 2, 必须是 数字+字母 或 数字 + 特殊字符 或 字母+特殊字符 或 数字 + 字母 + 特殊字符的组合
  # 交给前端去判断 PWD_VALID_FORMAT_REGEX = /^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$).{6,20}$/
  PWD_VALID_FORMAT_REGEX = /^[a-fA-F0-9]{32}$/
  extend ActiveSupport::Concern

  module ClassMethods
    def pwd_valid?(pwd)
      str_pwd = pwd.to_s
      str_pwd =~ PasswordValidator::PWD_VALID_FORMAT_REGEX ? true : false
    end
  end
end
