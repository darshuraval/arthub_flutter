import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import 'package:arthub_flutter/models/order_model.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CheckoutProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, provider, child) {
          if (!provider.hasOrders) {
            return const Center(
              child: Text('No orders found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ordered on ${DateFormat('MMM dd, yyyy').format(order.createdAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.quantity}x Product #${item.productId}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
      case OrderStatus.confirmed:
        color = Colors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 