class CreateGopayTransaction < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_gopay_transactions do |t|
      t.string :instrument
      t.string :swift
      t.string :gw_url
      t.bigint :gopay_payment_id
      t.text :establish_response
      t.text :notification_params
      t.text :status_response
    end
  end
end
