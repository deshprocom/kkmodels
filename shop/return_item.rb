module Shop
  class ReturnItem < Shop::Base
    belongs_to :customer_return
    belongs_to :order_item

    enum return_type: { refund: 'refund', exchange_goods: 'exchange_goods' }
    enum return_status: { pending: 'pending', refused: 'refused', completed: 'completed', cancel_return: 'cancel_return' }

    RETURN_STATUS_TEXTS = {
      refund_pending: '退款申请中',
      refund_refused: '拒绝退款',
      refund_completed: '已退款',
      refund_cancel_return: '取消退款',
      exchange_goods_pending: '换货申请中',
      exchange_goods_refused: '拒绝换货',
      exchange_goods_completed: '同意换货',
      exchange_goods_cancel_return: '取消退款'
    }.freeze
    def return_status_text
      RETURN_STATUS_TEXTS["#{return_type}_#{return_status}".to_sym]
    end
  end
end
