import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../components/constant.dart';
import '../../../../purchase/purchase_app.dart';

class PurchaseDrawer extends StatelessWidget {
  const PurchaseDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.cartShopping,size: 25,color:Color(0xFFE94560)),
        trailing: Icon(FontAwesomeIcons.chevronRight),
        title:Text('شراء التطبيق',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
        onTap: (){
          push(screen: PurchaseApp(), context: context);},
      ),
    );
  }
}
