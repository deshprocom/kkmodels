module Shop
  class OneYuanBuy < Shop::Base
    belongs_to :product

    after_initialize do
      self.begin_time ||= Date.current
      self.end_time ||= Date.current
    end
  end
end

