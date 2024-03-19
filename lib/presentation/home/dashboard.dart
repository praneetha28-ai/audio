import 'package:audio/bloc/auth/auth_bloc.dart';
import 'package:audio/presentation/auth/signin.dart';
import 'package:audio/presentation/home/products.dart';
import 'package:audio/presentation/home/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/prod/prod_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  Future<void> checkAndCreateField() async {
    // Reference to your Firestore collection and document
    final user = FirebaseAuth.instance.currentUser;
    final CollectionReference collection = FirebaseFirestore.instance.collection('users');
    final DocumentReference document = collection.doc(user!.uid);

    try {
      // Get the document snapshot
      DocumentSnapshot snapshot = await document.get();

      // Check if the field exists
      if (!snapshot.exists || !(snapshot.data() as Map<String, dynamic>).containsKey('cart')) {
        // Field doesn't exist, create it with an empty list
        await document.set({'cart': []}, SetOptions(merge: true));
        print('Field created successfully');
      } else {
        print('Field already exists');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  void initState(){
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseMessaging.instance
        .subscribeToTopic(user!.uid.toString())
        .whenComplete(() => print("Subscription successful"));
    BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent("earpods"));
    checkAndCreateField();
  }
  List<Widget> tabs = [
    SizedBox(
      width: 100,
      height: 25,
      child: Tab(
        text: "Earpods",
      ),
    ),
    SizedBox(
      width: 107,
      height: 25,
      child: Tab(
        text: "Headphones",
      ),
    ),
    SizedBox(
      width: 107,
      height: 25,
      child: Tab(
        text: "Speakers",
      ),
    ),SizedBox(
      width: 107,
      height: 25,
      child: Tab(
        text: "Earphones",
      ),
    ),
  ];
  List<String> tabNames= ["Earpods","Headphones","Speakers","Earphones"];
  String category = "earpods";
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in
      print('User is signed in with UID: ${user.uid}');
      print('User email: ${user.email}');
      final userDocRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid.toString());

      userDocRef.get().then((docSnapshot) {
        if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('cart')) {
          userDocRef.update({"cart": []});
        }
      });
    } else {
      // No user is signed in
      print('No user signed in.');
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/logo.png",height: 20.24,width: 20.24,),
                SizedBox(width: 8,),
                Text("Audio",style:GoogleFonts.dmSans(
                    textStyle:TextStyle(fontWeight: FontWeight.w700,fontSize: 19.05)
                )),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>profile()));
              },
              child: CircleAvatar(
                radius: 20.0,
                child: user!=null
                    ? ClipOval(
                      child: Image.network(
                          user!.photoURL!,
                          fit: BoxFit.fill,
                        ),
                    )
                    : Container(
                        child: Text("${user!.email![0]}"),
                      ),
              ),
            )
          ],
        ),
        leading: Icon(Icons.menu_outlined),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignIn()),
              (route) => false,
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<ProdBloc, ProdState>(builder: (context, state) {
          if (state is ProductSuccess) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                // color: Colors.red,
                // margin: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: user!= null
                            ? Text(
                                "Hi, ${user.displayName}",
                                style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
                              )
                            : Text("Hi,", style: TextStyle(fontSize: 20))),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "What are you looking for today?",
                          style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w700,fontSize: 24)),
                        )),
                    Container(
                        margin:const EdgeInsets.only(
                          left: 25,
                          right: 24,
                          bottom: 24,
                        ),
                        child: TextField(
                          // controller: _emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_rounded,color: Color(0xffBABABA),),
                              labelText: "Search",
                              labelStyle: GoogleFonts.dmSans(textStyle:TextStyle(
                                  fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xffBABABA))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Color(0xffBABABA))
                              )
                          ),
                        )),
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height *(0.79),
                        color: Color(0xffF6F6F6),
                        child: DefaultTabController(
                            length: tabs.length,
                            child: Builder(builder: (BuildContext context) {
                              final TabController tabController =
                                  DefaultTabController.of(context);
                              tabController.addListener(() {
                                if (tabController.indexIsChanging) {
                                  setState(() {
                                    category = tabNames[tabController.index];
                                  });
                                  BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(category));

                                }
                              });
                              return Scaffold(
                                body: Container(
                                  // height: MediaQuery.of(context).size.height,
                                  decoration: const BoxDecoration(
                                      color: Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30))),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TabBar(
                                          indicator: BoxDecoration(
                                              // border: Border.all( width: 1),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(
                                                  30), // Creates border
                                              color: Color(0xff0ACF83)),
                                          dividerColor: Color(0xffF6F6F6),
                                          indicatorSize: TabBarIndicatorSize.values[0],
                                          labelPadding:
                                              EdgeInsets.symmetric(horizontal: 10),
                                          tabAlignment: TabAlignment.center,
                                          physics: BouncingScrollPhysics(),
                                          isScrollable: true,
                                          tabs: tabs,
                                          labelStyle: GoogleFonts.dmSans(textStyle:TextStyle(
                                              fontWeight: FontWeight.w400,fontSize: 14,color: Colors.white)
                                          ),
                                          unselectedLabelStyle: GoogleFonts.dmSans(textStyle:TextStyle(
                                              fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xff7F7F7F))
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width / 1,
                                          height:
                                              MediaQuery.of(context).size.height /
                                                  3,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: state.products.length,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                return GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                Products(
                                                                  cat: category,
                                                                )));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 5),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.95,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          crossAxisAlignment:CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              // color: Colors.red,
                                                              margin: EdgeInsets.only(
                                                                  left: 20),
                                                              width: 160,
                                                              child: Text(
                                                                state.products[index]
                                                                    .prodName!,
                                                                softWrap: true,
                                                                style: GoogleFonts.montserrat(textStyle:TextStyle(
                                                                  fontWeight: FontWeight.w700,fontSize: 22
                                                                )),
                                                                maxLines: null,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left: 20),
                                                              child: Row(
                                                                children: [
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).push(MaterialPageRoute(builder:
                                                                                    (context) => Products(cat: category,)));
                                                                      },
                                                                      child:
                                                                          Text("Shop Now",
                                                                            style: GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff0ACF83),fontWeight: FontWeight.w700,fontSize: 14)),
                                                                          )
                                                                  ),
                                                                  Icon(Icons.arrow_forward,color: Color(0xff0ACF83),)
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          height:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .height /
                                                                  3.5,
                                                          // color: Colors.red,
                                                          child: Image.asset(
                                                            state.products[index].prodImage!,
                                                            height: 120,
                                                            width: 120,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(horizontal: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Featured Products",
                                                  style: GoogleFonts.dmSans(textStyle:TextStyle(color: Colors.black,fontWeight: FontWeight.w400,
                                                  fontSize: 16)),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                Products(
                                                                  cat: category,
                                                                )));
                                                  },
                                                  child: Text("See all",style:
                                            GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff7F7F7F),fontWeight: FontWeight.w400,
                                             fontSize: 16,))
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            width:
                                                MediaQuery.of(context).size.width /
                                                    0.7,
                                            height: 200,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: state.products.length,
                                                itemBuilder: (BuildContext context,
                                                    int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    width: 150,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          // height: MediaQuery.of(context).size.height/4,
                                                          // color: Colors.red,
                                                          child: Image.asset(
                                                            state.products[index].prodImage!,
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          width: 160,
                                                          child: Text(
                                                            state.products[index]
                                                                .prodName!,
                                                            softWrap: true,
                                                            style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 14)),maxLines: null,
                                                            overflow: TextOverflow
                                                                .visible,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (state is ProductError) {
            return Center(child: Text(state.error));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
