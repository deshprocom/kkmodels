module Shop
  class VariantOptionValue < Shop::Base
    belongs_to :variant
    belongs_to :option_value
    belongs_to :option_type
  end
end
