import 'package:flutter/material.dart';

class AiAdvicePage extends StatelessWidget {
  const AiAdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinemate Önerileri'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/robot.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'Cinemate AI Önerileri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cinemate AI, izleme geçmişinize ve tercihlerine göre önerilerde bulunur.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                // Öneri almak için gerekli işlemleri yapın
              },
              child: const Text('Öneri Al'),
            ),
          ],
        ),
      ),
    );
  }
}
