import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            )
          ],
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (ctx, i) => Column(children: [
            UserProductItem(
                productData.items[i].title, productData.items[i].imageUrl),
            Divider()
          ]),
        ));
  }
}
