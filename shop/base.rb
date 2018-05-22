module Shop
  class Base < ApplicationRecord
    self.abstract_class = true
    self.table_name_prefix = 'shop_'
  end
end

