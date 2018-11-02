# 生成积分记录
module IntegralCreator
  extend ActiveSupport::Concern

  module ClassMethods
    # params: { user: 用户, points: 积分}
    def create_register_to_integral(params)
      create_params = {
        option_type: 'register',
        category: 'register',
        mark: '任务奖励',
      }.merge(params)
      create_record(create_params)
    end

    # params: { user: 用户, target: 目标优惠券, points: 积分 }
    def create_integral_to_coupon(params)
      create_params = {
        option_type: 'exchange_coupon',
        category: 'integral_mall',
        mark: '积分换券',
      }.merge(params)
      create_record(create_params)
    end

    # params: { user: 用户, target: 目标订单, price: 实际支付金额, option_type: 'hotel_order' | 'shop_order' }
    def create_paid_to_integral(params)
      create_params = {
        option_type: params.delete(:option_type) || 'hotel_order',
        category: 'order',
        points: params.delete(:price).floor,
        mark: '购物积分',
      }.merge(params)
      create_record(create_params)
    end

    # params: { user: 用户, target: 目标订单, price: 实际支付金额, option_type: 'hotel_order' | 'shop_order' }
    def create_refund_to_integral(params)
      create_params = {
        option_type: params.delete(:option_type) || 'hotel_order',
        category: 'order',
        points: -params.delete(:price).floor,
        mark: '订单退款',
      }.merge(params)
      create_record(create_params)
    end

    # 转盘活动奖励积分
    # params: { user: 用户, target: 目标奖品, points: 积分 }
    def create_wheel_integral(params)
      create_params = {
        option_type: 'wheel',
        category: 'wheel',
        points: params.delete(:points),
        mark: '转盘抽奖'
      }.merge(params)
      create_record(create_params)
    end

    # params: { user: 用户, points: 积分 }
    def create_integral_to_wheel_times(params)
      create_params = {
          option_type: 'exchange_wheel_times',
          category: 'wheel',
          mark: '积分兑换转盘次数',
      }.merge(params)
      create_record(create_params)
    end

    def create_record(params, active = true)
      integral = create(params) # 创建记录
      integral.touch_active! if active # 激活不需要领取
      params[:user].increase_points(params[:points]) # 新增或扣除用户积分
      integral
    end
  end
end
