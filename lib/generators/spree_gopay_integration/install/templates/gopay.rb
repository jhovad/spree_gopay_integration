require 'gopay'

GoPay.configure do |config|
  config.return_host = 'localhost'
  config.notification_host = 'localhost'
  config.gate = 'https://testgw.gopay.cz'
  config.client_id = 'XXXXX'
  config.goid = 'XXXX'
  config.client_secret = 'XXXX'
end