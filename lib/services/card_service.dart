import 'package:cloud_firestore/cloud_firestore.dart';

class CardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a new card to the Firestore database.
  Future<void> addCard({
    required String cardNumber,
    required String name,
    required String expiryDate,
    required String cvc,
    required String userId,
    String? cardType,
    String? billingAddress,
    String? phoneNumber,
  }) async {
    try {
      final cardId = DateTime.now().millisecondsSinceEpoch.toString();
      final cardDetails = {
        'cardNumber': cardNumber,
        'name': name,
        'expiryDate': expiryDate,
        'cvc': cvc,
        'userId': userId,
        'cardType': cardType ?? 'Unknown',
        'billingAddress': billingAddress ?? 'Not provided',
        'phoneNumber': phoneNumber ?? 'Not provided',
      };
      await _firestore.collection('cards').doc(cardId).set(cardDetails);
    } catch (e) {
      print('Error saving card: $e');
      // Handle error appropriately, e.g., show a message to the user
    }
  }

  /// Retrieves all cards from the Firestore database.
  Future<List<Map<String, String>>> getAllCards() async {
    final querySnapshot = await _firestore.collection('cards').get();
    return querySnapshot.docs.map((doc) => doc.data().cast<String, String>()).toList();
  }

  /// Updates an existing card in the Firestore database.
  Future<void> updateCard(String cardId, Map<String, String> cardDetails) async {
    await _firestore.collection('cards').doc(cardId).update(cardDetails);
  }

  /// Deletes a card from the Firestore database.
  Future<void> deleteCard(String cardId) async {
    await _firestore.collection('cards').doc(cardId).delete();
  }

  /// Retrieves a card by its ID from the Firestore database.
  Future<Map<String, String>?> getCardById(String cardId) async {
    final doc = await _firestore.collection('cards').doc(cardId).get();
    return doc.exists ? doc.data()!.cast<String, String>() : null;
  }

  Future<List<Map<String, String>>> getCardsByUserId(String userId) async {
    final querySnapshot = await _firestore.collection('cards').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => doc.data().cast<String, String>()).toList();
  }

  Future<void> deleteAllCardsByUserId(String userId) async {
    final querySnapshot = await _firestore.collection('cards').where('userId', isEqualTo: userId).get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteAllCards() async {
    final querySnapshot = await _firestore.collection('cards').get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
