module Shop
  class ShippingRegion < Shop::Base
    belongs_to :shipping
    belongs_to :shipping_method
  end
end

