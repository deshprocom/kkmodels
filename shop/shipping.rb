module Shop
  class Shipping < Shop::Base
    belongs_to :express
    has_many :shipping_methods
    has_many :products

    validates :express_id, presence: true, uniqueness: { scope: :calc_rule, message: '同一个快递公司不能有相同的计费规则' }
    validates :name, presence: true
    enum calc_rule: { weight: 'weight', number: 'number', free_shipping: 'free_shipping' }
  end
end

