class ChefsController < ApplicationController

  def new
    @chef = Chef.new
  end

  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welkom #{@chef.chefname} op ChefRecept!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    @chef = Chef.find(params[:id])
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end

  def edit
    @chef = Chef.find(params[:id])
  end

  def destroy
  @chef = Chef.find(params[:id])
  @chef.destroy
  flash[:danger] = "Chef en alle bijbehorende recepten zijn verwijderd"
  redirect_to chefs_path
  end

  def update
    @chef = Chef.find(params[:id])
    if @chef.update(chef_params)
      flash[:success]="Account is aangepast en opgeslagen"
      redirect_to @chef
    else
      render 'edit'
    end
  end

  private

  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end
end
