# 生成用户全局唯一名字
module UserNameGenerator
  extend ActiveSupport::Concern

  module ClassMethods
    USERNAME_CHARS = 'abcdefghijklmnopqrstuvwxyz'.freeze

    ##
    # 生产可用的随机用户名
    # 生产规则, 随机4个a-z的小写字母+7位随机数字, 如 asva1032483
    # 随机生产的用户名有可能与现有的用户名重复(尽管概率很低), 因此发现重复则重新生成一次, 最多生成十次
    def unique_username
      10.times do
        name_chars = ''
        4.times { name_chars << USERNAME_CHARS[Random.rand(0...26)] }
        username = "#{name_chars}#{Random.rand(1_000_000..9_999_999)}"
        return username unless User.username_exists?(username)
      end
      nil
    end
  end
end
