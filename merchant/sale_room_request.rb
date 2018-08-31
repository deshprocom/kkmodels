class SaleRoomRequest < ApplicationRecord
  mount_uploader :card_img, ImageUploader
  belongs_to :hotel
  belongs_to :hotel_room
  belongs_to :user

  enum status: { pending: 'pending', 'passed': 'passed', 'refused': 'refused', canceled: 'canceled' }
end
