class Topic < ApplicationRecord
  include TopicCountable
  include Excellentable

  belongs_to :user
  has_many   :comments,  as: :target, dependent: :destroy
  has_many   :replies,   as: :target, dependent: :destroy
  has_many   :reports,   as: :target, dependent: :destroy
  has_one    :topic_counter, dependent: :destroy
  has_one :view_toggle, as: :target, dependent: :destroy
  serialize :images, JSON

  # default_scope { where.not(status: 'failed') } unless ENV['CURRENT_PROJECT'] == 'kkcms'
  scope :displayable, -> { where.not(status: 'failed') }
  enum body_type: { long: 'long', short: 'short' }
  enum status: { pending: 'pending', passed: 'passed', failed: 'failed' }

  def self.excellent
    where(excellent: true)
  end

  def long?
    body_type.eql? 'long'
  end

  def total_comments
    comments_count + replies_count
  end

  def total_views
    topic_counter.page_views + topic_counter.view_increment
  end
end
