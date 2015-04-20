class OrdersController < ApplicationController
before_action :authorize_user

  def show
    @order = current_user.orders.where(paid: false)[0]
    unless @order
      @order = current_user.orders.where(paid: true).last
    end
    @shop = params[:shop_id]
  end

  def edit

    @order = Order.find(params[:id])
  	if params[:paid]
  		@order.paid = true
      @order.save
  	elsif params[:order_status] == "fulfilled"
      @order.order_status = "fulfilled"
      @order.save
      flash[:notice] = "Order Status Changed"
    end
  	redirect_to(:back)
  end

  def index
    @shop = Shop.find(params[:shop_id])
    @orders = @shop.orders.where("order_status = ? or paid = ?", "submitted", false)
    @orders = @orders.order("order_status ASC, paid ASC")
  end

  def destroy
    @orderjoins = Orderjoin.where(order_id: params[:id])
    Orderjoin.delete(@orderjoins)
    flash[:notice] = "Order Cleared"
    redirect_to(:back)
  end

  private

  def authorize_user
    redirect_to new_user_session_path if current_user == nil
  end
end
