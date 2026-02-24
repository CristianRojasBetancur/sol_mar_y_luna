class V1::AuthController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    user = User.find_by!(email_address: auth_params[:email])
    raise Errors.unauthorized unless user.authenticate(auth_params[:password])

    set_auth_cookie(user)
    render json: { message: "Logged in" }, status: :ok
  end

  def destroy
    cookies.delete(:authorization)
    render json: { message: "Logged out" }, status: :ok
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end

  def set_auth_cookie(user)
    cookies.encrypted[:authorization] = {
      value: Jwt::Encoder.call(jwt_payload(user)),
      expires: 1.hour.from_now,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end

  def jwt_payload(user)
    now = Time.current.to_i

    {
      sub: user.id,
      iat: now,
      exp: now + 1.hour.to_i,
      iss: "bookings_management_api",
      aud: "bookings_management_client",
      jti: SecureRandom.uuid
    }
  end
end
