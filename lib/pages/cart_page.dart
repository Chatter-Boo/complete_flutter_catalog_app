import 'package:flutter/material.dart';
import 'package:flutter_catalog/core/store.dart';
import 'package:flutter_catalog/models/cart.dart';

import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: "My Cart".text.make(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //   CatalogHeader(),
          CartList().p32().expand(),
          Divider(),
          _CartTotal(),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartModel _cart = (VxState.store as MyStore).cart;

    return SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VxConsumer(
                notifications: {},
                mutations: {RemoveMutation},
                builder: (context, _, status) {
                  return "\$${_cart.totalPrice}"
                      .text
                      .xl5
                      .color(context.theme.accentColor)
                      .make();
                }),
            ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Buying not supported yet.')));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(context.theme.buttonColor),
                    ),
                    child: "buy".text.white.make())
                .w32(context)
          ],
        ));
  }
}

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;

    return _cart.items.isEmpty
        ? "Nothing to show...😔".text.xl4.makeCentered()
        : ListView.builder(
            itemCount: _cart.items.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.done),
              trailing: IconButton(
                onPressed: () => RemoveMutation(_cart.items[index]),
                icon: Icon(Icons.remove_circle_outline_outlined),
              ),
              title: _cart.items[index].name.text.make(),
            ),
          );
  }
}
