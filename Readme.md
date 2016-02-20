# Graph API

    ruby preapproval_payment.rb
    preapproval = setup_preapproval
    response = redirect_to_paypal(preapproval)
    payment = make_preapproved_payments('PA-8WT82945K8905710V')
    result = retrieve_payment_data('AP-1KS56221XG891773K')