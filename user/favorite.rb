class User
  module Favorite
    extend ActiveSupport::Concern

    included do
      action_store :favorite, :info,  counter_cache: true
      action_store :favorite, :hotel, counter_cache: true
      action_store :favorite, :topic, counter_cache: true
    end

    # 收藏
    def favorite(target)
      return false if target.blank?
      return false if target.instance_of?(Topic) && target&.user_id == id
      create_action(:favorite, target: target)
    end

    # 取消收藏
    def unfavorite(target)
      return false if target.blank?
      destroy_action(:favorite, target: target)
    end

    # 是否收藏过
    def favorite?(favorite)
      find_action(:favorite, target: favorite).present?
    end
  end
end