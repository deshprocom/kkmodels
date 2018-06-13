module Shop
  module ProductVariable
    extend ActiveSupport::Concern
    included do
      has_one :master,
              -> { where is_master: true },
              class_name: 'Variant'
      accepts_nested_attributes_for :master, update_only: true

      has_many :variants,
               -> { where(is_master: false) }
    end

    # 当增加或删除规格值时，先删除不完整的sku,再进行重建variants
    def rebuild_variants_for_value_change
      destroy_incomplete_sku
      rebuild_variants
    end

    # 当删除规格时，并且被删除的规格有规格值时，先删除所有variants,再进行重建variants
    def rebuild_variants_for_type_delete(type_has_values = false)
      variants.destroy_all if type_has_values
      rebuild_variants
    end

    def rebuild_variants
      values_skus.each do |values_sku|
        sku_option_values = option_values_hash(values_sku)
        next if sku_exists?(sku_option_values)

        variant = variants.create(price: master.price,
                                  original_price: master.original_price,
                                  weight: master.weight,
                                  volume: master.volume,
                                  stock: 100,
                                  sku_option_values: sku_option_values)
        variant.build_option_values(values_sku)
      end
      recount_all_stock
    end

    def recount_all_stock
      master.update(stock: variants.sum(:stock))
    end

    def destroy_incomplete_sku
      current_option_type_size = option_types.size
      variants.each do |variant|
        variant.destroy if variant.option_values.size != current_option_type_size
      end
    end

    def sku_exists?(sku_option_values)
      variants.each do |variant|
        return true if variant.sku_option_values == sku_option_values
      end

      false
    end

    # sku集合的生成可由 卡笛尔积的算法来生成
    def values_skus
      values = strict_option_values
      return [] if values.blank?

      return values[0].product if values.size == 1

      values[0].product(*values[1..-1])
    end

    def option_values_hash(values_sku)
      values_sku.each_with_object({}) do |o_value, hash|
        hash[o_value.option_type.id.to_s] = o_value.id
      end
    end

    def strict_option_values
      @strict_option_values ||= option_types.map do |type|
        # type.option_values.map { |v|  v.id }
        type.option_values.to_a
      end.reject(&:blank?)
    end
  end
end
