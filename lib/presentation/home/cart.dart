
import 'package:audio/bloc/prod/prod_bloc.dart';
import 'package:audio/models/product.dart';
import 'package:audio/presentation/home/checkout.dart';
import 'package:audio/presentation/home/dashboard.dart';
import 'package:audio/presentation/home/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
class Cart extends StatefulWidget {
  final String cat;
  const Cart({Key? key,required this.cat}) : super(key: key);

  @override
  State<Cart> createState() => _CartState(cat: cat);
}

class _CartState extends State<Cart> {
  String cat;
  _CartState({required this.cat});
  int price = 0;

  Future<void> totalPrice()async{
    final user = FirebaseAuth.instance.currentUser;
    final ref =await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();

    if(ref.exists){
      int Updprice = 0;
      final cartData = ref.data()!['cart'] as List<dynamic>;
      print(cartData);
      for(int i = 0;i<cartData.length;i++){
        var data = cartData[i];
        Updprice+= int.parse(data['prod_price'])*(data['prod_qty']+1 as int);
        print(Updprice);
      }
      setState(() {
        price = Updprice;
      });
    }
    // return price;
    // return 0;
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,

  }) async {
    // await FirebaseMessaging.instance.subscribeToTopic(year).whenComplete(() => print("subscribed"));
    final user = FirebaseAuth.instance.currentUser;
    String dataNotifications = '{ '
        ' "to" : "/topics/dealer" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"From $body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }

  @override
  void initState(){
    super.initState();
    totalPrice();

  }

  final user = FirebaseAuth.instance.currentUser;
  Future<void> deleteCartItemAndUpdatePrice(int index) async {
    BlocProvider.of<ProdBloc>(context).add(DeleteCartList()); // Wait for item deletion
    totalPrice(); // Update price after item deletion
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProdBloc, ProdState>(
      builder: (context, state) {
      return PopScope(
        onPopInvoked: (val){
          if(val){
            BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat.toString()));
          }
        },
        canPop: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
            title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat));
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Products(cat: cat,)));
              },
                  icon: Icon(Icons.arrow_back_ios,size: 20,)),
              Text("Shopping Cart",style: GoogleFonts.dmSans(textStyle:
              TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),),
              IconButton(onPressed: (){
                BlocProvider.of<ProdBloc>(context).add(DeleteCartList());
                Future.delayed(Duration(seconds: 1),totalPrice);
              },
                  icon: Icon(Icons.delete_rounded))
            ],
          ),
        ),
        body: (state is CartSuccess)?
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       color: Colors.white,
                       height: MediaQuery.of(context).size.height*0.7,
                      child: ListView.builder(
                        itemCount: state.products.length,
                          itemBuilder: (BuildContext context,index){
                          print(state.products.length);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:87,
                                    height: 87,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Image.asset(state.products[index].prodImage!,width: 65,height: 65,)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:200,
                                        child: Text(state.products[index].prodName!,softWrap: true,maxLines: 2,
                                        style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 16)),)),
                                    Row(
                                      children: [
                                      IconButton(
                                          onPressed: ()async{
                                          },
                                          icon: Icon(Icons.indeterminate_check_box_outlined)
                                      ),
                                      Text((state.products[index].quantity!+1).toString()),
                                      IconButton(onPressed: (){}, icon: Icon(Icons.add_box_outlined))
                                    ],
                                    )
                                  ],
                                ),
                                IconButton(onPressed: ()async{

                                  BlocProvider.of<ProdBloc>(context).add(DeleteCartItem(index));
                                  Future.delayed(Duration(seconds: 1),totalPrice);


                                  },
                                    icon: Icon(Icons.delete_outline_outlined)
                                )
                              ],
                            );
                          }
                      )
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           margin: EdgeInsets.all(8),
                             child: Text("Total ${state.products.length} Products",
                               style: GoogleFonts.dmSans(textStyle:
                               TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12))),
                         ),
                         Container(
                           margin: EdgeInsets.all(8),
                             child: Text("USD ${price}",
                               style: GoogleFonts.dmSans(textStyle:
                               TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16))
                             ),
                         )
                       ],
                     ),
                     SizedBox(height: 20,),
                     Container(
                       margin: EdgeInsets.all(8),
                       width: MediaQuery.of(context).size.width,
                       height: 50,
                       child: ElevatedButton(
                         onPressed: (){
                           BlocProvider.of<ProdBloc>(context).add(CheckoutRequested());
                           pushNotificationsAllUsers(title: "New Order Received", body: user!.displayName!);
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CheckOut()));

                         },
                         style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0ACF83)),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Text("Proceed to checkout",
                               style: GoogleFonts.dmSans(textStyle:
                               TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14)),),
                             Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 25,)
                           ],
                         ),
                     )
                     )
                   ],
                 )
              :(state is CartError)?
                 Container(
                   child: Center(child: Text(state.error),),
                 ):
                 Center(child: CircularProgressIndicator(),),

            ),
      );
  },
);
  }
}
