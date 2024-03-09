import 'package:audio/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsRepository{
  final user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance.collection("categories");
  final userRef = FirebaseFirestore.instance.collection("users");

  Stream<List<ProductItem>> getProducts(String cat){
    return ref.doc(cat.toLowerCase()).snapshots().map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>;
              final cartList = data['products'] as List<dynamic>;
              return cartList.map((cartItem) => ProductItem.fromJson(cartItem)).toList();
            }
    );
  }

  Stream<ProductItem?> getProductByIndex(String cat, int index) {
    return ref.doc(cat.toLowerCase()).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('products')) {
        final cartList = data['products'] as List<dynamic>;

        if (index >= 0 && index < cartList.length) {

          return ProductItem.fromJson(cartList[index]);
        } else {
          print("Invalid index: $index for cart list.");
          return null;
        }
      } else {
        print("Cart field not found in document.");
        return null;
      }
    });
  }

  Stream<List<ProductItem>> getCartProducts(){
    return userRef.doc(user!.uid).snapshots().map(
            (doc) {
          final data = doc.data() as Map<String, dynamic>;
          final cartList = data['cart'] as List<dynamic>;
          return cartList.map((cartItem) => ProductItem.fromJson(cartItem)).toList();
        }
    );
  }
  Future<String> deleteProductAtIndex(int index) async {
    try {
      // Fetch the current cart data
      DocumentSnapshot userDoc = await userRef.doc(user!.uid).get();
      final data = userDoc.data() as Map<String, dynamic>; // Explicit casting here
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data['cart'] ?? []);

      // Remove the item at the specified index
      cartList.removeAt(index);

      // Update the cart data in Firestore
      await userRef.doc(user!.uid).update({'cart': cartList});

      return ('Product deleted successfully');
    } catch (e) {
      return ('Error deleting product: $e');
    }
  }
  Future<String> addToCart(ProductItem prod)async{
    // final userDocRef = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    await userRef.doc(user!.uid).update({
      'cart': FieldValue.arrayUnion([prod.toJson()])
    });
    return "Added ";
  }

  Future<int> deleteProducts() async {
    try {
      // Fetch the current cart data
      DocumentSnapshot userDoc = await userRef.doc(user!.uid).get();
      final data = userDoc.data() as Map<String, dynamic>; // Explicit casting here
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data['cart'] ?? []);

      // Remove the item at the specified index
      cartList.clear();

      // Update the cart data in Firestore
      await userRef.doc(user!.uid).update({'cart': cartList});

      print('Product deleted successfully');
      return 0;
    } catch (e) {
      print('Error deleting product: $e');
      return 1;
    }
  }
}