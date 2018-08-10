class Hotline < ApplicationRecord
  enum line_type: { fast_food: 'fast_food', public_service: 'public_service' }
end
