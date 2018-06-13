module Shop
  class ShippingMethod < Shop::Base
    belongs_to :shipping
    has_many :shipping_regions

    validates :name, presence: true

    def freight_fee(number)
      margin = number - first_item
      return first_price if margin.negative?

      # ceil 进一取整
      first_price + (margin / add_item).ceil * add_price
    end
  end
end

