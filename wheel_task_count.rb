class WheelTaskCount < ApplicationRecord
  belongs_to :user
  include WheelTaskAward

  def increase_invite_count(by = 1)
    increment!(:invite_count, by)
  end

  def increase_share_count(by = 1)
    increment!(:share_count, by)
  end
end
