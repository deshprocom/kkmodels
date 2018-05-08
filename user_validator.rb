# 用户相关的验证器
class UserValidator
  include UserUniqueValidator
  include EmailValidator
  include MobileValidator
  include PasswordValidator
end
