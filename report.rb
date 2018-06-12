class Report < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true

  def ignored!
    update(ignored: true)
    target.decrement!(:reports_count)
  end
end
