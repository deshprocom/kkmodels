class ExchangeTrader < ApplicationRecord
  belongs_to :user
  enum trader_type: { ex_rate: 'ex_rate', integral: 'integral', dating: 'dating' }
end