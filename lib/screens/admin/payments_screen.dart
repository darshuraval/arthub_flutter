import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payments Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  DropdownButton<String>(
                    value: 'All',
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Payments')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'Failed', child: Text('Failed')),
                    ],
                    onChanged: (value) {
                      // TODO: Implement filter
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement export payments
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: 10, // TODO: Replace with actual payment count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPaymentStatusColor(index),
                      child: Icon(
                        _getPaymentMethodIcon(index),
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Payment #${2000 + index}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #${1000 + index}'),
                        Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          '\$${(index + 1) * 50}.00',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem(
                              value: 'refund',
                              child: Text('Refund'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                            // TODO: Implement payment actions
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(int index) {
    final colors = [
      Colors.orange, // Pending
      Colors.green, // Completed
      Colors.red, // Failed
    ];
    return colors[index % colors.length];
  }

  IconData _getPaymentMethodIcon(int index) {
    final icons = [
      Icons.credit_card, // Credit Card
      Icons.account_balance, // Bank Transfer
      Icons.payment, // Other
    ];
    return icons[index % icons.length];
  }
} 