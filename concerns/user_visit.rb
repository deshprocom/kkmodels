# 创建用户生成器
module UserVisit
  extend ActiveSupport::Concern

  # 刷新访问时间
  # 统计登录天数
  def touch_visit!
    interval_day = (Time.zone.today - last_visit.to_date).to_i
    wheel_time = create_or_find_wheel_times # 获取用户转盘次数表
    # 新用户首次登陆
    if counter.login_days.zero?
      # 登陆天数+1
      increase_login_days
      # 转盘次数+3
      wheel_time.increase_total_times(3)
      # 统计转盘活动开始 新增人数
      WheelCount.create_count if ENV['WHEEL_START'].eql?'true'
    end

    # 老用户每日首次登陆
    if interval_day >= 1
      increase_login_days
      # 转盘次数+2
      wheel_time.increase_total_times(2)
    end

    self.last_visit = Time.zone.now
    save
  end

  # 查询或创建用户转盘次数表
  def create_or_find_wheel_times
    time = wheel_user_time
    time.present? ? time : WheelUserTime.create(user: self)
  end
end
