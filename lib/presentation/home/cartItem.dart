import 'package:flutter/material.dart';

class cartItem extends StatelessWidget {
  const cartItem(
      {required this.image,
      required this.price,
      required this.name,
      super.key});
  final String name;
  final String price;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: Colors.amberAccent,
      ),
      height: 100,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(6)),
            child: Image.asset(
              image,
              // width: 10,
              // height: 10,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'USD $price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      child: Image.asset('assets/Icon/minus-square.png'),
                      onTap: () {},
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('1'),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                        child: Image.asset('assets/Icon/plus-square.png'),
                        onTap: () {}),
                    SizedBox(
                      width: 150,
                    ),
                    InkWell(
                      child: Image.asset('assets/Icon/trash-2.png'),
                      onTap: () {},
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
