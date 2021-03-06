class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def new
    @chef = Chef.new
  end

  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 15)
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      session[:chef_id] = @chef.id
      flash[:success] = "Welkom #{@chef.chefname} op ChefRecept!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 15)
  end

  def edit
  end

  def destroy
    @chef.destroy
    flash[:danger] = "Chef en alle bijbehorende recepten zijn verwijderd"
    redirect_to chefs_path
  end

  def update
    if @chef.update(chef_params)
      flash[:success]="Account is aangepast en opgeslagen"
      redirect_to @chef
    else
      render 'edit'
    end
  end

  private

  def set_chef
    @chef = Chef.find(params[:id])
  end

  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

  def require_same_user
    if current_chef != @chef
      flash[:danger] = "Alleen eigen account kan worden aangepast en verwijderd"
      redirect_to chefs_path
    end
  end
end
