import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/user_provider.dart';


class DropDownMenuRow extends StatefulWidget {
  List<String> values;
  String? value;
  Function onChange;

  DropDownMenuRow(
      {Key? key,
      required this.values,
      required this.onChange,
        this.value})
      : super(key: key);

  @override
  State<DropDownMenuRow> createState() => _DropDownMenuRowState();
}

class _DropDownMenuRowState extends State<DropDownMenuRow> {
  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text('فئة'),
          SizedBox(width: 10,),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: widget.value,
                iconSize: 40,
                icon: const Icon(
                  Icons.filter_alt,
                  color: Color(0xFF00B0BD),
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
                  widget.value = val;
                });
                  Provider.of<UserProvider>(context, listen: false).filteringUser(val!);
                }),
          ),
        ],
      ),
    );
  }
}
