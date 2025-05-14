import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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
                'Orders Management',
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
                      DropdownMenuItem(value: 'All', child: Text('All Orders')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'Processing', child: Text('Processing')),
                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                    ],
                    onChanged: (value) {
                      // TODO: Implement filter
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement export orders
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: 10, // TODO: Replace with actual order count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(index),
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Order #${1000 + index}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: Customer ${index + 1}'),
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
                              value: 'edit',
                              child: Text('Edit Order'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Order'),
                            ),
                          ],
                          onSelected: (value) {
                            // TODO: Implement order actions
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

  Color _getStatusColor(int index) {
    final colors = [
      Colors.orange, // Pending
      Colors.blue, // Processing
      Colors.green, // Completed
      Colors.red, // Cancelled
    ];
    return colors[index % colors.length];
  }
} 