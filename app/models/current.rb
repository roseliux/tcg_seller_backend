class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user
  attribute :user_agent, :ip_address

  def user
    @user ||= session&.user
  end
end
