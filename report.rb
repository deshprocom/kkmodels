class Report < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true
  after_create
end
