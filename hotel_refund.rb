class HotelRefund < ApplicationRecord
  belongs_to :user
  belongs_to :hotel_order, foreign_key: :order_id

  enum refund_status: { pending: 'pending', refused: 'refused', completed: 'completed', cancel_refund: 'cancel_refund' }
  end
