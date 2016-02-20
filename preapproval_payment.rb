require 'pp-adaptive'
require 'pry'
require 'launchy'
require 'colorize'
require 'yaml'

def run
  pry.binding
end

# Setup the Payment and return pay object
def setup_preapproval
  api.execute :Preapproval, preapproval_payment_options
end

# Redirect the Customer to PayPal for Authorization and return response
def redirect_to_paypal(response)
  if response.success?
    p "Pay key: #{response.preapproval_key}".green
    Launchy.open(api.preapproval_url(response))
  else
    p "#{response.ack_code}: #{response.error_message}".red
  end
end

# Retrieve Data about the Payment (Optional)
def retrieve_payment_data(pay_key)
  api.execute(:PaymentDetails, pay_key: pay_key) do |response|
    if response.success?
      response.payment_info_list.payment_info.each do |payment|
        p "Receiver: #{payment.receiver.email}"
        p "Amount: #{payment.receiver.amount.to_f}"
        p "Transaction status: #{payment.transaction_status}".green
      end
    else
      p "#{response.ack_code}: #{response.error_message}".red
    end
    return response
  end
end

# Make preapproved payments to receivers
def make_preapproved_payments(preapproval_key)
  api.execute :Pay, payment_options(preapproval_key)
end

def preapproval_payment_options
  {
    ending_date: DateTime.now.next_year,
    starting_date: DateTime.now,
    senderEmail: 'opotto2@gmail.com',
    max_total_amount: BigDecimal("2000.00"),
    currency_code: "USD",
    cancel_url: "http://site.com/cancelled",
    return_url: "http://site.com/completed"
  }
end

def payment_options(preapproval_key)
  {
    preapproval_key: preapproval_key,
    action_type:    "PAY",
    currency_code:  "USD",
    cancel_url:     "https://your-site.com/cancel",
    return_url:     "https://your-site.com/return",
    receivers:      [
      { email: "onurkucukkece-buyer@gmail.com", amount: 900, primary: true },
      { email: 'onurkucukkece-facilitator@gmail.com', amount: 100 }
    ]
  }
end

def api
  AdaptivePayments::Client.new(
    sandbox: true,
    app_id: 'APP-80W284485P519543T',
    user_id: 'opotto_api1.gmail.com',
    password: '5X4XVKF7XUV3TG9J',
    signature: 'AH6d1xBXrGOpE-RZEFdL.zYTFUW0ANeJL59zIFyiDm3ijpwFopvxNwW9'
  )
end

run