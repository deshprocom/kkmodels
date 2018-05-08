# 电子邮箱的格式有效性验证器
module EmailValidator
  # 不支持的邮箱
  INVALID_FORMAT = /^.*@(dfgggg.org)$/

  # 有效邮箱格式
  VALID_FORMAT = /^[A-Za-z0-9]+([\_\w]*[.]?[\_\w]*[A-Za-z0-9]+)*@([A-Za-z0-9]+[\-\.])+(?!ru$|pl$)[A-Za-z0-9]{2,5}$/

  extend ActiveSupport::Concern

  module ClassMethods
    def email_valid?(email)
      email = email.strip
      if email =~ EmailValidator::INVALID_FORMAT || email !~ EmailValidator::VALID_FORMAT
        false
      else
        true
      end
    end
  end
end
