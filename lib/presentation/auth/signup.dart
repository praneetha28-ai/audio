import 'package:audio/presentation/auth/signin.dart';
import 'package:audio/presentation/home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_emailController.text, _passwordController.text),
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
                      Form(
                          key: _formKey,
                        child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5.5),
                              child: Text("Audio",style: TextStyle(color: Colors.white,fontSize: 51,),)
                          ),
                          Container(child: Text("It's modular and designed to last",style: TextStyle(color: Colors.white))),
                          Container(
                              margin: EdgeInsets.only(left: 8,right: 8,bottom: 8,
                                  top: MediaQuery.of(context).size.height/5.5
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
                          Container(
                              width: MediaQuery.of(context).size.width*1,
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              height: 55,
                              child: ElevatedButton(

                                onPressed: (){
                                  _authenticateWithEmailAndPassword(context);
                                }, child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                              )
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 50,
                                  height: 50,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white
                                  ),
                                  child: Icon(Icons.apple,size: 45,),
                              ),Container(
                                margin: EdgeInsets.all(8),
                                width: 50,
                                  height: 50,

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white
                                ),

                                  child: Icon(Icons.facebook,color: Colors.blueAccent,size: 45,),
                              ),
                              GestureDetector(
                                onTap: (){
                                  _authenticateWithGoogle(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: 50,
                                    height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white
                                  ),

                                    child: ClipOval(
                                        child: Image.asset("assets/google.png",
                                          width: 2,height: 2,scale: 0.2,)),

                                ),
                              ),

                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("If you have an account?",style: TextStyle(color: Colors.white)),
                              TextButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignIn()));
                              },
                                  child: Text("Sign In",style: TextStyle(color: Colors.green,fontSize: 20),)
                              )
                            ],
                          )
                        ],
                  )
                      ),
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
