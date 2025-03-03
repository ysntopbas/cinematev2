import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CineMate',
                style: GoogleFonts.fleurDeLeah(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                )),
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
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Şifre Tekrar', border: OutlineInputBorder()),
            ),
            FilledButton(
              onPressed: () {},
              child: Text('Kayıt Ol'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text('Hesabınız var mı? Giriş yapın')),
          ],
        ),
      ),
    );
  }
}
