module Shop
  class Variant < Shop::Base
    belongs_to :product, required: false
    has_many :variant_option_values, dependent: :destroy
    has_many :option_values, through: :variant_option_values
    has_many :order_items
    has_one  :image, as: :imageable, dependent: :destroy, class_name: 'Image'
    accepts_nested_attributes_for :image, update_only: true

    with_options numericality: { greater_than_or_equal_to: 0, allow_nil: true } do
      validates :original_price
      validates :price, presence: true
    end
    validates :sku, uniqueness: true, allow_blank: true

    serialize :sku_option_values, JSON

    def find_option_value(option_type)
      option_values.find { |v| v.option_type_id.eql? option_type.id }
    end

    def build_option_values(values_sku)
      values_sku.each { |option_value| build_option_value(option_value) }
    end

    def build_option_value(option_value)
      variant_option_values.create(option_value:   option_value,
                                   option_type_id: option_value.option_type_id)
    end

    def increase_stock(by)
      increment!(:stock, by)
    end

    def decrease_stock(by)
      decrement!(:stock, by)
    end

    def text_sku_values
      @text_sku_values ||= option_values.includes(:option_type).map do |option|
        "#{option.option_type.name}: #{option.name}"
      end
    end
  end
end
