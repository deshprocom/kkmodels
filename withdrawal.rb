class Withdrawal < ApplicationRecord
  belongs_to :user

  # 计算用户单月提款成功金钱
  def self.month_success_withdraw(user)
    user.withdrawals
        .where.not(option_status: 'failed')
        .where('created_at BETWEEN ? AND ?', Time.now.at_beginning_of_month, Time.now.at_end_of_month)
        .sum(:amount)
  end

  # 审核操作
  def admin_change_status(status, by_admin)
    update(option_status: status,
           option_time: Time.zone.now,
           memo: "#{by_admin}更改状态：#{option_status} -> #{status}")
  end
end
