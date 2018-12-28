import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';

import '../../scoped-models/main.dart';
import '../../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  @override
  State<StatefulWidget> createState() {
    return _ProductCard();
  }
}

class _ProductCard extends State<ProductCard> {
  Widget _buildTitlePriceContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(widget.product.title),
          SizedBox(width: 10.0),
          PriceTag(widget.product.price.toString())
        ],
      ),
    );
  }

  Widget _buildButtonBar(context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () {
            model.selectProduct(model.allProducts[widget.productIndex].id);
            Navigator.pushNamed<bool>(context,
                    '/product/' + model.allProducts[widget.productIndex].id)
                .then((_) {
              model.selectProduct(null);
            });
          },
        ),
        IconButton(
          icon: Icon(model.allProducts[widget.productIndex].isFavorite
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            model.selectProduct(model.allProducts[widget.productIndex].id);
            model.toggleProductFavorite();
          },
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: widget.product.id,
            child: FadeInImage(
              image: NetworkImage(widget.product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/placeholder.png'),
            ),
          ),
          _buildTitlePriceContainer(),
          AddressTag(widget.product.location.address),
          _buildButtonBar(context)
        ],
      ),
    );
  }
}
