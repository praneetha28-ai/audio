part of 'prod_bloc.dart';

abstract class ProdState extends Equatable {
  const ProdState();
}

class ProdInitial extends ProdState {
  @override
  List<Object> get props => [];
}

class ProductSuccess extends ProdState {
  final List<ProductItem> products;

  ProductSuccess(this.products);

  @override
  List<Object?> get props => [products];
}
class ProductError extends ProdState {
  final String error;

  ProductError(this.error);

  @override
  List<Object?> get props => [error];
}
class DetailsSuccess extends ProdState {
  final ProductItem product;

  DetailsSuccess(this.product);

  @override
  List<Object?> get props => [product];
}
class DetailsError extends ProdState {
  final String error;

  DetailsError(this.error);

  @override
  List<Object?> get props => [error];
}

class CartSuccess extends ProdState{
  final List<ProductItem> products;
  CartSuccess(this.products);
  @override
  List<Object> get props => [products];
}
class CartError extends ProdState{
  final String error;
  CartError(this.error);
  @override
  List<Object> get props=>[error];
}

class CartUpdate extends ProdState{
  final String msg;
  CartUpdate(this.msg);
  @override
  List<Object> get props=>[msg];
}