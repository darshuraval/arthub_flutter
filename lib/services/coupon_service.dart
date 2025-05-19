import 'package:cloud_firestore/cloud_firestore.dart';

class CouponService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new coupon
  Future<void> createCoupon({
    required String couponCode,
    required String couponType,
    required double discount,
    String? userId,
  }) async {
    if (couponType != 'percent' && couponType != 'amount') {
      throw Exception('Invalid coupon type. Only "percent" or "amount" is allowed.');
    }

    final couponId = DateTime.now().millisecondsSinceEpoch.toString();
    final coupon = {
      'couponId': couponId,
      'couponCode': couponCode,
      'couponType': couponType,
      'discount': discount,
      'userId': userId,
      'created_at': DateTime.now().toIso8601String(),
    };
    await _firestore.collection('coupons').doc(couponId).set(coupon);
  }

  // Retrieve a coupon by code
  Future<Map<String, dynamic>?> getCouponByCode(String couponCode) async {
    final querySnapshot = await _firestore.collection('coupons').where('couponCode', isEqualTo: couponCode).limit(1).get();
    if (querySnapshot.docs.isEmpty) return null;
    return querySnapshot.docs.first.data();
  }

  // Retrieve all coupons
  Future<List<Map<String, dynamic>>> getAllCoupons() async {
    final querySnapshot = await _firestore.collection('coupons').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update a coupon
  Future<void> updateCoupon(String couponId, Map<String, dynamic> updates) async {
    if (updates.containsKey('couponType') && (updates['couponType'] != 'percent' && updates['couponType'] != 'amount')) {
      throw Exception('Invalid coupon type. Only "percent" or "amount" is allowed.');
    }

    await _firestore.collection('coupons').doc(couponId).update(updates);
  }

  // Delete a coupon
  Future<void> deleteCoupon(String couponId) async {
    await _firestore.collection('coupons').doc(couponId).delete();
  }

  // Apply a coupon to calculate discount
  Future<double> applyCoupon(String couponCode, double totalAmount) async {
    final coupon = await getCouponByCode(couponCode);
    if (coupon == null) {
      throw Exception('Invalid coupon code');
    }

    if (coupon['couponType'] != 'percent' && coupon['couponType'] != 'amount') {
      throw Exception('Invalid coupon type. Only "percent" or "amount" is allowed.');
    }

    double discount = 0.0;
    if (coupon['couponType'] == 'percent') {
      discount = totalAmount * (coupon['discount'] / 100);
    } else if (coupon['couponType'] == 'amount') {
      discount = coupon['discount'];
    }

    return discount;
  }
}
