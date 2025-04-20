import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/models/payment_model.dart';

class CheckoutProvider extends ChangeNotifier {
  List<AddressModel> _addresses = [];
  List<PaymentModel> _paymentMethods = [];
  AddressModel? _selectedShippingAddress;
  AddressModel? _selectedBillingAddress;
  PaymentModel? _selectedPaymentMethod;

  List<AddressModel> get addresses => _addresses;
  List<PaymentModel> get paymentMethods => _paymentMethods;
  AddressModel? get selectedShippingAddress => _selectedShippingAddress;
  AddressModel? get selectedBillingAddress => _selectedBillingAddress;
  PaymentModel? get selectedPaymentMethod => _selectedPaymentMethod;

  bool get hasAddresses => _addresses.isNotEmpty;
  bool get hasPaymentMethods => _paymentMethods.isNotEmpty;

  Future<void> loadAddresses() async {
    // TODO: Load from storage/backend
    notifyListeners();
  }

  Future<void> loadPaymentMethods() async {
    // TODO: Load from storage/backend
    notifyListeners();
  }

  Future<void> addAddress(AddressModel address) async {
    _addresses.add(address);
    if (address.isDefault) {
      // If this is default, update other addresses
      _addresses = _addresses.map((addr) {
        if (addr.id != address.id) {
          return addr.copyWith(isDefault: false);
        }
        return addr;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> updateAddress(AddressModel address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      if (address.isDefault) {
        // If this is default, update other addresses
        _addresses = _addresses.map((addr) {
          if (addr.id != address.id) {
            return addr.copyWith(isDefault: false);
          }
          return addr;
        }).toList();
      }
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String id) async {
    _addresses.removeWhere((address) => address.id == id);
    notifyListeners();
  }

  Future<void> addPaymentMethod(PaymentModel payment) async {
    _paymentMethods.add(payment);
    if (payment.isDefault) {
      // If this is default, update other payment methods
      _paymentMethods = _paymentMethods.map((pm) {
        if (pm.id != payment.id) {
          return pm.copyWith(isDefault: false);
        }
        return pm;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> updatePaymentMethod(PaymentModel payment) async {
    final index = _paymentMethods.indexWhere((p) => p.id == payment.id);
    if (index != -1) {
      _paymentMethods[index] = payment;
      if (payment.isDefault) {
        // If this is default, update other payment methods
        _paymentMethods = _paymentMethods.map((pm) {
          if (pm.id != payment.id) {
            return pm.copyWith(isDefault: false);
          }
          return pm;
        }).toList();
      }
      notifyListeners();
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    _paymentMethods.removeWhere((payment) => payment.id == id);
    notifyListeners();
  }

  void selectShippingAddress(AddressModel address) {
    _selectedShippingAddress = address;
    notifyListeners();
  }

  void selectBillingAddress(AddressModel address) {
    _selectedBillingAddress = address;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentModel payment) {
    _selectedPaymentMethod = payment;
    notifyListeners();
  }
} 