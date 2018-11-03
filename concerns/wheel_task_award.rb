module WheelTaskAward
  extend ActiveSupport::Concern

  module ClassMethods
    def award_times_from_invite(user)
      record = find_or_create_record(user)
      return if record.invite_count >= ENV['WHEEL_INVITE_LIMIT'].to_i
      # 奖励一次转盘活动次数
      user.wheel_user_time.increase_total_times
      record.increase_invite_count
    end

    def award_times_from_share(user)
      record = find_or_create_record(user)
      return if record.share_count >= ENV['WHEEL_SHARE_LIMIT'].to_i
      # 奖励一次转盘活动次数
      user.wheel_user_time.increase_total_times
      record.increase_share_count
    end

    def find_or_create_record(user)
      record = user.wheel_task_counts.find_by(date: Date.current) # 查询今日用户邀请的记录
      record = create(user: user, date: Date.current) if record.blank? # 如果今日还没有记录，那么创建一条记录
      record
    end
  end
end
