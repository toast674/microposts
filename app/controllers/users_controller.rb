class UsersController < ApplicationController
  
  before_action :set_user, only: [:edit, :update, :show, :followings, :followers]
  
  def show
    # @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit 
  end
  
  def update
    if @user.update(user_params)
      # 保存に成功した場合はプロフィールページへリダイレクト
      flash[:info] = "更新されました"
      redirect_to current_user
    else 
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def followings 
    @users = @user.following_users
  end
  
  def followers
    @users = @user.follower_users
  end
  
  def like
    @user = User.find(params[:id])
    @like_microposts = @user.like_microposts
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location, :profile)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def confirm_user
      unless @user == current_user
       flash[:danger] = 'ログインユーザーが異なります'
       redirect_to root_path
      end
  end
end