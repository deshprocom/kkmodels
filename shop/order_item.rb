module Shop
  class OrderItem < Shop::Base
    belongs_to :order
    belongs_to :product, optional: true
    belongs_to :variant
    has_one :recent_return, -> { order(id: :desc) }, class_name: ReturnItem
    # has_many :product_refund_details, dependent: :destroy

    serialize :sku_value, JSON
    # none 没有退款申请， pending 退款申请中, refused 拒绝退款， refunded 已退款
    # REFUND_STATUSES = %w[none pending refused refunded].freeze
    # validates :refund_status, inclusion: { in: REFUND_STATUSES }

    def syn_variant
      self.product_id     = variant.product_id
      self.original_price = variant.original_price
      self.price          = variant.price
      self.sku_value      = variant.text_sku_values
      self.returnable     = variant.product.returnable
      self.variant_image  = variant.image&.preview || product.preview_icon
    end

    def refunded?
      refunded
    end

    # 是否可以申请退换货
    def can_returnable?
      # 是否支持退换货
      return false unless returnable
      # 最近一个申请退换货的状态为pending或者completed,则不能退换
      return false if recent_return&.return_status.in?(%w[pending completed])

      true
    end
  end
end

