class CardsController < ApplicationController
  include Pagy::Backend

  def index
    # Filter by name if 'q' parameter is provided
    if params[:q].present?
      @pagy, @records = pagy(Card.where("LOWER(name) LIKE LOWER(?)", "%#{params[:q]}%"))
    else
      @pagy, @records = pagy(Card.order(:name))
    end

    render json: { data: @records, pagy: pagy_metadata(@pagy) }
  end
end
