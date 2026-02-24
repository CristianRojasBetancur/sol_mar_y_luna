module ExceptionsHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :render_internal_error
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
    rescue_from BaseError, with: :render_domain_error
  end

  private

  def render_domain_error(error)
    render json: ErrorSerializer.serialize([ error ]), status: error.status
  end

  def render_not_found(error)
    domain_error = Errors.not_found(resource: error.model)

    render json: ErrorSerializer.serialize([ domain_error ]), status: :not_found
  end

  def render_bad_request(error)
    domain_error = Errors.bad_request(param: error.param)

    render json: ErrorSerializer.serialize([ domain_error ]), status: :bad_request
  end

  def render_record_invalid(error)
    errors = error.record.errors.map.with_index do |err, index|
      BaseError.new(
        code: "validation.#{err.attribute}",
        status: :unprocessable_entity,
        details: { message: err.message }
      )
    end

    render json: ErrorSerializer.serialize(errors), status: :unprocessable_entity
  end

  def render_internal_error(error)
    Rails.logger.error(error)
    Rails.logger.error(error.backtrace.join("\n"))
    timestamp = Time.current.iso8601

    root = exception
    root = root.cause while root.cause
    filtered_trace = Rails.backtrace_cleaner.clean(root.backtrace || [])

    File.open(Rails.root.join("out.txt"), "a") do |file|
      file.puts "=============================="
      file.puts "TIME: #{timestamp}"
      file.puts "ERROR: #{root.class}"
      file.puts "MESSAGE: #{root.message}"
      file.puts "FILTERED TRACE:"
      filtered_trace.each { |line| file.puts(line) }
      file.puts
    end
    domain_error = Errors.internal_server_error

    render json: ErrorSerializer.serialize([ domain_error ]), status: :internal_server_error
  end
end
