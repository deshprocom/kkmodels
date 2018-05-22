module Recommendable
  extend ActiveSupport::Concern

  def recommend!
    update(recommended: true)
  end

  def unrecommend!
    update(recommended: false)
  end
end
