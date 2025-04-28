import 'package:flutter/material.dart';
import 'package:arthub_flutter/widgets/custom_button.dart';
import 'package:arthub_flutter/widgets/custom_text_field.dart';
import 'package:arthub_flutter/widgets/custom_app_bar.dart';
import 'package:arthub_flutter/widgets/product_card.dart';
import 'package:arthub_flutter/widgets/category_card.dart';
import 'package:arthub_flutter/widgets/custom_search_bar.dart';
import 'package:arthub_flutter/widgets/auth_input_field.dart';
import 'package:arthub_flutter/widgets/otp_input_field.dart';
import 'package:arthub_flutter/widgets/form_input_field.dart';
import 'package:arthub_flutter/widgets/location_button.dart';
import 'package:arthub_flutter/widgets/payment_method_selector.dart';
import 'package:arthub_flutter/widgets/shipping_address_card.dart';
import 'package:arthub_flutter/widgets/credit_card_widget.dart';
import 'package:arthub_flutter/widgets/promo_code_input.dart';
import 'package:arthub_flutter/widgets/checkout_summary_card.dart';
import 'package:arthub_flutter/widgets/checkout_button.dart';
import 'package:arthub_flutter/widgets/section_header.dart';
import 'package:arthub_flutter/widgets/order_transaction_card.dart';
import 'package:arthub_flutter/widgets/profile_header.dart';
import 'package:arthub_flutter/widgets/profile_menu_item.dart';
import 'package:arthub_flutter/widgets/add_photo_box.dart';
import 'package:arthub_flutter/widgets/product_price_row.dart';
import 'package:arthub_flutter/widgets/tag_chip.dart';
import 'package:arthub_flutter/widgets/store_header.dart';
import 'package:arthub_flutter/widgets/empty_state.dart';
import 'package:arthub_flutter/widgets/product_image_carousel.dart';
import 'package:arthub_flutter/widgets/artist_info_row.dart';
import 'package:arthub_flutter/widgets/product_description.dart';
import 'package:arthub_flutter/widgets/product_details_table.dart';
import 'package:arthub_flutter/widgets/additional_details_row.dart';
import 'package:arthub_flutter/widgets/credit_card_carousel_indicator.dart';
import 'package:arthub_flutter/screens/add_address_screen.dart';
import 'package:arthub_flutter/screens/my_store_screen.dart';

class WidgetTestScreen extends StatefulWidget {
  const WidgetTestScreen({Key? key}) : super(key: key);

  @override
  State<WidgetTestScreen> createState() => _WidgetTestScreenState();
}

