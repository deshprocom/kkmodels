# 创建用户生成器
module WheelCountCreator
  extend ActiveSupport::Concern

  module ClassMethods
    def create_count
      wheel_daily_count.increase_daily_new_user_count
      total_count = wheel_total_count.increase_new_user_count
      # 当总人数达到一定量的时候会产生大奖
      return if ENV['WHEEL_EXPENSIVE_PRIZE'].eql?('false')
      create_expensive_prize total_count.new_user_count
    end

    # 查询或创建用户转盘统计表
    def wheel_total_count
      # 创建一条统计转盘次数统计的
      record = WheelCount.find_by(count_type: 'total')
      record =  WheelCount.create(date: Date.current, count_type: 'total') if record.blank?
      record
    end

    def wheel_daily_count
      record = WheelCount.where(count_type: 'daily').where(date: Date.current).first
      record = WheelCount.create(date: Date.current, count_type: 'daily') if record.blank?
      record
    end

    def create_expensive_prize(count)
      # 找出所有大奖的
      wheel_expensive_prizes = WheelPrize.expensive
      wheel_expensive_prizes.each do |prize|
        mod_val = count % prize.generation_rule
        if mod_val.zero?
          ExpensivePrizeCount.create(wheel_prize_id: prize.id, current_user_num: count)
        end
      end
    end

    # 创建某种类型的延迟大奖
    def create_delay_expensive_prize(wheel_prize)
      current_num = wheel_total_count.new_user_count
      ExpensivePrizeCount.create(wheel_prize_id: wheel_prize.id, current_user_num: current_num, delay: true)
    end
  end
end
