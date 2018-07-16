##
# API访问令牌
# 每次成功调用 登录 / 注册 接口, 都会为该调用生成新的访问令牌, 用于后续的接口访问时的身份识别;
# 令牌默认有效期为30天
class UserToken
  # 生成jwt token
  def self.encode(user_uuid, exp = expire_time)
    payload = { user_uuid: user_uuid, exp: exp }
    JWT.encode payload, secret_key
  end

  # 获取jwt token里面的内容
  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, secret_key)[0])
  rescue
    nil
  end

  def self.secret_key
    @secret_key ||= Rails.application.secrets.secret_key_base
  end

  def self.expire_time
    30.days.since.to_i
  end
end
