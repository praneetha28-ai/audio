class ProductItem {
  String? prodName;
  String? prodImage;
  String? prodDetails;
  String? prodPrice;
  String? prodRating;
  int? quantity;

  ProductItem(
      {this.prodName,
        this.prodImage,
        this.prodDetails,
        this.prodPrice,
        this.prodRating,
        this.quantity
      });

  ProductItem.fromJson(Map<String, dynamic> json) {
    prodName = json['prod_name'];
    prodImage = json['prod_image'];
    prodDetails = json['prod_details'];
    prodPrice = json['prod_price'];
    prodRating = json['prod_rating'];
    quantity = (json['prod_qty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prod_name'] = this.prodName;
    data['prod_image'] = this.prodImage;
    data['prod_details'] = this.prodDetails;
    data['prod_price'] = this.prodPrice;
    data['prod_rating'] = this.prodRating;
    data['prod_qty'] = this.quantity;
    return data;
  }
}