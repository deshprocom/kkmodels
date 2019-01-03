module Shop
  class OneYuanBuy < Shop::Base
    belongs_to :product

    after_initialize do
      self.begin_time ||= Date.current
      self.end_time ||= Date.current
    end

    scope :visible, -> { where(published: true, viewable: true) }

    def increase_sales_volume(by)
      increment!(:sales_volume, by)
    end

    def discounts_valid?
      return false unless published
      current = DateTime.current

      # 不在时间范围中则不允许一元购
      return false unless current >= begin_time && current <= end_time

      return false if sales_volume >= saleable_num

      true
    end

    def buy_status
      current = DateTime.current
      return 'unbegin' if current < begin_time

      return 'end' if current > end_time

      return 'sell_out' if sales_volume >= saleable_num

      'going'
    end
  end
end

