module Wheel
  class Base < ApplicationRecord
    self.abstract_class = true
    self.table_name_prefix = 'wheel_'
  end
end