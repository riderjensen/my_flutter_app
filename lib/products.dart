import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products([this.products = const []]);

	Widget _buildProductItem(BuildContext context, int index) {
		return Card(
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/food.jpg'),
                    Text(products[index])
                  ],
                ),
              );
	}

	Widget _buildProductsList() {
		Widget productCard = Center(child: Text('No products found.'));
	  	if (products.length > 0 ) {
		  	productCard = ListView.builder(
			itemBuilder: _buildProductItem,
			itemCount: products.length,
		);
	  }
    return productCard;
	}

  @override
  Widget build(BuildContext context) {
	  return _buildProductsList();
  }
}
