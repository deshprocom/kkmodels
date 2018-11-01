class CheapPrizeCount < ApplicationRecord
  belongs_to :wheel_prize

  def increase_prize_number
    increment!(:prize_number)
  end
end
