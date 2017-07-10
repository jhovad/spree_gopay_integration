module Spree
  class GopayTransaction < ActiveRecord::Base

    has_one :payment, as: :source

  end
end
