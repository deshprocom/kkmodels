class WheelTaskCount < ApplicationRecord
  belongs_to :user

  def self.award_times_from_invite(user)
    record = user.wheel_task_counts.find_by(date: Date.current) # 查询今日用户邀请的记录
    record = create(user: user, date: Date.current) if record.blank? # 如果今日还没有记录，那么创建一条记录
    return if record.invite_count >= ENV['WHEEL_INVITE_LIMIT'].to_i # 每日超过5个就不会再增加次数
    # 奖励一次转盘活动次数
    user.wheel_user_time.increase_total_times
    record.increase_invite_count
  end

  def increase_invite_count(by = 1)
    increment!(:invite_count, by)
  end
end
