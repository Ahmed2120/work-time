import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OsamaIbrahim extends StatelessWidget {
  const OsamaIbrahim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri osamaPhone = Uri.parse('tel:+201094209343');
    final Uri osamaWhats = Uri.parse('whatsapp://send?phone=+201094209343');
    final Uri osamaFacebook = Uri.parse('https://m.me/send?id=100010839528124&mibextid=ZbWKwL');

    return Wrap(
      children: [
        Text('أسامة إبراهيم',style: TextStyle(fontSize: 15,color: Colors.grey[500],)),
        SizedBox(width: 10),
        IconButton(
          onPressed: () async {
            await launchUrl(osamaWhats);
          },
          icon: Icon(FontAwesomeIcons.whatsapp,size: 20,),
          color: Colors.green,
        ),
        IconButton(
          onPressed: () async {
            await launchUrl(osamaFacebook);
          },
          icon: Icon(
            FontAwesomeIcons.facebookMessenger,
            size: 20,
            color: Color(0xC3A536FF),
          ),
        ),
        IconButton(
          onPressed: () async {
            await launchUrl(osamaPhone);
          },
          icon: Icon(
            FontAwesomeIcons.phone,
            size: 15,
          ),
          color: Colors.blue,
        ),
      ],
    );
  }
}
