class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  before_action :set_session, only: %i[ show destroy ]

  def index
    render json: Current.user.sessions.order(created_at: :desc)
  end

  def show
    render json: @session
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      response.set_header "X-Session-Token", @session.signed_id

      render json: @session, status: :created
    else
      render json: { error: "That email or password is incorrect" }, status: :unauthorized
    end
  end

  def destroy
    @session.destroy!
    Current.session = nil
    head :no_content
  end

  def destroy_current
    if Current.session
      Current.session.destroy!
      Current.session = nil
      Current.user = nil
      head :no_content
    else
      render json: { error: "No active session" }, status: :unauthorized
    end
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Session not found" }, status: :not_found
    end
end
