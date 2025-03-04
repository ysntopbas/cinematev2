import 'package:cinematev2/providers/auth_provider.dart';
import 'package:cinematev2/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                contr: _emailController,
                hintText: "E-posta",
                keyboardType: TextInputType.emailAddress),
            TextFieldWidget(
                contr: _passwordController,
                hintText: "Şifre",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword),
            TextFieldWidget(
                hintText: "Şifre Tekrar",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword),
            FilledButton(
              onPressed: () {
                context.read<AuthProvider>().register(
                      _emailController.text,
                      _passwordController.text,
                    );
                context.read<AuthProvider>().isAuthenticated
                    ? Navigator.pushNamed(context, '/')
                    : null;
              },
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
