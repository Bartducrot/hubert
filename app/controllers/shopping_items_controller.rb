class ShoppingItemsController < ApplicationController
  before_action :set_shopping_item

  def update
    if @shopping_item.bought
      @shopping_item.bought = false
    else
      @shopping_item.bought = true
    end
    @shopping_item.save
    redirect_to shopping_cart_path
  end

  private

  def set_shopping_item
    @shopping_item = ShoppingItem.find(params[:id])
  end
end
