Spree::Core::Engine.routes.draw do
  get '/gopay/notify', to: 'gopay#notify'
  get '/order/new_gopay_transaction/:id', to: 'gopay#new_gopay_transaction', as: :new_gopay_transaction
end
