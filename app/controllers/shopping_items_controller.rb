class ShoppingItemsController < ApplicationController
  before_action :set_shopping_item

  def update
    @shopping_item.bought = true
    @show_item.save
    redirect_to :back
  end

  private

  def set_shopping_item
    @shopping_item = ShoppingItem.find(params[:id])
  end
end
