class PocketMoney < ApplicationRecord
  include PocketMoneyCreator
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :second_target, polymorphic: true, optional: true

  # 判断是否是间接邀请用户
  def indirect_invite?
    option_type.eql?('invite') && second_target_type.present?
  end
end
