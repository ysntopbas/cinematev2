import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CineMate',
              style: GoogleFonts.fleurDeLeah(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'E-posta', border: OutlineInputBorder()),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Şifre', border: OutlineInputBorder()),
            ),
            FilledButton(
              onPressed: () {},
              child: Text('Giriş Yap'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Hesabınız yok mu? Kayıt olun')),
          ],
        ),
      ),
    );
  }
}
