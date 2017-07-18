Spree::OrdersController.class_eval do
  
  before_action :check_payment_status, only: :show
  
  def check_payment_status
    order = Spree::Order.find_by!(number: params[:id])
    payment = order.payments.last
    if payment.payment_method.kind_of?(Spree::PaymentMethod::Gopay)     
      GopayHelper.check_status(payment.source.gopay_payment_id)
    end
  end
  
end