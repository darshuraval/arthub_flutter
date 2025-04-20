import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/models/payment_model.dart';
import 'package:arthub_flutter/models/order_model.dart';
import 'package:arthub_flutter/utils/sample_data.dart';

class CheckoutProvider extends ChangeNotifier {
  List<PaymentModel> _paymentMethods = [];
  List<AddressModel> _addresses = [];
  List<OrderModel> _orders = [];
  PaymentModel? _selectedPaymentMethod;
  AddressModel? _selectedShippingAddress;
  AddressModel? _selectedBillingAddress;

  CheckoutProvider() {
    loadPaymentMethods();
    loadAddresses();
    loadOrders();
  }

  List<PaymentModel> get paymentMethods => _paymentMethods;
  List<AddressModel> get addresses => _addresses;
  List<OrderModel> get orders => _orders;
  PaymentModel? get selectedPaymentMethod => _selectedPaymentMethod;
  AddressModel? get selectedShippingAddress => _selectedShippingAddress;
  AddressModel? get selectedBillingAddress => _selectedBillingAddress;

  bool get hasAddresses => _addresses.isNotEmpty;
  bool get hasPaymentMethods => _paymentMethods.isNotEmpty;
  bool get hasOrders => _orders.isNotEmpty;

  void loadPaymentMethods() {
    _paymentMethods = SampleData.samplePaymentMethods;
    _selectedPaymentMethod = _paymentMethods.firstWhere((pm) => pm.isDefault);
    notifyListeners();
  }

  void loadAddresses() {
    _addresses = SampleData.sampleAddresses;
    _selectedShippingAddress = _addresses.firstWhere((addr) => addr.isDefault);
    _selectedBillingAddress = _selectedShippingAddress;
    notifyListeners();
  }

  void loadOrders() {
    _orders = SampleData.sampleOrders;
    notifyListeners();
  }

  void setDefaultPaymentMethod(PaymentModel payment) {
    _paymentMethods = _paymentMethods.map((pm) {
      if (pm.id != payment.id) {
        return pm.copyWith(isDefault: false);
      }
      return payment.copyWith(isDefault: true);
    }).toList();
    _selectedPaymentMethod = payment.copyWith(isDefault: true);
    notifyListeners();
  }

  Future<void> addPaymentMethod(PaymentModel payment) async {
    final index = _paymentMethods.indexWhere((p) => p.id == payment.id);
    if (index != -1) {
      _paymentMethods[index] = payment;
    } else {
      _paymentMethods.add(payment);
    }
    if (payment.isDefault) {
      _paymentMethods = _paymentMethods.map((pm) {
        if (pm.id != payment.id) {
          return pm.copyWith(isDefault: false);
        }
        return payment;
      }).toList();
      _selectedPaymentMethod = payment;
    }
    notifyListeners();
  }

  Future<void> updatePaymentMethod(PaymentModel payment) async {
    final index = _paymentMethods.indexWhere((p) => p.id == payment.id);
    if (index != -1) {
      _paymentMethods[index] = payment;
      if (payment.isDefault) {
        _paymentMethods = _paymentMethods.map((pm) {
          if (pm.id != payment.id) {
            return pm.copyWith(isDefault: false);
          }
          return payment;
        }).toList();
        _selectedPaymentMethod = payment;
      }
      notifyListeners();
    }
  }

  void removePaymentMethod(String id) {
    _paymentMethods.removeWhere((payment) => payment.id == id);
    if (_selectedPaymentMethod?.id == id) {
      _selectedPaymentMethod = _paymentMethods.firstWhere(
        (pm) => pm.isDefault,
        orElse: () => _paymentMethods.first,
      );
    }
    notifyListeners();
  }

  void setDefaultShippingAddress(AddressModel address) {
    _addresses = _addresses.map((addr) {
      if (addr.id != address.id) {
        return addr.copyWith(isDefault: false);
      }
      return addr.copyWith(isDefault: true);
    }).toList();
    _selectedShippingAddress = address.copyWith(isDefault: true);
    notifyListeners();
  }

  void setDefaultBillingAddress(AddressModel address) {
    _addresses = _addresses.map((addr) {
      if (addr.id != address.id) {
        return addr.copyWith(isDefault: false);
      }
      return addr.copyWith(isDefault: true);
    }).toList();
    _selectedBillingAddress = address.copyWith(isDefault: true);
    notifyListeners();
  }

  Future<void> addAddress(AddressModel address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
    } else {
      _addresses.add(address);
    }
    if (address.isDefault) {
      _addresses = _addresses.map((addr) {
        if (addr.id != address.id) {
          return addr.copyWith(isDefault: false);
        }
        return address;
      }).toList();
      _selectedShippingAddress = address;
      _selectedBillingAddress = address;
    }
    notifyListeners();
  }

  Future<void> updateAddress(AddressModel address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      if (address.isDefault) {
        _addresses = _addresses.map((addr) {
          if (addr.id != address.id) {
            return addr.copyWith(isDefault: false);
          }
          return address;
        }).toList();
        _selectedShippingAddress = address;
        _selectedBillingAddress = address;
      }
      notifyListeners();
    }
  }

  void removeAddress(String id) {
    _addresses.removeWhere((address) => address.id == id);
    if (_selectedShippingAddress?.id == id) {
      _selectedShippingAddress = _addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => _addresses.first,
      );
    }
    if (_selectedBillingAddress?.id == id) {
      _selectedBillingAddress = _addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => _addresses.first,
      );
    }
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