class Integral < ApplicationRecord
  include IntegralCreator
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  scope :tasks, -> { where(category: 'tasks') }
  scope :active, -> { where.not('active_at IS NULL') }
  scope :not_active, -> { where('active_at IS NULL') }

  def touch_active!
    self.active_at = Time.zone.now
    save
  end

  def self.today
    where('created_at >= ?', Time.now.beginning_of_day).where('created_at <= ?', Time.now.end_of_day)
  end
end
