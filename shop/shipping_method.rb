module Shop
  class ShippingMethod < Shop::Base
    belongs_to :shipping
    has_many :shipping_regions

    validates :name, presence: true

    scope :default_method, -> { where(default_method: true).first }


    def freight_fee(weight)
      margin = weight - first_item
      return first_price if margin < 0
      first_price + ((margin / add_item).to_i + 1) * add_price
    end
  end
end

