import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/resources/auth_methods.dart';
import 'package:news/responsive/mobile_screen_layout.dart';
import 'package:news/responsive/responsive_layout.dart';
import 'package:news/responsive/web_screen_layout.dart';
import 'package:news/screens/signup_screen.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/widgets/textfield_input.dart';
import 'package:news/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(), 
                  mobileScreenLayout: MobileScreenLayout()
          )
        )
      );
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize ?
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3)
          :
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,15,0),
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  color: textColor,
                  height: 72,
                ),
              ),
              const SizedBox(height: 48),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: secondaryColor),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: textColor,
                        ))
                      : const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Not yet registered? '),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text('Sign up.',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  )
                ],
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
