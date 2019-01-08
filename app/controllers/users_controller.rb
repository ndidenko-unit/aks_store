class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :blocked_user!, :only_for_admin!

  def admin
    @users = User.all
    @roles = [:admin, :seller, :block]
  end

  def change_role
    @user = User.find(params[:user_id])
    @user.update_attribute :role, params[:role]
  end

end
