import 'dart:io';

void main() {
  final structure = {
    'lib/presentation/views': {
      'auth': [
        'login_screen.dart',
        'otp_verification_screen.dart',
        {
          'onboarding': [
            'onboarding_screen_1.dart',
            'onboarding_screen_2.dart',
            'onboarding_screen_3.dart'
          ]
        }
      ],
      'home': ['home_dashboard_screen.dart'],
      'product': [
        'browse_screen.dart',
        'add_product_screen.dart',
        'product_detail_screen.dart'
      ],
      'store': [
        'create_store_screen.dart',
        'my_store_screen.dart',
        'my_store_detail_screen.dart'
      ],
      'checkout': [
        'checkout_screen.dart',
        'checkout_step1_screen.dart',
        'checkout_step2_screen.dart',
        'checkout_step3_screen.dart',
        'checkout_success_screen.dart'
      ],
      'order': ['order_history_screen.dart'],
      'payment': ['add_card_screen.dart'],
      'splash': ['splash_screen.dart'],
    }
  };

  generateStructure(structure);
  print("✅ Folder and screen files created successfully.");
}

void generateStructure(Map<String, dynamic> structure, [String basePath = '']) {
  structure.forEach((key, value) {
    final path = basePath.isEmpty ? key : '$basePath/$key';
    final dir = Directory(path);
    dir.createSync(recursive: true);

    if (value is List) {
      for (var item in value) {
        if (item is String) {
          final file = File('$path/$item');
          file.createSync(recursive: true);
          file.writeAsStringSync(screenTemplate(item));
        } else if (item is Map<String, dynamic>) {
          generateStructure(item, path);
        }
      }
    } else if (value is Map<String, dynamic>) {
      generateStructure(value, path);
    }
  });
}

String screenTemplate(String fileName) {
  final className = fileName
      .replaceAll('_screen.dart', '')
      .split('_')
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join() +
      'Screen';

  return '''
import 'package:flutter/material.dart';

/// File: $fileName
/// TODO: Implement $className

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: const Center(
        child: Text('TODO: $className UI'),
      ),
    );
  }
}
''';
}
