import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/resources/auth_methods.dart';
import 'package:news/responsive/mobile_screen_layout.dart';
import 'package:news/responsive/responsive_layout.dart';
import 'package:news/responsive/web_screen_layout.dart';
import 'package:news/screens/login_screen.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/utils/utils.dart';
import 'package:news/widgets/textfield_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    
    if(_image == null){
      final ByteData bytes = await rootBundle.load('assets/defaultUserIcon.jpg');
      _image = bytes.buffer.asUint8List();
    }

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(), 
                  mobileScreenLayout: MobileScreenLayout()
          )
        )
      );
    }
  }

  void navigateTologIn() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
              const SizedBox(height: 32),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png'),
                        ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo,
                            color: secondaryColor),
                      ))
                ],
              ),
              const SizedBox(height: 32),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Username',
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
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
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: secondaryColor),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(
                        color: textColor,
                      ))
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Already registered? '),
                  ),
                  GestureDetector(
                    onTap: navigateTologIn,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text('Log in.',
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
