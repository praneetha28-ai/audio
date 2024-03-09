import 'package:audio/bloc/auth/auth_bloc.dart';
import 'package:audio/presentation/home/cart.dart';
import 'package:audio/presentation/home/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  List<Tab> tabs = [
    Tab(text: "Popularity",),
    Tab(text: "Newest",),
    Tab(text: "Most expensive",),
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
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.of(context).pop();
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
                          margin: EdgeInsets.only(left: 30),
                          child: Text(cat.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                        ),
                        DefaultTabController(
                            length: tabs.length,
                            child: Builder(
                              builder: (BuildContext context){
                                final TabController tabController = DefaultTabController.of(context);
                                return
                                Column(
                                  children: [
                                    TabBar(
                                      indicator: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), // Creates border
                                          color: Colors.green
                                      ),
                                      // indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                                      dividerColor: Color(0xffF6F6F6),
                                      // indicatorColor: Colors.green,
                                      indicatorSize: TabBarIndicatorSize.values[0],
                                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                                      tabAlignment: TabAlignment.center,
                                      // labelStyle: TextStyle(fontSize: 16, wordSpacing: 10),
                                      physics: BouncingScrollPhysics(),
                                      // // padding: EdgeInsets.symmetric(horizontal: 5),
                                      // automaticIndicatorColorAdjustment: true,
                                      isScrollable: true,
                                      tabs: tabs,
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                      height: MediaQuery.of(context).size.height*(0.8),
                                        decoration:const BoxDecoration(
                                        color: Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)
                                        )
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
                                                  height: 200,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Colors.white,
                                                  ),

                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin:EdgeInsets.only(left: 20),
                                                          child: Image.asset(state.products[index].prodImage!,width: 100,height: 100,alignment: Alignment.center,)),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 5),
                                                        child: Text(
                                                          state.products[index].prodName!,
                                                          style: TextStyle(fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 5),
                                                        child: Text("USD "+
                                                            state.products[index].prodPrice!,
                                                          style: TextStyle(fontSize: 18),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(left: 5),
                                                          child: Text("Rating")
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
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
