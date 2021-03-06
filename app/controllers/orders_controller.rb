class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @customer = Customer.find(current_customer.id)
    @addresses = Address.where(customer_id: current_customer.id)
  end

  def create
    order = Order.new(order_params)
    order.save
    if params[:address_form] == 2
      new_address = Address.new
      new_address.customer_id = current_customer.id
      new_address.postal_code = params[:order][:postal_code]
      new_address.address = params[:order][:address]
      new_address.name = params[:order][:name]
      new_address.save
    end
    @cart_products = current_customer.cart_products
    @cart_products.each do |cart_product|
      @order_product = OrderProduct.new
      @order_product.order_id = order.id
      @order_product.product_id = cart_product.product_id
      @order_product.price = cart_product.product.price
      @order_product.amount = cart_product.amount
      @order_product.save
    end
    @cart_products.delete_all
    redirect_to finish_path(order.id)
  end

  def index
    @orders = current_customer.orders
    @tax = TAX
  end

  def show
    @order = Order.find(params[:id])
    @product_price = 0
    @order.order_products.each do |order|
    @product_price += order.price * order.amount
    end
    @tax = TAX
  end

  def confirm
    @order = Order.new(order_params)
    @order.payment_method = params[:order][:payment_method]
    @cart_products = current_customer.cart_products

    @order_product = OrderProduct.new
    if params[:order][:address_form] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.customer_full_name
    elsif params[:order][:address_form] == "1"
      @address_id = params[:order][:order_address].to_i
      @address = Address.find_by(id: @address_id)
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:address_form] == "2"
      # 新規お届け先保存
      @address = Address.new(address_params)
      @address.customer_id = current_customer.id
      @address.save
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    end
    @tax = TAX
  end

  def finish
  end

  private
  def order_params
    params.require(:order).permit(:customer_id,:name, :postal_code,:address,:charge,:payment_method,:statusname, :postal_code, :address)
  end

  def address_params
    params.require(:address).permit(:name, :postal_code, :address)
  end

  def order_product_params
    params.require(:order_product).permit(:amount, :price,:product_id)
  end

end
