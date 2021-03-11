module SpreeGopayIntegration::Admin::PaymentsControllerDecorator

  def self.prepended(base)

    base.after_action :build_gopay_transaction, only: [:create]

  end
  
  def build_gopay_transaction
    
    if @payment.payment_method.kind_of?(Spree::PaymentMethod::Gopay)
      
      # prepare the line items for the request to establish payment
      gopay_payment = GopayHelper.prepare_payment(@payment.order, request)
        
      # establish the payment
      establish_response = GoPay::Payment.create(gopay_payment)
    
      # store important data as *source* of the Payment
  		transaction = GopayHelper.create_transaction(establish_response)
      
      @payment.source = transaction
      @payment.save!
      
    end
  end

end

::Spree::Admin::PaymentsController.prepend(SpreeGopayIntegration::Admin::PaymentsControllerDecorator)