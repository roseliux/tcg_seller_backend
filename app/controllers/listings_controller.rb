class ListingsController < ApplicationController
  before_action :require_listing_type, only: [:index]

  def index
    listing_type = params[:listing_type]

    # todo param filtering, pagination
    @listings = Current.user.listings.where(listing_type: listing_type).order(created_at: :desc)
  end
  def create
    user_id = Current.user.id
    @listing = Listing.new(listing_params.merge(user_id: user_id))

    unless @listing.save
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  def show
    @listing = Current.user.listings.find(params[:id])
  end

  def update
    @listing = Current.user.listings.find(params[:id])

    unless @listing.update(listing_params)
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private

  def require_listing_type
    unless params[:listing_type].in?(Listing::LISTING_TYPES)
      render json: { error: "Invalid or missing listing_type parameter" }, status: :bad_request
    end
  end

  def listing_params
    params.require(:listing).permit(
      :item_title,
      :listing_type,
      :condition,
      :title,
      :description,
      :price,
      :category_id,
      :card_set_id
    )
  end
end
