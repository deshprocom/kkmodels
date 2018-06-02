module Shop
  class ShippingMethod < Shop::Base
    belongs_to :shipping
    has_many :shipping_regions

    validates :name, presence: true
  end
end

