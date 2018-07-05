class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :p_user, class_name: 'UserRelation', foreign_key: :pid, optional: true
  has_many :s_users, class_name: 'UserRelation', foreign_key: :pid
end
