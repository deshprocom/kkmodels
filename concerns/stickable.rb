module Stickable
  extend ActiveSupport::Concern

  included do
    scope :stickied, -> { where(stickied: true) }
  end

  def sticky!
    update(stickied: true)
  end

  def unsticky!
    update(stickied: false)
  end
end
