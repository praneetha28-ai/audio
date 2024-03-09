part of 'prod_bloc.dart';

abstract class ProdEvent extends Equatable {

}

class ProductsFetchEvent extends ProdEvent{
  final String cat;
  ProductsFetchEvent(this.cat);

  @override
  List<Object?> get props => [cat];
}
class ProductDetailsRequested extends ProdEvent{

  final String cat;
  final int index;
  ProductDetailsRequested(this.cat, this.index);
  @override
  List<Object?> get props => [cat, index];

}

class CartRequested extends ProdEvent{
  @override
  List<Object?> get props => [];
}

class UpdateCart extends ProdEvent{
  final ProductItem prod;
  UpdateCart(this.prod);
  @override
  List<Object?> get props => [prod];
}

class DeleteCartItem extends ProdEvent{
  final int index;
  DeleteCartItem(this.index);
  @override
  List<Object?> get props => [index];
}

class DeleteCartList  extends ProdEvent{
  @override
  List<Object?> get props => [];
}