module Shop
  class Order < Shop::Base
    belongs_to :user

    has_one :shipping_info, dependent: :destroy
    has_many :order_items, dependent: :destroy
    has_many :wx_bills, class_name: 'WxBill'
    has_many :customer_returns
    has_one :shipment, dependent: :destroy

    PAY_STATUSES = %w[unpaid paid].freeze
    validates :pay_status, inclusion: { in: PAY_STATUSES }

    PAY_CHANNELS = %w[weixin ali].freeze
    validates :pay_channel, inclusion: { in: PAY_CHANNELS }

    enum status: { unpaid: 'unpaid',
                   paid: 'paid',
                   delivered: 'delivered',
                   completed: 'completed',
                   canceled: 'canceled' }

    before_create do
      self.order_number = UniqueNumberGenerator.call(Order)
    end

    def cancel_order(reason = '取消订单')
      return if canceled?
      update(cancel_reason: reason, cancelled_at: Time.zone.now, status: 'canceled')
      order_items.each do |item|
        item.variant.increase_stock(item.number)
        next if item.variant.is_master?

        item.variant.product.master.increase_stock(item.number)
      end
    end

    def deliver!
      update(status: 'delivered', delivered_at: Time.zone.now) if paid?
    end

    def delivered?
      delivered_at.present?
    end

    def complete!
      update(status: 'completed', completed_at: Time.zone.now) if delivered?
    end

    def deleted!
      update(deleted_at: Time.zone.now)
    end

    # 可退的现金
    def refundable_price
      final_price - refunded_price
    end

    # 超过了发货时间30天
    def delivered_over_30_days?
      delivered? && delivered_at < 30.days.ago
    end

    def paid?
      pay_status == 'paid'
    end

    def pay_title
      '商品订单'
    end
  end
end
