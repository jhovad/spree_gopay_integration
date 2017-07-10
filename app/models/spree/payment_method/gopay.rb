module Spree
  class PaymentMethod::Gopay < PaymentMethod
    
    def auto_capture?
      false
    end

    def provider_class
      nil
    end

    def payment_source_class
      nil
    end

    def payment_profiles_supported?
      false
    end

    def source_required?
      false
    end
    
  end
end
