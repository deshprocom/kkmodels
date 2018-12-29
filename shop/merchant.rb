module Shop
  class Merchant < Shop::Base
    has_many :products
  end
end

