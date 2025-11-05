class CartModel {
  final List<CartItem> cartItems;
  final double subTotal;
  final double discount;
  final double totalAmount;

  CartModel({
    required this.cartItems,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartItems: (json['cartItems'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      subTotal: double.tryParse(json['sub_total'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
    );
  }
}

class CartItem {
  final int id;
  final int productId;
  final String productTitle;
  final String productImage;
  final String userName;
  final int userId;
  final int? orderId;
  final double price;
  final double vatPrice;
  final int productVariationId;
  final int quantity;
  final double amount;

  CartItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.userName,
    required this.userId,
    this.orderId,
    required this.price,
    required this.vatPrice,
    required this.productVariationId,
    required this.quantity,
    required this.amount,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      productTitle: json['product_title'],
      productImage: json['product_image'],
      userName: json['user_name'],
      userId: json['user_id'],
      orderId: json['order_id'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      vatPrice: double.tryParse(json['vat_price'].toString()) ?? 0.0,
      productVariationId: json['product_variation_id'],
      quantity: json['quantity'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
    );
  }
}
