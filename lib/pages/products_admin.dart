import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class AdminPage extends StatelessWidget {
  final MainModel model;

  AdminPage(this.model);

  Widget _buildSideDrawer(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Admin Choose'),
            automaticallyImplyLeading: false,
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile()
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
          title: Text('Manage Products'),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
          children: <Widget>[ProductEditPage(), ProductListPage(model)],
        ),
      ),
    );
  }
}
