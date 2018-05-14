class Topic < ApplicationRecord
  include TopicCountable
  belongs_to :user, optional: true
  serialize :images, JSON

  has_one :counter, class_name: 'TopicCounter', dependent: :destroy
  scope :user_visible, -> { where(status: 'passed').order(id: :desc) }

  def self.excellent
    where(excellent: true)
  end
end
