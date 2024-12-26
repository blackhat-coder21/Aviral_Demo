import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Api.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? username;
  String? password;
  bool loading = false;
  bool toggle = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleLogin() async {
    setState(() {
      loading = true;
    });

    final res = await logUser(username: username, password: password);
    setState(() {
      loading = false;
    });

    if (res.data['user_group'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong Credentials')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('creds', '{"username": "$username", "password": "$password"}');

    Navigator.pushReplacementNamed(context, '/aviral', arguments: {
      'jwt_token': res!.data['jwt_token'],
      'session': res!.data['session_id'],
    });
  }

  void handleToggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LDAP Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F378B),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (text) => setState(() {
                    username = text;
                  }),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    suffixIcon: IconButton(
                      icon: Icon(toggle ? Icons.visibility : Icons.visibility_off),
                      onPressed: handleToggle,
                    ),
                  ),
                  obscureText: !toggle,
                  onChanged: (text) => setState(() {
                    password = text;
                  }),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F378B),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
