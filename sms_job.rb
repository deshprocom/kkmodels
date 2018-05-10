# Sms任务队列
class SmsJob
  class << self
    def send_mobile(type, account, content)
      Rails.logger.info "send [#{content}] to #{account} in queue"
      SendMobileSmsJob.set(queue: 'send_mobile_sms').perform_later(type, account, content)
    end
  end
end