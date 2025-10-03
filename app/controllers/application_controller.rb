class ApplicationController < ActionController::API
  def health
    render json: {
      status: "ok",
      timestamp: Time.current.iso8601
    }
  end
end
