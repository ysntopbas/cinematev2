import 'package:cinematev2/widgets/text_field_widget.dart';
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
            TextFieldWidget(
                hintText: "E-posta", keyboardType: TextInputType.emailAddress),
            TextFieldWidget(
                hintText: "Şifre",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword),
            TextFieldWidget(
                hintText: "Şifre Tekrar",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword),
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
