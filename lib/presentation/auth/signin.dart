import 'package:audio/presentation/auth/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../home/dashboard.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Dashboard()));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is Loading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(state is UnAuthenticated) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration:const BoxDecoration(
                    image: DecorationImage(
                      opacity: 1,
                      colorFilter: ColorFilter.mode(Colors.green, BlendMode.darken),
                      image: AssetImage("assets/bg.png"),
                      fit: BoxFit.cover
                    )
                  ),
                  // margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5.5),
                          child: Text("Audio",style: TextStyle(color: Colors.white,fontSize: 51,),)
                      ),
                      Container(child: Text("It's modular and designed to last",style: TextStyle(color: Colors.white))),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8,right: 8,bottom: 8,
                                  top: MediaQuery.of(context).size.height/4
                              ),

                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16)
                                    )
                                  ),
                                )
                            ),
                            Container(
                                margin: EdgeInsets.all(8),
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16)
                                      )
                                  ),
                                )
                            ),

                          ],
                        ),
                      ),
                      Text("Forgot Password",style: TextStyle(color: Colors.white)),
                      Container(
                        width: MediaQuery.of(context).size.width*1,
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          height: 55,
                          child: ElevatedButton(
                              onPressed: (){
                                _authenticateWithEmailAndPassword(context);

                              }, child: Text("Sign in",style: TextStyle(color: Colors.white,fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: TextStyle(color: Colors.white)),
                          TextButton(onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
                          },
                              child: Text("Sign Up",style: TextStyle(
                                  color: Colors.green,fontWeight: FontWeight.w600,fontSize: 16),)
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
