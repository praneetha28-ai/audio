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

      DocumentSnapshot userDoc = await userRef.doc(user!.uid).get();
      final data = userDoc.data() as Map<String, dynamic>;
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data['cart'] ?? []);

      cartList.removeAt(index);

      await userRef.doc(user!.uid).update({'cart': cartList});

      return ('Product deleted successfully');
    } catch (e) {
      return ('Error deleting product: $e');
    }
  }
  Future<String> addToCart(ProductItem prod)async{
    await userRef.doc(user!.uid).update({
      'cart': FieldValue.arrayUnion([prod.toJson()])
    });
    return "Added ";
  }

  Future<int> deleteProducts() async {
    try {
      DocumentSnapshot userDoc = await userRef.doc(user!.uid).get();
      final data = userDoc.data() as Map<String, dynamic>; // Explicit casting here
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data['cart'] ?? []);

      cartList.clear();
      await userRef.doc(user!.uid).update({'cart': cartList});

      print('Product deleted successfully');
      return 0;
    } catch (e) {
      print('Error deleting product: $e');
      return 1;
    }
  }

  Future<String> checkOut() async{
    try{
      DocumentSnapshot userDoc = await userRef.doc(user!.uid).get();
      final data = userDoc.data() as Map<String, dynamic>;
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data['cart'] ?? []);
      DocumentSnapshot<Map<String, dynamic>> docRef = await
      FirebaseFirestore.instance.collection("dealer").
      doc("received").collection("users").doc(user!.uid).get();
      DocumentSnapshot<Map<String, dynamic>> docRefDelivered = await
      FirebaseFirestore.instance.collection("dealer").
      doc("delivered").collection("users").doc(user!.uid).get();



      if(docRef.exists){
        print("hello");
        // List<Map<String,dynamic>> orders = docRef.get("orders");
        await FirebaseFirestore.instance.collection("dealer").doc("received").collection("users").
        doc(user!.uid).update({"${user!.displayName}":FieldValue.arrayUnion(cartList)});
        if(!docRefDelivered.exists){
          print("hur");
          await FirebaseFirestore.instance.collection("dealer").doc("delivered").collection("users").
          doc(user!.uid).set({"${user!.displayName}":[]});
        }
      }else{
        await FirebaseFirestore.instance.collection("dealer").doc("received").collection("users").doc(user!.uid).
        set({"${user!.displayName}":cartList});
      }
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({"cart":FieldValue.arrayRemove(cartList)});

      return "Success";
    }catch(e){
      return e.toString();
    }
  }



}