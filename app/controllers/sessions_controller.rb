class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to '/login', notice: "Неверный email или пароль"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/users'
  end
end
