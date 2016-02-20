# Graph API

    preapproval = setup_preapproval
    response = redirect_to_paypal(preapproval)
    payment = make_preapproved_payments('PA-4VA053122X761582C')
    result = retrieve_payment_data(payment.pay_key)

    Create preapproval request
    https://paypal-sdk-samples.herokuapp.com/adaptive_payments/preapproval