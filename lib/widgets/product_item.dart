import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem({
    Key key,
    @required this.id,
    @required this.imageUrl,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
          onPressed: () => null,
          icon: Icon(
            Icons.favorite,
          ),
        ),
        trailing: IconButton(
          onPressed: () => null,
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
