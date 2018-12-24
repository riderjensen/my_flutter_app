import 'package:flutter/material.dart';

import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget {
  Widget _buildSideDrawer(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choose'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Trading Post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          )
        ],
      ),
      body: Products(),
    );
  }
}
