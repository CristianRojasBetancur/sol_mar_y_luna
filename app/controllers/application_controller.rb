class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Authentication
  include ExceptionsHandler
end
