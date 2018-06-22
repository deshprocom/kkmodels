class ViewToggle < ApplicationRecord
  belongs_to :target, polymorphic: true

  # 只更新打开并且间隔时间在规则之内并且打开两个月之内的
  def self.toggle_on
    where('toggle_status', true) && where('begin_time > ?', 60.days.ago)
  end

  # 得到距离今天是第几天
  def period
    (Time.zone.today - begin_time.to_date).to_i
  end

  def current_rule
    current_period = period + 1
    last_rule = ViewRule.where('hot': hot).order('day': :desc).last
    return last_rule if current_period > last_rule.day
    rule = ViewRule.where('day': current_period).find_by('hot': hot)
    rule.presence || last_rule
  end

  def rule_exist?
    ViewRule.exists?('hot': hot)
  end
end
