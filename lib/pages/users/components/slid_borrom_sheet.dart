import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

Future showSheet(BuildContext context)=>showSlidingBottomSheet(
    context,
    builder: (context)=>const SlidingSheetDialog(
        cornerRadius: 20,
        avoidStatusBar: true,
        snapSpec: SnapSpec(
          snappings: [.4,.7],
        ),
        builder: buildSheet,
        headerBuilder: buildHeader
    )
);

  Widget buildSheet(context,state)=>Material(
    child: ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16),),
        const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16),),
        const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16),),
        const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16),),
        const Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16),),
      ],
    ),
  );

  Widget buildHeader(context,state)=>Material(
    child: Container(
      width: double.infinity,
      color: const Color(0xFF4AC0C0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 7),
          Container(
            height: 8,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
          ),
          const SizedBox(height: 7),
        ],
      ),
    ),
  );

