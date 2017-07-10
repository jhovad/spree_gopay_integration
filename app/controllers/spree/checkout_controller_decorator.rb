Spree::CheckoutController.class_eval do

  before_action :get_available_gopay_instruments, only: [:update, :edit], if: proc { params[:state].eql?('payment') }
  before_action :pay_with_gopay, only: :update, if: proc { params[:state].eql?('payment') }

  private
  
  def get_available_gopay_instruments
    response = GoPay::Payment.payment_instruments(current_order.currency)
    @available_gopay_instruments = response["enabledPaymentInstruments"]
  end

  def pay_with_gopay    
    pm_id = params[:order][:payments_attributes].first[:payment_method_id]
    payment_method = Spree::PaymentMethod.find(pm_id)
    return unless payment_method && payment_method.kind_of?(Spree::PaymentMethod::Gopay)

    # prepare the line items for the request to establish payment
    gopay_payment = GopayHelper.prepare_payment(current_order, request, params[:gopay_instrument], params[:gopay_swift])
        
    # establish the payment
    establish_response = GoPay::Payment.create(gopay_payment)

    # store important data as *source* of the Payment
		transaction = GopayHelper.create_transaction(establish_response, params[:gopay_instrument], params[:gopay_swift])
    
    # create/update relation to *source* from the Payment
    params[:order][:payments_attributes].first.permit
    params[:order][:payments_attributes][0] = params[:order][:payments_attributes][0].merge({source_type: "Spree::GopayTransaction", source_id: transaction.id})

  rescue StandardError => e
    gopay_error(e)
  end

  def gopay_error(e = nil)
    @order.errors[:base] << "GoPay error #{e.try(:message)}"
    render :edit
  end

end
