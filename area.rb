class Area < ApplicationRecord
  belongs_to :city, primary_key: :city_id, foreign_key: :city_id, optional: true
end
