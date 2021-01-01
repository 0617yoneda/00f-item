class HomesController < ApplicationController
  def top
    @products = Product.all
    @recommend = Product.limit(4)
    @categories = Category.all
    @tax = TAX
  end

  def about
  end

end
