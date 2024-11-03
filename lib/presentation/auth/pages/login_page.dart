import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/button/basic_app_button.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obsecurePassword = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
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
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 40,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppVectors.logo,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Log in',
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
                              recognizer: TapGestureRecognizer()..onTap = () {})
                        ]),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  _usernameEmailField(context, _username),
                  const SizedBox(height: 16),
                  _passwordField(context, _password),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: 'Forgot password?',
                          style: AppTextStyle.caption1.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BasicAppButton(
                    onPressed: () {
                      // print(_usernam.text);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) =>
                      //         const ChooseGenre(),
                      //   ),
                      // );

                      // test
                      // String un = _username.text;
                      // String pw = _password.text;
                      // print('Username/email: $un');
                      // print('password: $pw');
                      context.go('/choose-genre');
                    },
                    title: 'Log In',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t Have An Account? ',
                          style: AppTextStyle.caption1,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Register',
                                style: AppTextStyle.caption1.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  color: AppColors.secondary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go('/register');
                                  })
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _usernameEmailField(
      BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: const InputDecoration(hintText: 'Enter Username Or Email')
          .applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      controller: controller,
    );
  }

  Widget _passwordField(
      BuildContext context, TextEditingController controller) {
    return TextField(
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
        // contentPadding: const EdgeInsets.all(30)
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      controller: controller,
      obscureText: _obsecurePassword,
    );
  }
}
