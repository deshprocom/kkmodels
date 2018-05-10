class Province < ApplicationRecord
  has_many :cities, primary_key: :province_id, foreign_key: :province_id
end
