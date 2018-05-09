module Publishable
  extend ActiveSupport::Concern

  def publish!
    update(published: true)
  end

  def unpublish!
    update(published: false)
  end
end
