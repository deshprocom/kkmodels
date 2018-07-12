# 生成零钱明细
# option_type register->新用户注册送红包
module PocketMoneyCreator
  extend ActiveSupport::Concern

  module ClassMethods
    def new_user_register_award(user)
      return if !user.new_user? || user.r_level.zero?

      award_first_level_register(user) if user.r_level.eql?(1) # 1级用户完成任务
      award_second_level_register(user) if user.r_level.eql?(2) # 2级用户完成任务
      award_third_level_register(user) if user.r_level.eql?(3) # 3级用户完成任务
      # 奖励下发完成 将用户标记为老用户
      user.update(new_user: false)
    end

    # 奖励1级用户注册的
    # 现金红包随机 1.88 1.98 2.68 2.88
    def award_first_level_register(user)
      amount = register_amount
      create(register_params(user, amount))
      user.increase_pocket_money(amount)
    end

    # 奖励2级用户的
    def award_second_level_register(user)
      amount = register_amount
      # 自己有一个现金红包
      create(register_params(user, amount))
      p amount
      user.increase_pocket_money(amount)
      p 2
      # 他的上级可以获得一份现金奖励
      create_direct_invite_money(user: user.p_user, target: user)
    end

    # 奖励3级用户的
    def award_third_level_register(user)
      # 自己有一份积分奖励
      Integral.create_register_to_integral(user: user, points: register_amount(2))
      # 该用户的上一级是2级才会有奖励
      return unless user.p_user.r_level.eql?(2)
      create_indirect_invite_money(user: user.p_user.p_user, target: user.p_user, second_target: user)
    end

    # 注册送的现金或积分 数字随机
    def register_amount(level = 1)
      amount = %w[1.88 1.98 2.88 2.98].sample
      level.eql?(1) ? BigDecimal(amount) : BigDecimal(amount) * 100
    end

    def register_params(user, amount)
      { user: user, option_type: 'register', amount: amount }
    end
   
  # ------分销奖励-------
    
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