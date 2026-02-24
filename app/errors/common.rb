module Common
  class NotFoundError < BaseError
    def initialize(url_error:, status:, details: {})
      super
    end
  end

  class UnprocessableEntityError < BaseError
    def initialize(url_error:, status:, details: {})
      super
    end
  end
end

