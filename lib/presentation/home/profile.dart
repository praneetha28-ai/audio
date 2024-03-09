import 'package:audio/bloc/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/prod/prod_bloc.dart';
import '../auth/signin.dart';

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is UnAuthenticated){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignIn()),
                (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return PopScope(
            onPopInvoked: (val){
              if(val){
                BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent("earpods"));
              }
            },
            canPop: true,
            child: Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: (){
                    BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent("earpods"));
                    Navigator.of(context).pop();

                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                title: const Text('Profile'),
                centerTitle: true,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: user!.photoURL != null
                              ? ClipOval(
                                child: Image.network(
                                                            user.photoURL!,
                                                            fit: BoxFit.cover,
                                                          ),
                              )
                              : Container(
                            child: Text("${user.email![0]}"),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(user.email!),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'General',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Wishlist',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Legal',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Text(
                      'Terms of Use',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Personal',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Text(
                      'Report a Bug',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                    },
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
