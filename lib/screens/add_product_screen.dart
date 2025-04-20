import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/category_card.dart';
import '../widgets/image_upload_box.dart';
import '../widgets/payment_option_tile.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  int selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Art Product',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Images',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ImageUploadBox(
                          onTap: () {},
                          resolution: '1600 x 1200',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const CustomTextField(
                  label: 'Product Name',
                  hint: 'Enter product name',
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Category : ${selectedCategory ?? "None"}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryCard(
                        title: 'Culture',
                        imageUrl: 'https://example.com/culture.jpg',
                        onTap: () => setState(() => selectedCategory = 'Culture'),
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 12),
                      CategoryCard(
                        title: 'Folk',
                        imageUrl: 'https://example.com/folk.jpg',
                        onTap: () => setState(() => selectedCategory = 'Folk'),
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 12),
                      CategoryCard(
                        title: 'Modern',
                        imageUrl: 'https://example.com/modern.jpg',
                        onTap: () => setState(() => selectedCategory = 'Modern'),
                        width: 120,
                        height: 120,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Price (\$)',
                        hint: 'Enter price',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Offer Price (\$)',
                        hint: 'Enter offer price',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                PaymentOptionTile(
                  title: 'Bank Transfer',
                  isSelected: selectedPaymentMethod == 0,
                  onTap: () => setState(() => selectedPaymentMethod = 0),
                  icon: Icons.money,
                ),
                PaymentOptionTile(
                  title: 'Credit/Debit Card',
                  isSelected: selectedPaymentMethod == 1,
                  onTap: () => setState(() => selectedPaymentMethod = 1),
                  icon: Icons.credit_card,
                ),
                PaymentOptionTile(
                  title: 'Cash on Delivery',
                  isSelected: selectedPaymentMethod == 2,
                  onTap: () => setState(() => selectedPaymentMethod = 2),
                  icon: Icons.money,
                ),
                const SizedBox(height: 24),
                const CustomTextField(
                  label: 'Description',
                  hint: 'Enter product description',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Add Product',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 