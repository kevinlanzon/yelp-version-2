class ReviewsController < ApplicationController

  before_action :find_restaurant, only: [:new, :create]

  def new
    @review = Review.new
  end

  def create
    @restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end