# 零钱明细memo
module PocketMoneyMemo
  extend ActiveSupport::Concern

  def memo
    send("#{option_type}_memo")
  end

  def invite_memo
    if indirect_invite?
      "好友#{target.nick_name}邀请了#{second_target.nick_name}"
    else
      "我邀请了好友#{target.nick_name}"
    end
  end

  def register_memo
    '新用户注册活动奖励'
  end

  def wheel_memo
    '转盘抽奖活动奖励'
  end

  def withdraw_pending_memo
    '用户提现'
  end

  def withdraw_failed_memo
    '提现失败'
  end
end
