module UserCountable
  extend ActiveSupport::Concern
  included { after_create :create_counter }

  def increase_login_count
    counter.increment!(:login_count)
  end

  def increase_share_count
    counter.increment!(:share_count)
  end

  def increase_login_days
    counter.increment!(:login_days)
  end

  def increase_points(by)
    counter.increment!(:points, by)
  end

  def decrease_points(by)
    counter.decrement!(:points, by)
  end

  def increase_pocket_money(by)
    counter.increment!(:total_pocket_money, by)
  end

  def decrease_pocket_money(by)
    counter.decrement!(:total_pocket_money, by)
  end

  def increase_freeze_pocket_money(by)
    counter.increment!(:freeze_pocket_money, by)
  end

  def decrease_freeze_pocket_money(by)
    counter.decrement!(:freeze_pocket_money, by)
  end

  def increase_invite_users
    counter.increment!(:invite_users)
  end

  def increase_direct_invite_count
    counter.increment!(:direct_invite_count)
  end

  def increase_indirect_invite_count
    counter.increment!(:indirect_invite_count)
  end

  def increase_direct_invite_money(by)
    counter.increment!(:direct_invite_money, by)
  end

  def increase_indirect_invite_money(by)
    counter.increment!(:indirect_invite_money, by)
  end

  def total_invite_money
    counter.direct_invite_money + counter.indirect_invite_money
  end

  def total_invite_count
    counter.direct_invite_count + counter.indirect_invite_count
  end
end




