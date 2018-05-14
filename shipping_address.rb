class ShippingAddress < ApplicationRecord
  belongs_to :user

  def default!
    update(default: true)
  end
end