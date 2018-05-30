module Shop
  class OrderItem < Shop::Base
    belongs_to :order
    belongs_to :product, optional: true
    belongs_to :variant
    # has_many :product_refund_details, dependent: :destroy

    serialize :sku_value, JSON
    REFUND_STATUSES = %w[none open close completed].freeze
    validates :refund_status, inclusion: { in: REFUND_STATUSES }
    # enum refund_status: { none_refund: 'none', open: 'open', close: 'close', 'completed': 'completed' }

    def syn_variant
      self.product_id     = variant.product_id
      self.original_price = variant.original_price
      self.price          = variant.price
      self.sku_value      = variant.text_sku_values
      self.returnable     = variant.product.returnable
    end

    def open_refund
      update(refund_status: 'open')
    end

    def could_refund?
      # 只有订单状态为none和close状态的情况可以退款
      %(none close).include?(refund_status)
    end

    def close!
      update(refund_status: 'close')
    end

    def complete!
      update(refund_status: 'completed')
    end
  end
end

