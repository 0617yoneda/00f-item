class ProductsController < ApplicationController

  def index
    @products = Product.page(params[:page])
    @categories = Category.all
    @tax = 0.08
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @products = @category.products.page(params[:page])
    end
  end


  def show
    @tax = 0.08
    @categories = Category.all
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end

end
