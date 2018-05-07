module UserCountable
  extend ActiveSupport::Concern
  included { after_create :create_counter }

  def increase_login_count
    counter.increment!(:login_count)
  end
end




