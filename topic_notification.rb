class TopicNotification < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true
  belongs_to :target, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }

  def read!
    update(read_at: Time.zone.now)
  end

  def read?
    read_at.present?
  end

  def self.unread_count(user)
    where(user: user).unread.count
  end

  def view_visible?
    return true if notify_type.eql?('follow')

    if notify_type.in?(%w[comment reply])
      source.present? && source.target.present?
    else
      source.present?
    end
  end
end
