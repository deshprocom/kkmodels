class WeixinUser < ApplicationRecord
  belongs_to :user, optional: true
end
