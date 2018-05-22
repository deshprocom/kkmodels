module Shop
  class OptionValue < Shop::Base
    belongs_to :option_type
    validates :name, presence: true, uniqueness: { scope: :option_type_id }
  end
end