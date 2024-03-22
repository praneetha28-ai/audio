import 'package:audio/bloc/prod/prod_bloc.dart';
import 'package:audio/presentation/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: BlocBuilder<ProdBloc,ProdState>(
          builder: (context,state){
            if(state is CheckOutSuccess){
             return Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,color: Color(0xff0ACF83),size: 130,),
                      SizedBox(height: 20,),
                      Text("Order Confirmed !",style: GoogleFonts.dmSans(textStyle:
                      TextStyle(color:Colors.black,fontSize: 24,fontWeight: FontWeight.w400)),),
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Text("Thank you. Your order was placed successfully.",style: GoogleFonts.dmSans(textStyle:
                        TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.w400),),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 40,),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0ACF83)),
                          onPressed: (){
                            BlocProvider.of<ProdBloc>(context).add(ProductsFetchEvent("earpods"));
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Dashboard()));
                          },
                          child: Text("Shop Again",style: GoogleFonts.dmSans(textStyle:
                          TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16)),),),
                      )
                    ],
                  ),
                ),
              );
            }else if(state is CartError){
              return Center(child: Text("${state.error}"),);
            }
            else{
              return Center(child: CircularProgressIndicator(color: Color(0xff0ACF83),));
            }
          }
      ),
    );
  }
}
