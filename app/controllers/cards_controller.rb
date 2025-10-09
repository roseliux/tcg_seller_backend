class CardsController < ApplicationController
  def index
    # Filter by name if 'q' parameter is provided
    if params[:q].present?
      @cards = Card.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @cards = Card.order(:name)
    end

    render json: @cards
  end
end
