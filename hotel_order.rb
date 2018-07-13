class HotelOrder < ApplicationRecord
  belongs_to :user
  belongs_to :hotel_room
  has_many :checkin_infos
  has_one :recent_refund, -> { order(id: :desc) },
          class_name: 'HotelRefund',
          foreign_key: :order_id
  has_many :hotel_refunds, foreign_key: :order_id
  has_one :coupon, as: :target

  serialize :room_items, JSON
  enum status: { unpaid: 'unpaid',
                 paid: 'paid',
                 confirmed: 'confirmed',
                 refunded: 'refunded',
                 canceled: 'canceled',
                 deleted: 'deleted', }

  PAY_STATUSES = %w[unpaid paid].freeze
  validates :pay_status, inclusion: { in: PAY_STATUSES }

  PAY_CHANNELS = %w[weixin ali].freeze
  validates :pay_channel, inclusion: { in: PAY_CHANNELS }

  def total_price_from_items
    @total_price_from_items ||= room_items.map { |i| i['price'].to_f }.sum
  end

  def nights_num
    (checkout_date - checkin_date).to_i
  end

  def pay_title
    hotel_room.hotel.title
  end

  STATUS_TEXT_TRANS = {
    refund_pending: '退款申请中',
    refund_refused: '拒绝退款',
    unpaid: '未支付',
    paid: '已支付',
    confirmed: '待入住',
    refunded: '已退款',
    canceled: '已取消',
  }.freeze
  # 状态显示的第一优先级为 退款中，退款失败
  def status_text
    if recent_refund&.refund_status.in?(%w[pending refused])
      return STATUS_TEXT_TRANS["refund_#{recent_refund.refund_status}".to_sym]
    end

    STATUS_TEXT_TRANS[status.to_sym]
  end

  def refundable?
    return false if unpaid? || refunded? || recent_refund&.refund_status == 'pending'

    true
  end

  TRANS_PAY_CHANNELS = {
    weixin: '微信支付',
    ali: '支付宝'
  }.freeze
  def pay_channel_text
    TRANS_PAY_CHANNELS[pay_channel.to_sym]
  end

  # notifiable
  before_update :notify_after_paid
  def notify_after_paid
    return unless pay_status_was == 'unpaid' && pay_status == 'paid'

    notify_user_after_paid
    OrderMailer.notify_staff_after_paid(self).deliver_later
  end

  # "[澳门旅行]预定成功:澳门金沙城中心假日酒店7月14日入住假日高级房2间1晚，入住人请携带有效证件及入境标签联系客服：#{ENV['HOTEL_STAFF_TEL']}办理入住。"
  NOTICE_USER_AFTER_PAID_SMS = "[澳门旅行]预定成功:%s，入住人请携带有效证件及入境标签联系客服: #{ENV['HOTEL_STAFF_TEL']} 办理入住。"
  def notify_user_after_paid
    # 酒店订单支付后，短信通知用户
    date = checkin_date.strftime('%m月%d日')
    title = "#{hotel_room.hotel.title}#{date}入住#{hotel_room.title}#{room_num}间#{nights_num}晚"
    sms_content = format(NOTICE_USER_AFTER_PAID_SMS, title)
    SendMobileIsmsJob.perform_later(telephone, sms_content)
  end
end
