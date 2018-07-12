class Withdrawal < ApplicationRecord
  belongs_to :user

  # 计算用户单月提款成功金钱
  def self.month_success_withdraw(user)
    user.withdrawals
        .where(option_status: 'success')
        .where('created_at BETWEEN ? AND ?', Time.now.at_beginning_of_month, Time.now.at_end_of_month)
        .sum(:amount)
  end
end
