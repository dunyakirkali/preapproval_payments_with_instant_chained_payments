# Graph API

    ruby preapproval_payment.rb
    preapproval = setup_preapproval
    response = redirect_to_paypal(preapproval)
    payment = make_preapproved_payments('PA-8WT82945K8905710V')
    result = retrieve_payment_data(payment.pay_key)
    secondary = make_payment_to_secondary(payment.pay_key)