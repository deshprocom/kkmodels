class Notification < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :user
  serialize :extra_data

  after_create do
    DpPush::NotifyUser.call(user, content) unless Rails.env.test?
  end
end
