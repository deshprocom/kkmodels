class PocketMoney < ApplicationRecord
  include PocketMoneyCreator
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :second_target, polymorphic: true, optional: true
  scope :invite_list, -> { where(option_type: 'invite').order(created_at: :desc) }

  # 判断是否是间接邀请用户
  def indirect_invite?
    option_type.eql?('invite') && second_target_type.present?
  end

  def memo
    send("#{option_type}_memo")
  end

  def invite_memo
    if indirect_invite?
      "好友#{target.nick_name}邀请了#{second_target.nick_name}"
    else
      "我邀请了好友#{target.nick_name}"
    end
  end

  def register_memo
    return unless option_type.eql?('register')
    '新用户注册活动奖励'
  end
end
