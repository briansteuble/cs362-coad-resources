class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  private

  def authenticate_admin!
    if current_user.nil?
      redirect_to new_user_session_path
    elsif !current_user.admin?
      redirect_to dashboard_path
    end
  end
end
