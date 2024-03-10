import 'package:flutter/material.dart';

import '../animation_header.dart/animation_header_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('Animation header'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnimationHeaderPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
