class ExchangeRate < ApplicationRecord
  enum rate_type: { real_time: 'real_time', local: 'local', recover: 'recover' }
end