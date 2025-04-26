import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arthub_flutter/widgets/checkout_summary_card.dart';
import 'package:arthub_flutter/widgets/promo_code_input.dart';
import 'package:arthub_flutter/widgets/checkout_button.dart';
import 'package:arthub_flutter/widgets/payment_method_selector.dart';
import 'package:arthub_flutter/widgets/shipping_address_card.dart';
import 'package:arthub_flutter/widgets/credit_card_widget.dart';

void main() {
  group('CheckoutSummaryCard Widget Tests', () {
    testWidgets('displays correct total calculation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutSummaryCard(
              subtotal: 100.0,
              tax: 10.0,
              shippingCost: 5.0,
              discount: 15.0,
              currencySymbol: '\$',
            ),
          ),
        ),
      );

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('\$100.00'), findsOneWidget); // Subtotal
      expect(find.text('\$10.00'), findsOneWidget); // Tax
      expect(find.text('\$5.00'), findsOneWidget); // Shipping
      expect(find.text('-\$15.00'), findsOneWidget); // Discount
      expect(find.text('\$100.00'), findsOneWidget); // Total (100 + 10 + 5 - 15)
    });
  });

  group('PromoCodeInput Widget Tests', () {
    testWidgets('handles promo code input and submission', (WidgetTester tester) async {
      String? submittedCode;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCodeInput(
              onApplyCode: (code) => submittedCode = code,
              isLoading: false,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'DISCOUNT50');
      await tester.pump();

      await tester.tap(find.text('Apply'));
      await tester.pump();

      expect(submittedCode, equals('DISCOUNT50'));
    });

    testWidgets('shows error message when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCodeInput(
              onApplyCode: (_) {},
              errorMessage: 'Invalid promo code',
            ),
          ),
        ),
      );

      expect(find.text('Invalid promo code'), findsOneWidget);
    });
  });

  group('CheckoutButton Widget Tests', () {
    testWidgets('displays correct total and handles tap', (WidgetTester tester) async {
      bool checkoutPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutButton(
              total: 150.0,
              onCheckout: () => checkoutPressed = true,
              currencySymbol: '\$',
            ),
          ),
        ),
      );

      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      expect(checkoutPressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutButton(
              total: 150.0,
              onCheckout: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('PaymentMethodSelector Widget Tests', () {
    testWidgets('displays all payment methods and handles selection', (WidgetTester tester) async {
      String selectedMethod = 'card';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodSelector(
              selectedMethod: selectedMethod,
              onMethodSelected: (method) => selectedMethod = method,
            ),
          ),
        ),
      );

      expect(find.text('Debit / Credit Card'), findsOneWidget);
      expect(find.text('Netbanking'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('Wallet'), findsOneWidget);
    });
  });

  group('ShippingAddressCard Widget Tests', () {
    testWidgets('displays address information correctly', (WidgetTester tester) async {
      bool editPressed = false;
      bool cardTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShippingAddressCard(
              name: 'John Doe',
              addressLine1: '123 Main St',
              addressLine2: 'Apt 4B',
              city: 'New York',
              state: 'NY',
              zipCode: '10001',
              phoneNumber: '+1 234 567 8900',
              isSelected: true,
              onTap: () => cardTapped = true,
              onEdit: () => editPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Apt 4B'), findsOneWidget);
      expect(find.text('New York, NY - 10001'), findsOneWidget);
      expect(find.text('+1 234 567 8900'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(editPressed, isTrue);

      await tester.tap(find.byType(GestureDetector));
      expect(cardTapped, isTrue);
    });
  });

  group('CreditCardWidget Tests', () {
    testWidgets('displays card information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditCardWidget(
              holderName: 'John Doe',
              cardNumber: '4111111111111111',
              expiryDate: '12/25',
              cvc: '123',
              cardType: 'visa',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('4111 **** **** 1111'), findsOneWidget);
      expect(find.text('12/25'), findsOneWidget);
      expect(find.text('VISA'), findsOneWidget);
    });
  });
} 