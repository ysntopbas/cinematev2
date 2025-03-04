import 'package:cinematev2/providers/auth_provider.dart';
import 'package:cinematev2/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            TextFieldWidget(
                contr: _emailController,
                hintText: "E-posta",
                keyboardType: TextInputType.emailAddress),
            TextFieldWidget(
                contr: _passwordController,
                hintText: "Şifre",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword),
            FilledButton(
              onPressed: () async {
                context
                    .read<AuthProvider>()
                    .login(_emailController.text, _passwordController.text);

                if (context.read<AuthProvider>().isAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Giriş yapılıyor...'),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bok'),
                    ),
                  );
                }
              },
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
