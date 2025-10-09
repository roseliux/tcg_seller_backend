class CardSetsController < ApplicationController
  def index
    # Filter by name if 'q' parameter is provided
    if params[:q].present?
      @card_sets = CardSet.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @card_sets = CardSet.all.order(:name)
    end

    render json: @card_sets
  end
end
