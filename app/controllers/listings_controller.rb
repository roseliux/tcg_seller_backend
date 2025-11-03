class ListingsController < ApplicationController
  before_action :require_purpose_type, only: [:index]
  before_action :set_listing, only: [:show, :update]

  def index
    purpose = params[:purpose]

    # todo param filtering, pagination
    @listings = Current.user.listings.where(purpose: purpose).order(created_at: :desc)
  end
  def create
    @listing = Current.user.listings.build(listing_params.except(:location_postal_code))
    @listing.status = "active"

    # Find or create location by zipcode
    location = Location.find_or_create_by(postal_code: listing_params[:location_postal_code])
    @listing.location = location

    unless @listing.save
      render json: @listing.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
  end

  def update
    unless @listing.update(listing_params)
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private

  def set_listing
    @listing = Current.user.listings.find(params[:id])
  end

  def require_purpose_type
    unless params[:purpose].present? && Listing::PURPOSE_TYPES.include?(params[:purpose])
      render json: { error: "Invalid or missing purpose parameter. Must be one of: #{Listing::PURPOSE_TYPES.join(', ')}" }, status: :bad_request
    end
  end

  def listing_params
    params.require(:listing).permit(
      :title,
      :description,
      :condition,
      :purpose,
      :price,
      :location_postal_code,
      :item_type,
      :item_id,
      :category_id,
      :language
    )
  end
end
