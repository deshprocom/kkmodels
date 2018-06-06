##
# API接口调用的返回结果
# code: 错误代码 0 - 成功; 其他为错误
# msg:  错误代码的相应描述信息
# data: 成功(code为0)时，API返回的数据对象，以Hash方式传递

class ApiResult
  attr_accessor :code, :msg, :data
  SUCCESS_CALL = 0
  def initialize(code = 0, msg = 'ok', data = {})
    self.code = code
    self.msg = msg
    self.data = data
  end

  ##
  # 是否为失败结果
  def failure?
    code != SUCCESS_CALL
  end

  ##
  # 返回缺省的成功对象, 用于避免内存中生成过多的默认成功实例
  def self.success_result
    @success_result ||= new
  end

  ##
  # 返回成功对象及对应的状态码
  def self.success_with_data(data)
    new(SUCCESS_CALL, 'ok', data)
  end

  ##
  # 返回给定错误码的api result
  def self.error_result(msg, code = 1)
    new(code, msg)
  end
end