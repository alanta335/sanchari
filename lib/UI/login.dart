import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = '';
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 70,
            bottom: 0,
            child: SvgPicture.asset('images/san1.svg'),
          ),
          Positioned(
            top: height * .33,
            left: 30,
            child: Container(
              child: Text(
                'Welcome \nBack!',
                style: TextStyle(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: width * .08,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: GestureDetector(
            onTap: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .05),
                      blurRadius: 10.0,
                      spreadRadius: 5)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              width: width * 0.87,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 30,
                        width: 30,
                        child: Image(
                          image: AssetImage('images/google.png'),
                          fit: BoxFit.fill,
                        )),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Sign up with Google',
                      style: TextStyle(
                          fontFamily: 'Poppins', color: Colors.grey.shade700),
                    )
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
