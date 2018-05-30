class WxBill < ApplicationRecord
  belongs_to :order, polymorphic: true
  serialize :wx_result, JSON
end
