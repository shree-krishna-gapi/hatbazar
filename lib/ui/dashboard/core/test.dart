import 'package:flutter/material.dart';
import 'package:hatbazar/utils/utils.dart';
class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sdfsd'),
      ),
      body: Container(
        height: 500,
        color: Colors.pink,
        child: Text('${Utils.getString(
            context, 'home__drawer_menu_latest_product')}'),
      )
    );
  }
}
