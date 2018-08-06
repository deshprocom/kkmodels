# 手机格式验证器
module MobileValidator
  # 有效手机号格式
  MOBILE_VALID_FORMAT_REGEX = /^1[3456789]\d{9}$/

  extend ActiveSupport::Concern

  module ClassMethods
    def mobile_valid?(mobile, ext = nil)
      return true if ext.present? && !ext.eql?('86') # 只有大陆的手机号检查格式

      str_mobile = mobile.to_s
      str_mobile.size == 11 && str_mobile =~ MobileValidator::MOBILE_VALID_FORMAT_REGEX ? true : false
    end
  end
end
