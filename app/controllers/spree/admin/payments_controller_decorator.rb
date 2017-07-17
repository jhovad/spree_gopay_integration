Spree::Admin::PaymentsController.class_eval do

  after_action :build_gopay_transaction, only: [:create]
  
  def build_gopay_transaction
    
    puts "FIRE FIRE FIRE !!!!! 1"
    
    if @payment.payment_method.kind_of?(Spree::PaymentMethod::Gopay)
      
      # prepare the line items for the request to establish payment
      gopay_payment = GopayHelper.prepare_payment(@payment.order, request)
        
      # establish the payment
      establish_response = GoPay::Payment.create(gopay_payment)
    
      # store important data as *source* of the Payment
  		transaction = GopayHelper.create_transaction(establish_response)
      
      @payment.source = transaction
      @payment.save!
      
      puts "FIRE FIRE FIRE !!!!!"
      
    end
  end

end
