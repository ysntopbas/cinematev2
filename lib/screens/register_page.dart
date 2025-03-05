import 'package:cinematev2/core/validation_helper.dart';
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
  late final TextEditingController _passwordControllerConfirm;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordControllerConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordControllerConfirm.dispose();
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
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFieldWidget(
                  validator: ValidationHelper.isEmailValid,
                  contr: _emailController,
                  hintText: "E-posta",
                  keyboardType: TextInputType.emailAddress),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFieldWidget(
                  validator: ValidationHelper.isPasswordValid,
                  contr: _passwordController,
                  hintText: "Şifre",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFieldWidget(
                  contr: _passwordControllerConfirm,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Şifreler uyuşmuyor';
                    }
                    return null;
                  },
                  hintText: "Şifre Tekrar",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword),
            ),
            FilledButton(
              onPressed: () {
                context.read<AuthProvider>().register(
                      _emailController.text,
                      _passwordController.text,
                    );
              },
              child: Text('Kayıt Ol'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('Hesabınız var mı? Giriş yapın')),
          ],
        ),
      ),
    );
  }
}
