// import 'dart:convert';

// class WishlistModel {
//   final List<WishlistItem> wishlist;

//   WishlistModel({required this.wishlist});

//   factory WishlistModel.fromJson(String source) =>
//       WishlistModel.fromMap(json.decode(source));

//   factory WishlistModel.fromMap(Map<String, dynamic> map) {
//     return WishlistModel(
//       wishlist: List<WishlistItem>.from(
//         map['wishlist']?.map((x) => WishlistItem.fromMap(x)) ?? [],
//       ),
//     );
//   }
// }

// class WishlistItem {
//   final int id;
//   final int productId;
//   final String productTitle;
//   final String productImage;
//   final String userName;
//   final double price;
//   final int quantity;
//   final double amount;

//   WishlistItem({
//     required this.id,
//     required this.productId,
//     required this.productTitle,
//     required this.productImage,
//     required this.userName,
//     required this.price,
//     required this.quantity,
//     required this.amount,
//   });

//   factory WishlistItem.fromMap(Map<String, dynamic> map) {
//     return WishlistItem(
//       id: map['id'] ?? 0,
//       productId: map['product_id'] ?? 0,
//       productTitle: map['product_title'] ?? '',
//       productImage: map['product_image'] ?? '',
//       userName: map['user_name'] ?? '',
//       price: (map['price'] as num?)?.toDouble() ?? 0.0,
//       quantity: map['quantity'] ?? 0,
//       amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'product_id': productId,
//       'product_title': productTitle,
//       'product_image': productImage,
//       'user_name': userName,
//       'price': price,
//       'quantity': quantity,
//       'amount': amount,
//     };
//   }

//   String toJson() => json.encode(toMap());

//   @override
//   String toString() {
//     return 'WishlistItem(id: $id, productId: $productId, productTitle: $productTitle, productImage: $productImage, userName: $userName, price: $price, quantity: $quantity, amount: $amount)';
//   }
// }

class WishlistItem {
  final int id;
  final int productId;
  final String productTitle;
  final String productImage;
  final String userName;
  final double price;
  final int quantity;
  final double amount;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.userName,
    required this.price,
    required this.quantity,
    required this.amount,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      productId: json['product_id'],
      productTitle: json['product_title'],
      productImage: json['product_image'],
      userName: json['user_name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
