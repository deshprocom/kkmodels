module Shop
  class ShippingInfo < Shop::Base
    belongs_to :order

    def full_address
      province.to_s + city.to_s + area.to_s + address.to_s
    end
  end
end
