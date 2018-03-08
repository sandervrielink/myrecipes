class SessionsController < ApplicationController

  def new

  end

  def create
    chef = Chef.find_by(email: params[:session][:email].downcase)
    if chef && chef.authenticate(params[:session][:password])
      session[:chef_id] = chef.id
      flash[:success] = "Succescol ingelogd"
      redirect_to chef
    else
      flash.now[:danger] = "Er is iets mis met de login informatie"
      render 'new'
    end
  end

  def destroy
    session[:chef_id] = nil
    flash[:success] = "Uitgelogd"
    redirect_to root_path
  end

end
