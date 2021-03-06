class RecipesController < ApplicationController
  
  before_action :find_recipe, only: [:show, :edit, :update, :like]  # find recipe before showing, editing, or liking
  before_action :require_user, except: [:show, :index]              # users not logged in can only view recipe page and recipes index
  before_action :require_same_user, only: [:edit, :update]          # user can only edit their own recipe
  before_action :admin_user, only: [:destroy]                         # only admin user can delete a recipe
  
  
  def index
    # add pagination and display number of recipe items per page
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_user
    
    if @recipe.save
      flash[:success] = "Your recipe was created successfully!"
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Your recipe was updated successfully!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end
  
  def destroy 
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe has been deleted"
    redirect_to recipes_path
  end
  
  def like
    like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
    if like.valid?
      flash[:success] = "Your selection was successful"
      redirect_to :back
    else
      flash[:danger] = "You can only like or dislike a recipe once"
      redirect_to :back
    end
  end
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :summary, :description, :picture)
    end
    
    def find_recipe
      @recipe = Recipe.find(params[:id])
    end
  
    # logged in user can only edit their own recipes
    # admin user can edit all recipes
    def require_same_user
      if current_user != @recipe.chef and !current_user.admin?
        flash[:danger] = "You can only edit your own recipes"
        redirect_to :back
      end  
    end
    
    def admin_user
      redirect_to recipes_path unless current_user.admin?
    end
end