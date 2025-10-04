class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def create
    @user = User.new(user_params)

    if @user.save
      send_email_verification
      render json: user_json(@user), status: :created
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :user_name)
    end

    def user_json(user)
      {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        user_name: user.user_name,
        verified: user.verified,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
