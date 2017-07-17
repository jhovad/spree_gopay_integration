class GopayHelper
  
  def self.check_status(id, params = nil)
    response = GoPay::Payment.retrieve(id)
    order = Spree::Order.where(number: response['order_number']).first
    transaction = Spree::GopayTransaction.find_by_gopay_payment_id(id)
    payment = transaction.payment
    
    transaction.notification_params = params.inspect
    transaction.status_response = response.inspect
    transaction.save

    unless payment.completed? || payment.failed?
      case response['state']
      when 'CANCELED', 'TIMEOUTED'
        payment.started_processing!
        payment.failure!
      when 'PAID'
        payment.started_processing!
        payment.complete!
      when 'PAYMENT_METHOD_CHOSEN'
        if ['_101', '_102', '_3001', '_3002'].include? response['sub_state']
          payment.pend!
        end
      end
    end
  end
  
  def self.prepare_payment(order, request, allowed_payment_instruments = nil, allowed_swifts = nil)
    
    puts allowed_swifts.inspect
      
    unless allowed_swifts.nil?
      gopay_payment_swift = [allowed_swifts]
    else
      gopay_payment_swift = []
    end
    
    puts gopay_payment_swift
    
    # prepare the line items for the request to establish payment
    line_items = Array.new
    order.line_items.each do |i|
      price = i.variant.prices.where(currency: order.currency).first.amount
      line_items << {name: i.variant.product.name, amount: (price * 100).to_i} # price in cents
    end
    
    # prepare whole request to establish payment
    gopay_payment = { 
      payer: {
        contact: {
          first_name: order.bill_address.firstname,
          last_name: order.bill_address.lastname,
          email: order.email
        }
      },
      amount: (order.total * 100).to_i, # total price in cents
      currency: order.currency,
      order_number: order.number,
      lang: I18n.locale,
      callback: {
        return_url: 'http://' + request.host + '/orders/' + order.number,
        notification_url: 'http://' + request.host + '/gopay/notify'
      },
      items: line_items
    }
    
    gopay_payment[:payer].merge!({allowed_payment_instruments: [allowed_payment_instruments]}) unless allowed_payment_instruments.nil?    
    gopay_payment[:payer].merge!({allowed_swifts: gopay_payment_swift}) unless allowed_swifts.nil?
    
    puts gopay_payment.inspect

    return gopay_payment
  end
  
  
  def self.create_transaction(establish_response, gopay_instrument = nil, gopay_swift = nil) 
    transaction = Spree::GopayTransaction.new

    transaction.instrument = gopay_instrument unless gopay_instrument.nil?
    transaction.swift = gopay_swift unless gopay_swift.nil?
    
    transaction.gw_url = establish_response["gw_url"]
    transaction.gopay_payment_id = establish_response["id"].to_i
    transaction.establish_response = establish_response.inspect

    transaction.save
    
    return transaction
  end
  
end