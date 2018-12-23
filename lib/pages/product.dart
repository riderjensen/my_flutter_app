import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  final String address;

  ProductPage(
      this.title, this.imageUrl, this.description, this.price, this.address);

  Widget _buildTitleContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TitleDefault(title),
    );
  }

  Widget _buildAddressAndPriceContainer() {
    return Container(
      child: Text(
        address + '- \$${price.toString()}',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDescriptionContainer() {
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(imageUrl),
            _buildTitleContainer(),
            _buildAddressAndPriceContainer(),
            _buildDescriptionContainer(),
          ],
        ),
      ),
    );
  }
}
