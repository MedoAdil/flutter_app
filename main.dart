import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/SignUp.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/theme.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
         useMaterial3: true,
         colorScheme: MaterialTheme.lightScheme(),
      ),
      home: MyHomePage(title: 'Humanitarian Response App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red, 
        title: Text(title),
        leading: Icon(Icons.icecream_outlined),
      ),
body: Padding(
  padding: EdgeInsets.all(20.0),
  child: Column(
    children: <Widget> [
      Container(
        width: 200,
        height: 200,
        child: Image(
          image:
          AssetImage('images/human.png'))
      ), 
      Padding(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email Address",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Padding( 
          padding: EdgeInsets.all(8),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,), 
            child: Container(
              padding: EdgeInsets.all(20),
              child:
           Text("Login",
            style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),),),
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(
                        builder: (context) => home(),));
          },
        )
      ),
      )
      ),
      Padding(
        padding:EdgeInsets.all(10.0),
        child: RichText(
          text: TextSpan(
            text: 'Dont have an account?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15),
                  recognizer: TapGestureRecognizer()
                  ..onTap = (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MyForm(),));
                  }
              )
            ]
          )
          ),
         )
    ],
    )
)
);
  }
}