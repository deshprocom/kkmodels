class RoomRequestWithdrawal < ApplicationRecord
  belongs_to :merchant_user
  belongs_to :sale_room_request

  enum status: { pending: 'pending', 'passed': 'passed', 'refused': 'refused', canceled: 'canceled' }
end
