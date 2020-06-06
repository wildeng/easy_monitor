class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    raise StandardError
    @user = User.find(params["id"])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    render :show
  end

  def update
    @user = User.find(params[:id])
    @user.name = params['name']
    @user.email = params['email']
    @user.save
    redirect_to user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
