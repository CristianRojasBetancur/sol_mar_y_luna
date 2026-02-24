module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate_user!, **options
    end
  end

  private

  def authenticate_user!
    token = cookies.encrypted[:authorization]
    return unauthorized unless token

    payload, = Jwt::Decoder.call(token)
    @current_user = User.find(payload['sub'])
  rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
    unauthorized
  end

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
