class Withdrawal < ApplicationRecord
  belongs_to :user

  # 计算用户单月提款成功金钱
  def self.month_success_withdraw(user)
    month_amount = user.withdrawals.where('created_at BETWEEN ? AND ?', Time.now.at_beginning_of_month, Time.now.at_end_of_month)
    pending_or_success = month_amount.where.not(option_status: 'failed').sum(:amount)
    failed_amount = month_amount.where(option_status: 'failed').sum(:amount)
    BigDecimal(pending_or_success) - BigDecimal(failed_amount)
  end
  
  # 审核操作
  def admin_change_status(status, by_admin)
    # 只有审核中的可以操作
    return unless option_status.eql?('pending')
    # 记录明细
    PocketMoney.create_withdraw_record(user: user,
                                       target: self,
                                       status: status,
                                       amount: BigDecimal(amount))
    # 更改状态
    update(option_status: status,
           option_time: Time.zone.now,
           memo: "#{by_admin}更改状态：#{option_status} -> #{status}")
  end
end
