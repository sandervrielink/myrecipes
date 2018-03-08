class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_chef, :logged_in?

  def current_chef
    @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id]
  end

  def logged_in?
    !!current_chef #gives true or false for current_chef
  end

  def require_user
    #we use flash here because logged_in is not an variable with a @ so we could not use this in a view template
    if !logged_in?
      flash[:danger] = "Dit kan alleen met inlog"
      redirect_to root_path
    end
  end
end
