import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
import '../widgets/products/product_fab.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductPage();
  }
}

class _ProductPage extends State<ProductPage> {
  Widget _buildTitleContainer(String title) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      child: TitleDefault(title),
    );
  }

  void _showMap() {
    final List<Marker> markers = <Marker>[
      Marker('position', 'Position', widget.product.location.latitude,
          widget.product.location.longitude)
    ];
    final cameraPosition = CameraPosition(
        Location(widget.product.location.latitude,
            widget.product.location.longitude),
        14.0);
    final mapView = MapView();
    mapView.show(
        MapOptions(
            initialCameraPosition: cameraPosition,
            mapViewType: MapViewType.normal,
            title: 'Product Location'),
        toolbarActions: [ToolbarAction('Close', 1)]);
    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  Widget _buildAddressAndPriceContainer(String address, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showMap,
          child: Text(
            address,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$${price.toString()}',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionContainer(String description) {
    return Container(
      padding: EdgeInsets.all(15.0),
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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.product.title),
                background: Hero(
                  tag: widget.product.id,
                  child: FadeInImage(
                    image: NetworkImage(widget.product.image),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/placeholder.png'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildTitleContainer(widget.product.title),
                _buildAddressAndPriceContainer(
                    widget.product.location.address, widget.product.price),
                _buildDescriptionContainer(widget.product.description),
              ]),
            )
          ],
        ),
        floatingActionButton: ProductFAB(widget.product),
      ),
    );
  }
}
