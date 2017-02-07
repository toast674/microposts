class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  
  
  def show
    @user = User.find(params[:id])
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


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location, :profile)
  end
  
  def set_user
    @user = User.find(params[:id])
    unless @user == current_user
       flash[:danger] = 'ログインユーザーが異なります'
       redirect_to root_path
    end
  end
end