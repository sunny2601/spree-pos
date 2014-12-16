module Spree
  class PaymentMethod::CreditCardPos < PaymentMethod
    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(money, response_code, gateway_options)
      order = Spree::Order.find_by :number => gateway_options[:order_id].split('-')[0]
      if order.pos_sell
        ActiveMerchant::Billing::Response.new(true, "", {}, {})
      else
        ActiveMerchant::Billing::Response.new(false, 'Payment method not valid', {}, {})
      end
    end

    def cancel(response); end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def source_required?
      false
    end
  end
end
