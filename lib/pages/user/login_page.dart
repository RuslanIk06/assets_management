import 'dart:convert';

import 'package:assets_management/config/app_constant.dart';
import 'package:assets_management/pages/asset/home_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void login(BuildContext context) async {
    bool isValidate = formKey.currentState!.validate();

    if (isValidate) {
      Uri url = Uri.parse(
        '${AppConstant.baseUrl}/user/login.php',
      );

      http.post(url, body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      }).then((response) {
        DMethod.printResponse(response);
        Map resBody = jsonDecode(response.body);

        bool isSuccess = resBody['success'] ?? false;

        if (isSuccess) {
          DInfo.toastSuccess('Login Success');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          DInfo.toastError('Login Failed');
        }
      }).catchError((onError) {
        DInfo.toastError('Something Wrong');
        DMethod.printBasic(onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Assets Management",
                style: TextStyle(
                  color: Colors.purple[400],
                  fontFamily: 'DeliciousHandrawn',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius:
                      BorderRadius.circular(30), //border corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 5, // blur radius
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              fillColor: Colors.white38,
                              filled: true,
                              isDense: true,
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) =>
                                value == '' ? "Don't Empty" : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white38,
                              filled: true,
                              isDense: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) =>
                                value == '' ? "Don't Empty" : null,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              login(context);
                            },
                            icon: const Icon(
                              Icons.login_sharp,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
