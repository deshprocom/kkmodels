module Shop
  class Shipping < Shop::Base
    belongs_to :express
    has_many :shipping_methods
    has_one :default_method, -> { where(default_method: true) }, class_name: 'ShippingMethod'
    has_many :shipping_regions
    has_many :products

    validates :express_id, presence: true, uniqueness: { scope: :calc_rule, message: '同一个快递公司不能有相同的计费规则' }
    validates :name, presence: true
    enum calc_rule: { weight: 'weight', number: 'number', free_shipping: 'free_shipping' }

    def based_weight?
      weight?
    end

    def default_freight_fee(product)
      return 0.0 if free_shipping?

      if based_weight?
        default_method.freight_fee(product.master.weight)
      else
        default_method.freight_fee(1)
      end
    end

    def by_code_or_default_method(code)
      region = shipping_regions.find_by(code: code)
      return region.shipping_method if region

      default_method
    end
  end
end

