module Shop
  class CustomerReturn < Shop::Base
    belongs_to :order
    belongs_to :user
    has_many :return_items

    enum return_type: { refund: 'refund', exchange_goods: 'exchange_goods' }
    enum return_status: { pending: 'pending', refused: 'refused', completed: 'completed', cancel_return: 'cancel_return' }

    before_create do
      self.out_refund_no = SecureRandom.hex(16)
    end
  end
end
