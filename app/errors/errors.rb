module Errors
  def self.not_found(resource:)
    BaseError.new(
      url: "not_found",
      status: :not_found,
      details: { resource: }
    )
  end

  def self.unauthorized
    BaseError.new(
      url: "unauthorized",
      status: :unauthorized
    )
  end

  def self.bad_request(param:)
    BaseError.new(
      url: "bad_request",
      status: :bad_request,
      details: { param: }
    )
  end

  def self.unprocessable_entity(error_url:, details: {})
    BaseError.new(
      url: error_url,
      status: :unprocessable_entity,
      details: details
    )
  end

  def self.internal_server_error
    BaseError.new(
      url: "internal_server_error",
      status: :internal_server_error
    )
  end
end
