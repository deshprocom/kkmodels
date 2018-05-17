class Topic < ApplicationRecord
  include TopicCountable
  belongs_to :user
  has_many   :comments, as: :target, dependent: :destroy
  has_many   :replies,  as: :target, dependent: :destroy
  has_one    :topic_counter, dependent: :destroy
  serialize :images, JSON

  scope :user_visible, -> { where(status: 'passed').order(id: :desc) }

  def self.excellent
    where(excellent: true)
  end

  def total_comments
    comments_count + replies_count
  end

  def total_views
    topic_counter.page_views
  end
end
