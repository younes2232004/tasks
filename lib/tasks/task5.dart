// task5 login page

import 'package:flutter/material.dart';

class Task5 extends StatefulWidget {
  const Task5({super.key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  // ***************************************** this part is for the login page data and validation
  // email TextEditingController
  final TextEditingController _emailController = TextEditingController();
  // password TextEditingController
  final TextEditingController _passwordController = TextEditingController();
  // form key
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // padding -> single child scroll view -> form -> column -> [text form filed email , text form filed password ,  login button]
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // network image logo (url https://www.google.com/url?sa=i&url=https%3A%2F%2Ffreelogopng.com%2Forange-logo-png&psig=AOvVaw0CgNMykY8e5Bct9XNHa_e5&ust=1738913683845000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCODunLXErosDFQAAAAAdAAAAABAP)
                Image.network(
                  'https://1000logos.net/wp-content/uploads/2017/04/Orange-Logo.png',
                  height: 100,
                  width: 300,
                ),
                // sized box height 16
                SizedBox(
                  height: 16,
                ),
                // text form field email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.deepOrange,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                // sized box height 16
                SizedBox(
                  height: 16,
                ),
                // text form field password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.deepOrange,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                // sized box height 16
                SizedBox(
                  height: 16,
                ),
                // login button (Elivated Button , onpressed -> validate -> if valid -> show snackbar with login successfuly , else show snackbar with error)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login Successfuly'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error'),
                        ),
                      );
                    }
                  },
                  // button style -> backgroundColor deep orange and padding vertical 15 horizontal 30 radius 20
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.white,
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
