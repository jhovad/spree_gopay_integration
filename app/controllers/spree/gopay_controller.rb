module Spree
  class GopayController < Spree::BaseController
    protect_from_forgery except: [:notify, :continue] # todo / continue

    def notify
      begin
        GopayHelper.check_status(params[:id])
      rescue
        head 500, content_type: "text/html"
      else
        head 200, content_type: "text/html"
      end
    end
    
    
    def new_payment
            
      # validates that user is logged in and belongs to this order ? (but what about quest)
      
      # if last payment for the order wat the gopay and failed, then ... (maybe it's not so big security issue if someone reinit the failed payment)
      
      # params[:order_number]
      
      
      
    end
    
    
  end
end
