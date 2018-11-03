module WheelCountIncrement
  extend ActiveSupport::Concern

  def increase_new_user_count
    increment!(:new_user_count)
  end

  def increase_daily_new_user_count
    increment!(:daily_new_user_count)
  end

  def increase_lottery_times
    increment!(:lottery_times)
  end

  def increase_lottery_users
    increment!(:lottery_users)
  end
end




