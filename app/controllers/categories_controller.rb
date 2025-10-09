class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:name)
    render json: @categories
  end
end
