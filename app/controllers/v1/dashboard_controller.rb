class V1::DashboardController < ApplicationController
  def index
    render json: { message: 'Holis' }, status: :ok
  end
end
