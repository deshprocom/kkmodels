module TopicNotify
  extend ActiveSupport::Concern
  included do
    after_create  :create_notify
    after_destroy :delete_notify
  end

  def create_notify
    payload = notify_payload.dup

    TopicNotification.create(payload) if payload.present?
  end

  def delete_notify
    TopicNotification.where(notify_type: notify_type_by_model, source: self, target: user).delete_all
  end

  def notify_payload
    table_name = self.class.table_name
    send("payload_#{table_name}")
  end

  def payload_comments
    return {} unless notify_needed?
    { user_id: target.user_id, target: user, notify_type: 'comment', source: self }
  end

  def payload_replies
    # 判断回复的是否是自己 如果是自己就返回false
    return {} if reply_user_id.eql?(user_id)
    { user_id: reply_user_id, target: user, notify_type: 'reply', source: self }
  end

  # 说说和长帖 并且 不是回复的自己
  def notify_needed?
    target.class.name.eql?('Topic') && !user_id.eql?(target.user_id)
  end

  def notify_type_by_model
    self.class.to_s.tableize.singularize
  end
end