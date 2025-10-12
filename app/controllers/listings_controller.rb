class ListingsController < ApplicationController
  def create
    user_id = Current.user.id
    @listing = Listing.new(listing_params.merge(user_id: user_id))
    if @listing.save
      # Renders app/views/listings/create.json.jbuilder by default
      # render json: @listing, status: :created
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # ... other actions ...

  private

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
