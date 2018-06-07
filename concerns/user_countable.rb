module UserCountable
  extend ActiveSupport::Concern
  included { after_create :create_counter }

  def increase_login_count
    counter.increment!(:login_count)
  end

  def increase_share_count
    counter.increment!(:share_count)
  end

  def increase_points(by)
    counter.increment!(:points, by)
  end
end




