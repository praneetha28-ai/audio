import 'package:audio/bloc/auth/auth_bloc.dart';
import 'package:audio/presentation/home/cart.dart';
import 'package:audio/presentation/home/dashboard.dart';
import 'package:audio/presentation/home/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/prod/prod_bloc.dart';
import '../auth/signin.dart';

class Products extends StatefulWidget {
  final String cat;
  const Products({Key? key,required this.cat}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState(cat: cat);
}

class _ProductsState extends State<Products> {

  @override
  void initState(){
    super.initState();
    BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat));
  }
  String cat;


  List<Widget> tabs = [
    SizedBox(child: Tab(text: "Popularity",)),
    SizedBox(child: Tab(text: "Newest",)),
    SizedBox(child: Tab(text: "Most expensive",)),
  ];
  _ProductsState({required this.cat});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val){
        if(val){
          BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat));
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 20,),
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Dashboard()));
              BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent("earpods"));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                BlocProvider.of<ProdBloc>(context).add(CartRequested());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>Cart(cat: cat.toString(),)));
              },
                icon: Icon(Icons.shopping_cart_outlined),),
            ],
          ),
        ),
        body: BlocListener<AuthBloc,AuthState>(
            listener: (context,state){
              if(state is UnAuthenticated){
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
            child: BlocBuilder<ProdBloc,ProdState>(
              builder: (context,state){
                if (state is ProductSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Text(cat.toUpperCase(),
                            style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w700,fontSize: 24))),
                        ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffBABABA)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 90,
                                    height: 40,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.tune_outlined),
                                        Text("Filter",style: GoogleFonts.dmSans(textStyle:TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w400)),)
                                      ],
                                    ),
                                  ),
                                  Container(margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("Popularity",style:  GoogleFonts.dmSans(textStyle:TextStyle(fontSize: 14,
                fontWeight: FontWeight.w400)),)),
                                  Container(margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("Newest",style: GoogleFonts.dmSans(textStyle:TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w400)))),
                                  Container(margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("Most Expensive",style: GoogleFonts.dmSans(textStyle:TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w400)))),
                                ],
                              ),
                            ),
                            SizedBox(height: 35,),
                            SingleChildScrollView(
                              child: Container(
                              height: MediaQuery.of(context).size.height*(0.8),
                                decoration:const BoxDecoration(
                                color: Color(0xffF3F3F3),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))
                                ),

                                child: GridView.builder(
                                    itemCount: state.products.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.7
                                    ),
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          print(index);
                                          print(cat);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (context)=>Details(index: index,cat: cat,))
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 11,vertical: 10),
                                          height: 250,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      // margin:EdgeInsets.only(left: 20),
                                                      child: Image.asset(state.products[index].prodImage!,
                                                        width: 100,height: 100,alignment: Alignment.center,)),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 5,top: 20),
                                                    child: Text(
                                                      state.products[index].prodName!,
                                                      style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 14)),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    child: Text("USD "+
                                                        state.products[index].prodPrice!,
                                                      style:GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w700,fontSize: 12)),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                      margin: EdgeInsets.only(left: 5),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.star,color: Color(0xffFFC120),size: 10,),
                                                          Text("4.6",style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),),
                                                          SizedBox(width: 10,),
                                                          Text("86  Reviews",style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 10),)),
                                                          SizedBox(width: 20,),
                                                          Icon(Icons.more_vert,size: 20,)
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            )
                      ],
                    ),
                  );
                }
                else if(state is ProductError){
                  return Center(child: Text(state.error));
                }
                else{
                  return Center(child: CircularProgressIndicator(),);
                }
            },
          )
        ),
      ),
    );
  }
}
