module Shop
  class CustomerReturn < Shop::Base
    belongs_to :order
    belongs_to :user
    has_many :return_items

    enum return_type: { refund: 'refund', exchange_goods: 'exchange_goods'}
    enum return_status: { pending: 'pending', refused: 'refused', completed: 'completed', cancel_return: 'cancel_return'}
  end
end
