import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product.dart';
import '../../repo/ProdRepo.dart';

part 'prod_event.dart';
part 'prod_state.dart';

class ProdBloc extends Bloc<ProdEvent, ProdState> {
  final ProductsRepository prodRep;
  ProdBloc({required this.prodRep}) : super(ProdInitial()) {
    on<ProductsFetchEvent>((event, emit) async {
      try {
        final products = await prodRep.getProducts(event.cat).first;
        final cartData = await prodRep.getCartProducts().first;
        final count = cartData.length;
        emit(ProductSuccess(products,count));
      } on Exception catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<ProductDetailsRequested>((event,emit)async{
      try{
        final products = await prodRep.getProductByIndex(event.cat, event.index).first;
        final cartData = await prodRep.getCartProducts().first;
        final count = cartData.length;
        emit(DetailsSuccess(products!,count));
      }catch(e){
        emit(DetailsError(e.toString()));
      }
    });


    on<CartRequested>((event,emit)async{
      try{
        final products = await prodRep.getCartProducts().first;
        emit(CartSuccess(products));
      }catch(e){
        emit(CartError(e.toString()));
      }
    });

    on<UpdateCart>((event,emit)async{
      try{
        final msg = await prodRep.addToCart(event.prod);
        final cartData = await prodRep.getCartProducts().first;
        final count = cartData.length;
        emit(CartUpdate(msg));
      }catch(e){
        emit(CartError(e.toString()));
      }
    });
    on<DeleteCartItem>((event,emit)async{
      try{
        final msg = await prodRep.deleteProductAtIndex(event.index);
        final products = await prodRep.getCartProducts().first;
        emit(CartSuccess(products));
      }catch(e){
        emit(CartError(e.toString()));
      }
    });
    on<DeleteCartList>((event,emit)async{
      try{
        final msg = await prodRep.deleteProducts();
        final products = await prodRep.getCartProducts().first;
        emit(CartSuccess(products));
      }catch(e){
        emit(CartError(e.toString()));
      }
    });
    on<CheckoutRequested>((event,emit)async{
      try{
        final msg = await prodRep.checkOut();
        emit(CheckOutSuccess(msg));
      }catch(e){
        emit(CartError(e.toString()));
      }
    });
  }
}
