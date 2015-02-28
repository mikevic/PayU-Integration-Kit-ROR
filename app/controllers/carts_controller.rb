class CartsController < ApplicationController

  def index
    @carts = Cart.all
  end

  def show        
    @cart = current_cart
  end

  def new
    @cart = Cart.new
  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.new(params[:cart])
  end

  def update
    @cart = Cart.find(params[:id])
  end

  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
  end

  def payu_return
    notification = PayuIndia::Notification.new(request.query_string, options = {:key => 'YOUR_KEY', :salt => 'YOUR_SALT', :params => params})

    @cart = Cart.find(notification.invoice) # notification.invoice is order id/cart id which you have submited from payment direction page.

    if notification.acknowledge      
      begin
        if notification.complete?          
          @cart.status = 'success'
          @cart.purchased_at = Time.now
          @order = Order.create(:total => notification.gross, :card_holder_name => params['name_on_card'], :order_number => notification.invoice)
          reset_session
          redirect_to @order
        else          
          @cart.status = "failed"
          render :text => "Order Failed! #{notification.message}"
        end
      ensure
        @cart.save
      end
    end    
  end
end
