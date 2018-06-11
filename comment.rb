class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true
  has_many   :replies, dependent: :destroy
  has_many   :dynamics, as: :target, dependent: :destroy
  include TopicNotify
  include Excellentable

  default_scope { where('deleted_at IS NULL') }
end