class _WidgetTestScreenState extends State<WidgetTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  bool _obscurePassword = true;
  String _selectedPaymentMethod = 'card';
  bool _addressTapped = false;
  bool _addressEdited = false;
  bool _checkoutPressed = false;
  String? _promoCode;

  @override
  void dispose() {
    _searchController.dispose();
    _textFieldController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Widget Test Screen',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(text: 'My Store', 
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyStoreScreen()))
              }
            ),
            
            CustomButton(text: 'Add Address', 
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen()))
              }
            ),
            
            // Auth Input Field Section
            const Text(
              'Auth Input Field Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D9B88),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  AuthInputField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthInputField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // OTP Input Field Section
            const Text(
              'OTP Input Field',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D9B88),
                borderRadius: BorderRadius.circular(12),
              ),
              child: OTPInputField(
                controllers: _otpControllers,
                focusNodes: _otpFocusNodes,
                onDigitChanged: _onOTPDigitChanged,
              ),
            ),
            const SizedBox(height: 24),

            // Custom Search Bar Section
            const Text(
              'Custom Search Bar Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) => print('Search: $value'),
              hintText: 'Search Products',
            ),
            const SizedBox(height: 8),
            CustomSearchBar(
              controller: TextEditingController(),
              onChanged: (value) => print('Search Categories: $value'),
              hintText: 'Search Categories',
            ),
            const SizedBox(height: 24),

            // Custom Text Field Section
            const Text(
              'Custom Text Field Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _textFieldController,
              hintText: 'Enter your name',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: TextEditingController(),
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Custom Button Section
            const Text(
              'Custom Button Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Primary',
                    onPressed: () => print('Primary button pressed'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Secondary',
                    onPressed: () => print('Secondary button pressed'),
                    backgroundColor: const Color(0xFF2D9B88),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Full Width Button',
              onPressed: () => print('Full width button pressed'),
              backgroundColor: const Color(0xFFEEEEEE),
              textColor: Colors.black87,
            ),
            const SizedBox(height: 24),

            // Product Cards Section
            const Text(
              'Product Card Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 180,
                    child: ProductCard(
                      imageUrl: 'https://picsum.photos/200/300',
                      title: 'Premium Product',
                      originalPrice: 199.99,
                      discountedPrice: 149.99,
                      onTap: () => print('Premium product tapped'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 180,
                    child: ProductCard(
                      imageUrl: 'https://picsum.photos/200/301',
                      title: 'Regular Product',
                      originalPrice: 99.99,
                      onTap: () => print('Regular product tapped'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 180,
                    child: ProductCard(
                      imageUrl: 'https://picsum.photos/200/302',
                      title: 'Sale Product',
                      originalPrice: 299.99,
                      discountedPrice: 199.99,
                      onTap: () => print('Sale product tapped'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Cards Section
            const Text(
              'Category Card Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                CategoryCard(
                  imageUrl: 'https://picsum.photos/200/150',
                  title: 'Paintings',
                  onTap: () => print('Paintings category tapped'),
                ),
                CategoryCard(
                  imageUrl: 'https://picsum.photos/200/151',
                  title: 'Sculptures',
                  onTap: () => print('Sculptures category tapped'),
                ),
                CategoryCard(
                  imageUrl: 'https://picsum.photos/200/152',
                  title: 'Photography',
                  onTap: () => print('Photography category tapped'),
                ),
                CategoryCard(
                  imageUrl: 'https://picsum.photos/200/153',
                  title: 'Digital Art',
                  onTap: () => print('Digital Art category tapped'),
                ),
              ],
            ),

            // Form Input Field Section
            const Text(
              'Form Input Field Variations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  FormInputField(
                    controller: TextEditingController(),
                    labelText: 'Full Name',
                  ),
                  const SizedBox(height: 16),
                  FormInputField(
                    controller: TextEditingController(),
                    labelText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  FormInputField(
                    controller: TextEditingController(),
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location Button Section
            const Text(
              'Location Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LocationButton(
              onPressed: () {
                print('Getting current location...');
              },
            ),
            const SizedBox(height: 24),

            const SizedBox(height: 32),
            const Text(
              'Checkout Widgets Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Payment Method Selector
            PaymentMethodSelector(
              selectedMethod: _selectedPaymentMethod,
              onMethodSelected: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
            ),
            const SizedBox(height: 16),
            // Shipping Address Card
            ShippingAddressCard(
              name: 'Jane Doe',
              addressLine1: '456 Elm St',
              addressLine2: 'Suite 12',
              city: 'Los Angeles',
              state: 'CA',
              zipCode: '90001',
              phoneNumber: '+1 555 123 4567',
              isSelected: true,
              onTap: () {
                setState(() {
                  _addressTapped = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shipping address tapped!')),
                );
              },
              onEdit: () {
                setState(() {
                  _addressEdited = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit address pressed!')),
                );
              },
            ),
            const SizedBox(height: 16),
            // Credit Card Widget
            CreditCardWidget(
              holderName: 'Darshan Raval',
              cardNumber: '550122334487',
              expiryDate: '16/23',
              cvc: '333',
              cardType: 'visa',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            const CreditCardCarouselIndicator(count: 3, currentIndex: 0),
            // Promo Code Input
            PromoCodeInput(
              onApplyCode: (code) {
                setState(() {
                  _promoCode = code;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Promo code applied: $code')),
                );
              },
            ),
            const SizedBox(height: 16),
            // Checkout Summary Card
            CheckoutSummaryCard(
              subtotal: 200.0,
              tax: 20.0,
              shippingCost: 10.0,
              discount: 25.0,
              currencySymbol: '\$',
            ),
            const SizedBox(height: 16),
            // Checkout Button
            CheckoutButton(
              total: 205.0,
              onCheckout: () {
                setState(() {
                  _checkoutPressed = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout pressed!')),
                );
              },
              currencySymbol: '\$',
            ),
            // ... existing code ...

            const SizedBox(height: 32),
            const Text(
              'Order History & Profile Widgets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Section Header Demo
            SectionHeader(
              title: 'Transactions',
              chipLabel: 'January 2024',
            ),
            const SizedBox(height: 16),

            // Order Transaction Cards
            OrderTransactionCard(
              imageUrl: 'https://picsum.photos/200/200?random=1',
              title: 'Old Mans',
              price: '\$25',
              discount: '50% Off',
              status: 'Delivered',
              statusColor: Color(0xFF2D9B88),
              filledStatus: true,
            ),
            OrderTransactionCard(
              imageUrl: 'https://picsum.photos/200/200?random=2',
              title: 'The Maid',
              price: '\$25',
              status: 'Order placed',
              statusColor: Colors.orange,
            ),
            OrderTransactionCard(
              imageUrl: 'https://picsum.photos/200/200?random=3',
              title: 'Village Look',
              price: '\$25',
              status: 'Payment confirmed',
              statusColor: Colors.blue,
            ),

            const SizedBox(height: 24),
            const Text(
              'Profile Section',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF2D9B88),
              child: const ProfileHeader(
                name: 'User Full Name',
                phone: '+1 9998887776',
                email: 'username@rku.ac.in',
              ),
            ),

            // Profile Menu Items
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    label: 'Edit Profile',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile tapped')),
                    ),
                  ),
                  ProfileMenuItem(
                    label: 'Language & Currency',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language & Currency tapped')),
                    ),
                  ),
                  ProfileMenuItem(
                    label: 'Feedback',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback tapped')),
                    ),
                  ),
                  ProfileMenuItem(
                    label: 'Refer a Friend',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refer a Friend tapped')),
                    ),
                  ),
                  ProfileMenuItem(
                    label: 'Terms & Conditions',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms & Conditions tapped')),
                    ),
                  ),
                  ProfileMenuItem(
                    label: 'Logout',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout tapped')),
                    ),
                    color: const Color(0xFF2D9B88),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Add Product Section',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Add Photo Box Row
            Row(
              children: [
                AddPhotoBox(
                  onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add photo tapped')),
                  ),
                ),
                const SizedBox(width: 12),
                AddPhotoBox(
                  imageUrl: 'https://picsum.photos/200/200?random=4',
                  onRemove: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Remove photo tapped')),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Product Price Row
            const ProductPriceRow(
              price: 30,
              offerPrice: 15,
            ),

            const SizedBox(height: 16),
            // Tag Chips
            Wrap(
              spacing: 8,
              children: [
                TagChip(
                  label: 'Cash on delivery',
                  onRemove: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Remove Cash on delivery')),
                  ),
                ),
                TagChip(
                  label: 'Available',
                  onRemove: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Remove Available')),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Store Section',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Store Header
            StoreHeader(
              name: 'User Name',
              onEdit: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Store tapped')),
              ),
              onView: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('View Store tapped')),
              ),
            ),

            const SizedBox(height: 24),
            // Empty State
            EmptyState(
              message: 'You don\'t have product',
              buttonText: 'Add Product',
              onButtonPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Product tapped')),
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              'Product Details Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ProductImageCarousel(
              imageUrls: [
                'https://picsum.photos/600/300?random=1',
                'https://picsum.photos/600/300?random=2',
                'https://picsum.photos/600/300?random=3',
              ],
              currentIndex: 0,
            ),
            const SizedBox(height: 16),
            Text('Old Mans', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            Row(
              children: [
                Text('\$25', style: TextStyle(color: Color(0xFF2D9B88), fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 8),
                Text('\$50', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 16)),
                const SizedBox(width: 8),
                TagChip(label: '50% off'),
              ],
            ),
            const SizedBox(height: 8),
            ArtistInfoRow(name: 'Darshan Raval', onFollow: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Follow tapped')),
            )),
            const SizedBox(height: 16),
            ProductDescription(description: 'Old Mans is a masterpiece by Darshan Raval. It captures the essence of a quiet village scene.'),
            const SizedBox(height: 16),
            ProductDetailsTable(details: {
              'Price': '\$25',
              'Category': 'Painting',
              'Artist': 'Darshan Raval',
              'Extra': '50% Off'
            }),
            // const SizedBox(height: 32),
            // const Text('Add Address Screen Demo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // AddAddressScreen(),

            // const SizedBox(height: 32),
            // const Text('My Store Screen Demo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // MyStoreScreen(),
          ],
        ),
        
      ),
    );
  }
}