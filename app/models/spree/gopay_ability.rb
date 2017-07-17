module Spree
  class GopayAbility
    include CanCan::Ability
    def initialize(user)
      can [:new_gopay_transaction], Order do |order, token|
        order.user == user || order.guest_token && token == order.guest_token
      end
    end
  end
end

