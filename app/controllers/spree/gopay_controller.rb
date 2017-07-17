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
    
  end
end
