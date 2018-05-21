module Excellentable
  extend ActiveSupport::Concern

  def excellent!
    update(excellent: true)
  end

  def unexcellent!
    update(excellent: false)
  end
end
