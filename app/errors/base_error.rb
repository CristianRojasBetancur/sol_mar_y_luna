class BaseError < StandardError
  attr_reader :error_url, :status, :details

  def initialize(error_url:, status:, details: {})
    @error_url = error_url
    @status = status
    @details = details
    super()
  end
end
