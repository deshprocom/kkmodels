class Shipment < ApplicationRecord
  belongs_to :order, polymorphic: true
  belongs_to :express
end
