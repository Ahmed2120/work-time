import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/user_provider.dart';


class DropDownMenuRow extends StatefulWidget {
  List<String> values;
  Function onChange;

  DropDownMenuRow(
      {Key? key,
      required this.values,
      required this.onChange,})
      : super(key: key);

  @override
  State<DropDownMenuRow> createState() => _DropDownMenuRowState();
}

class _DropDownMenuRowState extends State<DropDownMenuRow> {


  String value = 'الكل';

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return Row(
      children: [
        const Text('الفئة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        const SizedBox(width: 10,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF533483),
              width: 1
            )
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: value,
                //iconSize: 40,
                icon: const Icon(
                  Icons.filter_alt,
                  color: Color(0xFFE94560),
                ),
                dropdownColor: Colors.white,
                alignment: Alignment.topRight,
                // isDense: true,
                // isExpanded: true,
                items: widget.values.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          color: Color(0xFF0F6671), fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (val) { setState(() {
                  value = val!;
                });
                  Provider.of<UserProvider>(context, listen: false).filteringUser(val!);
                }),
          ),
        ),
      ],
    );
  }
}
