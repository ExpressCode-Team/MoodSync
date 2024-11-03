import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/button/basic_app_button.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                AppVectors.wave,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Transform.rotate(
                angle: 3.14,
                child: SvgPicture.asset(
                  AppVectors.wave,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 40,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppVectors.logo,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.title1,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'If You Need Any Support ',
                            style: AppTextStyle.caption2,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Click Here',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {})
                            ]),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      _fullNameField(context, _username),
                      const SizedBox(height: 16),
                      _emailField(context, _email),
                      const SizedBox(height: 16),
                      _passwordField(context, _password),
                      const SizedBox(height: 16),
                      _confirmPasswordField(context, _confirmPassword),
                      const SizedBox(height: 16),
                      BasicAppButton(
                        onPressed: () {
                          // String un = _username.text;
                          // String em = _email.text;
                          // String pw = _password.text;
                          // String cpw = _confirmPassword.text;

                          // print('fullname: $un');
                          // print('email: $em');
                          // print('password: $pw');
                          // print('confirm password: $cpw');
                        },
                        title: 'Register',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                              text: 'Have An Account? ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Log in',
                                    style: AppTextStyle.caption1.copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      color: AppColors.secondary,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.go('/signin');
                                      })
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _fullNameField(
      BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Full Name').applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _emailField(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Enter Email').applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(
      BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obsecurePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 20),
          child: IconButton(
              onPressed: () {
                setState(() {
                  _obsecurePassword = !_obsecurePassword;
                });
              },
              icon: Icon(
                _obsecurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              )),
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _confirmPasswordField(
      BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obsecureConfirmPassword,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 20),
          child: IconButton(
              onPressed: () {
                setState(() {
                  _obsecureConfirmPassword = !_obsecureConfirmPassword;
                });
              },
              icon: Icon(
                _obsecureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              )),
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }
}
