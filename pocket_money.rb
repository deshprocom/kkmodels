class PocketMoney < ApplicationRecord
  include PocketMoneyCreator
  include PocketMoneyMemo
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :second_target, polymorphic: true, optional: true
  scope :invite_list, -> { where(option_type: 'invite').order(created_at: :desc) }

  # 判断是否是间接邀请用户
  def indirect_invite?
    option_type.eql?('invite') && second_target_type.present?
  end
end
