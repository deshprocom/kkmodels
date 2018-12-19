class WeixinUser < ApplicationRecord
  belongs_to :user, optional: true

  def self.find_or_initialize_by_session(union_id)
    find_or_initialize_by(union_id: union_id)
  end

  def save_session
    touch unless new_record?
    save!
  end
end
