import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AhmedAshraf extends StatelessWidget {
  const AhmedAshraf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Uri ahmedPhone = Uri.parse('tel:+201028038124');
    final Uri ahmedWhats = Uri.parse('whatsapp://send?phone=+201028038124');
    final Uri ahmedFacebook = Uri.parse('https://m.me/send?id=100007888419142&mibextid=ZbWKwL');

    return Wrap(
      children: [
        Text('أحمد أشرف',style: TextStyle(fontSize: 15,color: Colors.grey[500],)),
        SizedBox(width: 20),
        IconButton(
          onPressed: () async {
            await launchUrl(ahmedWhats);
          },
          icon: Icon(FontAwesomeIcons.whatsapp,size: 20,),
          color: Colors.green,
        ),
        IconButton(
          onPressed: () async {
            await launchUrl(ahmedFacebook);
          },
          icon: Icon(
            FontAwesomeIcons.facebookMessenger,
            size: 20,
            color: Color(0xC3A536FF),
          ),
        ),
        IconButton(
          onPressed: () async {
            await launchUrl(ahmedPhone);
          },
          icon: Icon(
            FontAwesomeIcons.phone,
            size: 15,
          ),
          color: Colors.blue,
        )
      ],
    );
  }
}
