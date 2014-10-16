Spree::PaymentMethod::DISPLAY << :pos
Spree::PaymentMethod.class_eval do
  def use_calculator?
    false
  end
end
