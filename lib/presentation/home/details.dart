import 'package:audio/presentation/home/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../bloc/prod/prod_bloc.dart';
import '../../constants.dart';

class Details extends StatefulWidget {

  final index;
  final cat;
  const Details({Key? key,required this.index,required this.cat}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState(index: index,cat: cat);
}

class _DetailsState extends State<Details> {
  int index;
  var cat;
  _DetailsState({required this.index,required this.cat});

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,

  }) async {
    // await FirebaseMessaging.instance.subscribeToTopic(year).whenComplete(() => print("subscribed"));
    final user = FirebaseAuth.instance.currentUser;
    String dataNotifications = '{ '
        ' "to" : "/topics/${user!.uid.toString()}" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
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

    BlocProvider.of<ProdBloc>(context).add(ProductDetailsRequested(cat,index));
    super.initState();
  }
  List<Tab> tabs = [
    Tab(
      text: "Overview",
    ),
    Tab(
      text: "Specifications",
    ),
    Tab(
      text: "Features",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return PopScope(
      onPopInvoked: (val){
        if(val){
          BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat));
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(cat));
            Navigator.of(context).pop();
           },icon: Icon(Icons.arrow_back_ios),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                BlocProvider.of<ProdBloc>(context).add(CartRequested());
                print(cat);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Cart(cat: cat,))
                );
              },
                icon: Icon(Icons.shopping_cart_outlined),),
            ],
          ),
        ),
        body: BlocBuilder<ProdBloc, ProdState>(
          builder: (context, state) {
          if(state is DetailsSuccess) {
            return SingleChildScrollView(
              child: DefaultTabController(
                length: 3,
                child: Builder(builder: (BuildContext context) {
                  final TabController tabController =
                  DefaultTabController.of(context);
                  tabController.addListener(() {
                    if (tabController.indexIsChanging) {

                      // BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent(category));
                    }
                  });
                return Container(
                  margin: EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("USD  "+state.product.prodPrice!,style:
                      GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff0ACF83),fontSize: 16,fontWeight: FontWeight.w700))),
                      Text(state.product.prodName!,style:GoogleFonts.montserrat(textStyle:TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.w700))),
                      TabBar(
                          dividerColor: Color(0xffF6F6F6),
                          indicatorColor: Color(0xff0ACF83),
                          indicatorSize: TabBarIndicatorSize.values[1],
                          labelPadding:
                          EdgeInsets.symmetric(horizontal: 10),
                          tabAlignment: TabAlignment.center,
                          labelStyle: GoogleFonts.dmSans(textStyle:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400)),
                          physics: BouncingScrollPhysics(),
                          isScrollable: true,
                          tabs: tabs
                      ),
                      SizedBox(height: 30,),
                      Text("""
                      Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                      """,softWrap: true,maxLines: 10,overflow: TextOverflow.visible,
                      style: GoogleFonts.dmSans(textStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 14)),),
                      Image.asset(state.product.prodImage!,height: 300,width: 300,),
                      Container(
                        // margin: EdgeInsets.only(bottom: 10,top: MediaQuery.of(context).size.height/2.8),
                        width: MediaQuery.of(context).size.width,
                        child: FloatingActionButton(
                          child: Text(
                            'Add To Cart',
                            style:GoogleFonts.dmSans(textStyle:
                            TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white)),
                          ),
                          onPressed: () async{
                           await  pushNotificationsAllUsers(title: state.product.prodName!, body: "Added to cart");
                            BlocProvider.of<ProdBloc>(context).add(UpdateCart(state.product));
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cart(cat: cat,)));

                          },
                          backgroundColor: Color(0xff0ACF83),
                        ),
                      ),
                    ],
                  ),
                );
              })),
            );
            }else if(state is DetailsError){
              return Center(child: Text(state.error),);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
        },
      ),
      ),
    );
  }


}
