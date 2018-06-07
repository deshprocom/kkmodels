module Shop
  class Order < Shop::Base
    belongs_to :user

    has_one :shipping_info, dependent: :destroy
    has_many :order_items, dependent: :destroy
    has_many :wx_bills, class_name: 'WxBill'
    has_many :customer_returns
    has_one :shipment, dependent: :destroy

    PAY_STATUSES = %w[unpaid paid failed refund].freeze
    validates :pay_status, inclusion: { in: PAY_STATUSES }

    enum status: { unpaid: 'unpaid',
                   paid: 'paid',
                   delivered: 'delivered',
                   completed: 'completed',
                   canceled: 'canceled'}

    before_create do
      self.order_number = Services::UniqueNumberGenerator.call(Order)
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

    def complete!
      update(status: 'completed', completed_at: Time.zone.now) if delivered?
    end

    def deleted!
      update(deleted_at: Time.zone.now)
    end

    def could_delete?
      canceled? || completed?
    end

    def self.unpaid_half_an_hour
      unpaid.where('created_at < ?', 30.minutes.ago)
    end

    def could_refund?
      paid? || (delivered? && delivered_at.present? && delivered_at > 15.days.ago)
    end

    def delivered?
      delivered_at.present?
    end

    def self.delivered_15_days
      delivered.where('delivered_at < ?', 15.days.ago)
    end

    # 是否可退现金
    def could_refund_cash?
      could_refund_cash_numbers.positive?
    end

    # 可退的现金
    def could_refund_cash_numbers
      final_price - refund_price
    end

    # 超过了发货时间30天
    def delivered_over_30_days?
      delivered? && delivered_at < 30.days.ago
    end
  end
end
