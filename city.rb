class City < ApplicationRecord
  has_many :areas, primary_key: :city_id, foreign_key: :city_id
  belongs_to :province, primary_key: :province_id, foreign_key: :province_id, optional: true
end
