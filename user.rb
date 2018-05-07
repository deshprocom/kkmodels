class User < ApplicationRecord
  include UserFinders
  include UserCountable

  has_one :counter, class_name: 'UserCounter', dependent: :destroy
end
