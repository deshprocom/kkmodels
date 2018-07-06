# 生成零钱明细
module PocketMoneyCreator
  extend ActiveSupport::Concern

  module ClassMethods
    # 直接邀请 系统给邀请用户1元钱, user邀请了user2
    # params -> { user: user, target: user2 }
    def create_direct_invite_money(params)
      invite_award = InviteAward.last
      return if invite_award.blank? || !invite_award.published?

      amount = invite_award.direct_award
      create({option_type: 'invite', amount: amount}.merge(params))
      params[:user].increase_direct_invite_count
      params[:user].increase_direct_invite_money(amount)
      params[:user].increase_pocket_money(amount)
    end

    # 间接邀请 系统给邀请用户0.5元钱, user邀请了user2, user2又邀请了user3
    # params -> { user: user, target: user2, second_target_type: user3 }
    def create_indirect_invite_money(params)
      invite_award = InviteAward.last
      return if invite_award.blank? || !invite_award.published?

      amount = invite_award.indirect_award
      create_direct_invite_money(user: params[:target], target: params[:second_target] )
      create({option_type: 'invite', amount: amount}.merge(params))
      params[:user].increase_indirect_invite_count
      params[:user].increase_indirect_invite_money(amount)
      params[:user].increase_pocket_money(amount)
    end
  end
end
