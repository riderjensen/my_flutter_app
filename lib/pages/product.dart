import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../scoped-models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildTitleContainer(String title) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TitleDefault(title),
    );
  }

  Widget _buildAddressAndPriceContainer(double price) {
    return Container(
      child: Text(
        'Address Here' + '- \$${price.toString()}',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDescriptionContainer(String description) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.allProducts[productIndex];
      return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(product.image),
            _buildTitleContainer(product.title),
            _buildAddressAndPriceContainer(product.price),
            _buildDescriptionContainer(product.description),
          ],
        ),
      );
    }));
  }
}
