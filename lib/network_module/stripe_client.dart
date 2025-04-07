
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class StripeClient {
  Future<String> createPaymentMethodId(String cardNumber,
      String cardExpiryMonth, String cardExpiryYear, String cardCvc) async {

    // var userData = await RabbleStorage().retrieveDynamicValue(RabbleStorage().userKey);
    // UserModel userModel = UserModel.fromJson(jsonDecode(userData));

    stripe.CardDetails card = stripe.CardDetails(
        cvc: cardCvc,
        number: cardNumber,
        expirationMonth: int.parse(cardExpiryMonth),
        expirationYear: int.parse(cardExpiryYear));

    await stripe.Stripe.instance.dangerouslyUpdateCardDetails(card);

    final paymentMethod = await stripe.Stripe.instance.createPaymentMethod(
        params: stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: stripe.BillingDetails(
              phone:  '',
              email:  '',
              address: stripe.Address(
                city:   '',
                country: 'US',
                line1: '',
                line2: '',
                state: '',
                postalCode:  '',
              ),
            ),
          ),
        ));
   return paymentMethod.id;
  }
}