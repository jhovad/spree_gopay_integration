Deface::Override.new( :virtual_path => "spree/orders/show",
                      :insert_before => "#order",
                      :name => 'add_gopay_payment_button',
                      :partial => "spree/orders/gopay_status" )