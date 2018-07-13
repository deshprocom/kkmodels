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
end
