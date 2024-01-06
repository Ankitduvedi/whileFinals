import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:while_app/resources/colors.dart';
import 'package:while_app/resources/components/header_widget.dart';
import 'package:while_app/resources/components/password_container_widget.dart';
import 'package:while_app/resources/components/round_button.dart';
import 'package:while_app/resources/components/text_container_widget.dart';
import 'package:while_app/utils/utils.dart';
import 'package:while_app/view/auth/login_screen.dart';
import '../../repository/firebase_repository.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.theme1Color, AppColors.buttonColor],
              ),
            ),
          ),
          Container(
            height: h / 1.2,
            width: w,
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  offset: const Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeaderWidget(title: 'Register'),
                    Container(
                      height: h / 6,
                      width: w / 1.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/while_transparent.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextContainerWidget(
                      color: Colors.white,
                      controller: _nameController,
                      prefixIcon: Icons.person,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 10),
                    TextContainerWidget(
                      color: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      prefixIcon: Icons.email,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 10),
                    TextPasswordContainerWidget(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                      hintText: 'Password',
                    ),
                    SizedBox(
                      height: h * 0.045,
                    ),
                    RoundButton(
                      loading: false,
                      title: 'SignUp',
                      onPress: () {
                        if (_emailController.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              'Please enter email', context);
                        } else if (_passwordController.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              'Please enter password', context);
                        } else if (_passwordController.text.length < 6) {
                          Utils.flushBarErrorMessage(
                              'Please enter at least 6-digit password',
                              context);
                        } else {
                          context
                              .read<FirebaseAuthMethods>()
                              .signInWithEmailAndPassword(
                                _emailController.text.toString(),
                                _passwordController.text.toString(),
                                _nameController.text.toString(),
                                context,
                              );
                          // Navigator.of(context).pop();
                          Utils.toastMessage('Response submitted');
                        }
                      },
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: h * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                            // Navigator.of(context).pop();
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                color: AppColors.theme1Color,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
