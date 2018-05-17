class TopicNotification < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :user
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id

  def read!
    update(read: true)
  end
end
