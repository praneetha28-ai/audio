// import 'package:flutter/material.dart';
// import 'package:sample/cartItem.dart';
//
// class cart extends StatelessWidget {
//   const cart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: InkWell(
//             child: Image.asset('assets/Icon/chevron-left.png'), onTap: () {}),
//         title: Text('Shopping Cart',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         actions: [
//           InkWell(child: Image.asset('assets/Icon/trash-2.png'), onTap: () {})
//         ],
//       ),
//       body: Column(
//         children: [
//           cartItem(
//             image: 'assets/images/headphone.png',
//             name: 'Headphones',
//             price: '250',
//           ),
//           cartItem(
//             image: 'assets/images/headphone.png',
//             name: 'Headphones',
//             price: '250',
//           ),
//         ],
//       ),
//       floatingActionButton: Container(
//         width: 380,
//         child: FloatingActionButton(
//           onPressed: () {},
//           backgroundColor: Colors.lightGreen,
//           child: Text(
//             'Proceed to Checkout',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
