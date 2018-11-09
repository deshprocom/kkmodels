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
    end

    # 奖励1级用户注册的
    # 现金红包随机 1.88 1.98 2.08 2.18 2.28
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
      user.increase_pocket_money(amount)
      # 他的上级可以获得一份现金奖励
      create_direct_invite_money(user: user.p_user, target: user)
    end

    # 奖励3级用户的
    def award_third_level_register(user)
      # 自己有一份积分奖励
      Integral.create_register_to_integral(user: user, points: register_amount(2))
      # 积分换成现金红包 后面发包了这个要关闭掉
      # award_first_level_register(user)
      # 该用户的上一级是2级才会有奖励
      return unless user.p_user.r_level.eql?(2)
      create_indirect_invite_money(user: user.p_user.p_user, target: user.p_user, second_target: user)
    end

    # 注册送的现金或积分 数字随机
    # def register_amount(level = 1)
    #   amount = %w[1.88 1.98 2.08 2.18 2.28].sample
    #   level.eql?(1) ? BigDecimal(amount) : BigDecimal(amount) * 100
    # end

    def register_amount(level = 1)
      amount = generate_award_money(Random.rand(1..100))
      level.eql?(1) ? amount : amount * 100
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
      create({ option_type: 'invite', amount: amount }.merge(params))
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
      create_direct_invite_money(user: params[:target], target: params[:second_target])
      create({ option_type: 'invite', amount: amount }.merge(params))
      params[:user].increase_indirect_invite_count
      params[:user].increase_indirect_invite_money(amount)
      params[:user].increase_pocket_money(amount)
    end

    # 提现记录
    # params -> { user: 提现的用户, target: 提款单, status: 'success | failed', amount: '' }
    def create_withdraw_record(params)
      status = params[:status]
      # 不管是否提现成功 都要解除用户被冻结的资金
      user = params[:user]
      amount = params[:amount]
      if status.eql?('pending') # 用户申请提现
        create(user: user, target: params[:target], option_type: 'withdraw_pending', amount: -amount)
        user.decrease_pocket_money(amount)
        user.increase_freeze_pocket_money(amount)
      elsif status.eql?('success') # 提现成功
        # create(user: user, target: params[:target], option_type: 'withdraw_success', amount: -amount)
        user.decrease_freeze_pocket_money(amount)
      else # 提现失败 把用户的钱加上去
        create(user: user, target: params[:target], option_type: 'withdraw_failed', amount: amount)
        user.decrease_freeze_pocket_money(amount)
        user.increase_pocket_money(amount)
      end
    end

    # 根据随机数 生成相应的金额
    def generate_award_money(number)
      if (1..60).include? number
        5.18
      elsif (61..80).include? number
        5.88
      elsif (81..90).include? number
        6.88
      elsif (91..95).include? number
        7.88
      elsif (96..100).include? number
        8.88
      end
    end

    # 转盘活动奖励现金
    # params: { user: 用户, target: 目标奖品, amount: 金额 }
    def create_wheel_pocket_money(params)
      create({ user: params[:user], target: params[:target], option_type: 'wheel', amount: params[:amount] })
      params[:user].increase_pocket_money(params[:amount])
    end
  end
end
