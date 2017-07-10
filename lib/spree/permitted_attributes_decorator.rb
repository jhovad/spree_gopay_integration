Spree::PermittedAttributes.class_eval do
  @@payment_attributes.push(:source_type, :source_id)
end