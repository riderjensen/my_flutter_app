import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class AdminPage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  AdminPage(this.addProduct, this.deleteProduct);

  Widget _buildSideDrawer(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Admin Choose'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Admin page'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'My Products',
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductCreatePage(addProduct), ProductListPage()],
        ),
      ),
    );
  }
}
