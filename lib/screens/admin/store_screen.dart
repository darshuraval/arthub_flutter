import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Store Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStoreCard(
                  context,
                  'Store Information',
                  Icons.store,
                  [
                    _buildInfoRow('Store Name', 'My Store'),
                    _buildInfoRow('Address', '123 Main St'),
                    _buildInfoRow('Phone', '+1 234 567 890'),
                    _buildInfoRow('Email', 'store@example.com'),
                  ],
                ),
                _buildStoreCard(
                  context,
                  'Business Hours',
                  Icons.access_time,
                  [
                    _buildInfoRow('Monday-Friday', '9:00 AM - 6:00 PM'),
                    _buildInfoRow('Saturday', '10:00 AM - 4:00 PM'),
                    _buildInfoRow('Sunday', 'Closed'),
                  ],
                ),
                _buildStoreCard(
                  context,
                  'Store Statistics',
                  Icons.analytics,
                  [
                    _buildInfoRow('Total Products', '150'),
                    _buildInfoRow('Total Orders', '1,234'),
                    _buildInfoRow('Total Revenue', '\$45,678'),
                  ],
                ),
                _buildStoreCard(
                  context,
                  'Store Settings',
                  Icons.settings,
                  [
                    _buildInfoRow('Currency', 'USD'),
                    _buildInfoRow('Tax Rate', '8.5%'),
                    _buildInfoRow('Shipping', 'Free over \$50'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> infoRows,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...infoRows,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 