import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
            top: width * -.2,
            left: width * -.18,
            child: Container(
              margin: EdgeInsets.only(
                top: width * .30,
                left: width * .27,
              ),
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
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(top: 160, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .2),
                          blurRadius: 20.0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Color.fromRGBO(148, 153, 162, 1),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromRGBO(148, 153, 162, 1),
                          ),
                          hintText: 'Username or email',
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(148, 153, 162, 1),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .2),
                          blurRadius: 20.0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Color.fromRGBO(148, 153, 162, 1),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromRGBO(148, 153, 162, 1),
                          ),
                          suffixIcon: Icon(
                            Icons.visibility,
                            color: Color.fromRGBO(148, 153, 162, 1),
                          ),
                          hintText: 'Password',
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(148, 153, 162, 1),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width * .5),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Color.fromRGBO(148, 153, 162, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    width: 120,
                    child: Center(
                        child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Color.fromRGBO(148, 153, 162, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .2),
                          blurRadius: 20.0,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    'Sign In With',
                    style: TextStyle(
                        color: Color.fromRGBO(103, 103, 103, 1), fontSize: 12),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 50),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin();
                        },
                        child: Container(
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(7.3),
                              child: Image(
                                image: AssetImage('images/google.png'),
                              ),
                            ),
                            backgroundColor: Color.fromRGBO(38, 38, 38, 1),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(7.2),
                              child: Image(
                                image: AssetImage('images/apple.png'),
                              ),
                            ),
                            backgroundColor: Color.fromRGBO(38, 38, 38, 1),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(7.2),
                              child: Image(
                                image: AssetImage('images/facebook.png'),
                              ),
                            ),
                            backgroundColor: Color.fromRGBO(38, 38, 38, 1),
                          ),
                        ),
                      )),
                      SizedBox(width: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
