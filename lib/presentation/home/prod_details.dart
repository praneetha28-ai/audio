// import 'package:flutter/material.dart';
//
// class Product_details extends StatelessWidget {
//   const Product_details({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: InkWell(
//           child: Image.asset('assets/Icon/chevron-left.png'),
//           onTap: () {},
//         ),
//         actions: [
//           InkWell(
//             child: Image.asset('assets/Icon/shopping-cart.png'),
//             onTap: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         floatingActionButton: Container(
//         width: 380,
//         child: FloatingActionButton(
//           child: Text(
//             'Add To Cart',
//             style: TextStyle(color: Colors.white),
//           ),
//           onPressed: () {},
//           backgroundColor: Colors.green,
//         ),
//       ),
//         child: DefaultTabController(length: 3,
//           child: Builder(
//               builder: builder,
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'USD 350',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   'TMA-2',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   'HD WIRELESS',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       ),
//     );
//   }
// }
