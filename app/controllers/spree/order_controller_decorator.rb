Spree::OrdersController.class_eval do
  
  before_action :check_payment_status, only: :show
  
  def check_payment_status
    order = Spree::Order.find_by!(number: params[:id])
    payment = order.payments.last
    if payment.payment_method.kind_of?(Spree::PaymentMethod::Gopay)     
      GopayHelper.check_status(payment.source.gopay_payment_id)
    end
  end
  
  # in case the transaction failed, user can establish the new one
  def new_gopay_transaction
    order = Spree::Order.find_by!(number: params[:id])
    payment = order.payments.last
      
    # check the payment failed
    if payment.state == "failed" && payment.payment_method.kind_of?(Spree::PaymentMethod::Gopay)     
      gopay_payment = GopayHelper.prepare_payment(order, request)
      
      # establish the gopay payment
      establish_response = GoPay::Payment.create(gopay_payment)
  		
      # store important data as *source* of the Payment
      transaction = GopayHelper.create_transaction(establish_response)
      
      # create payment with right relation to source
      payment_method = Spree::PaymentMethod.find_by_type("Spree::PaymentMethod::Gopay")
      order.payments.create(amount: order.total, payment_method: payment_method, source: transaction)
      redirect_to order_path(order) and return
    end
    
  rescue StandardError => e
    gopay_error(e)
  end

  def gopay_error(e = nil)
    @order.errors[:base] << "GoPay error #{e.try(:message)}"
    render :edit
  end
  
end