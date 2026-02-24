class BaseError < StandardError
  attr_reader :url, :status, :details

  def initialize(url:, status:, details: {})
    @url = url
    @status = status
    @details = details
    super()
  end
end
