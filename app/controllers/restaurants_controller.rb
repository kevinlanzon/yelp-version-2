class RestaurantsController < ApplicationController

  before_action :find_restaurant, only: [:show, :edit, :update, :destroy]


  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.create(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
      params.require(:restaurant).permit(:name)
  end

  def index
    @restaurants = Restaurant.all
  end

  def show
  end

  def edit
  end

  def update
    @restaurant.update(restaurant_params)
    flash[:notice] = "Restaurant updated"
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant.destroy
    flash[:notice] = "Restaurant deleted"
    redirect_to '/restaurants'
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

end