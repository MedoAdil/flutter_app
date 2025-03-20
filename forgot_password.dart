import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  String? errorMessage;
  String? successMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background to white
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black), // Set text color to black
        ),
        backgroundColor: Colors.white, // Set AppBar background to white
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: Colors.black), // Set back icon color to black
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white, // Set Container background to white
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Enter your email to reset your password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set text color to black
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter your email";
                        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail, color: Colors.black), // Set icon color to black
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.black), // Set label text color to black
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black), // Set border color to black
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black), // Set enabled border color to black
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black), // Set focused border color to black
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.primary,
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () => _resetPassword(emailController.text),
                        child: Text(
                          "Reset Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    if (successMessage != null)
                      Text(
                        successMessage!,
                        style: TextStyle(color: Colors.green),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword(String email) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        setState(() {
          successMessage = "Password reset email sent. Check your inbox.";
          errorMessage = null;
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          errorMessage = error.message;
          successMessage = null;
        });
      }
    }
  }
}