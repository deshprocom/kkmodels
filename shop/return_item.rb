module Shop
  class ReturnItem < Shop::Base
    belongs_to :customer_return
    belongs_to :order_item

    enum return_type: { refund: 'refund', exchange_goods: 'exchange_goods'}
    enum return_status: { pending: 'pending', refused: 'refused', completed: 'completed', cancel_return: 'cancel_return'}
  end
end
