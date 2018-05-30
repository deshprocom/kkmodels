class WxBill < ApplicationRecord
  belongs_to :order, polymorphic: true
  serialize :wx_result, JSON

  enum source_type: { from_notified: 'from_notified', from_query: 'from_query' }
end
