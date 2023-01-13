import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  late final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  var select = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            selected: select,
            selectedTileColor: Colors.white10,
            title: Text('${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy, hh:mm:ss')
                .format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                  select = !select;
                });
              },
            ),
          ),
          if (expanded)
            Column(
              children: [
                Divider(color: Colors.black),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: min(widget.order.products.length * 20 + 10, 180),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListView(
                    children: widget.order.products.map((prod) {
                      return SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 5),
                              child: Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 5),
                              child: Text(
                                '${prod.quantity} x ${prod.price}= ${(prod.quantity) * (prod.price)}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
