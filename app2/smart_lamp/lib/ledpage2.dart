import 'package:flutter/material.dart';

class ledPage2 extends StatefulWidget {
  const ledPage2(
      {Key? key, required this.sendMessageA, required this.sendMessageK})
      : super(key: key);
  final Function sendMessageA;
  final Function sendMessageK;

  @override
  _ledPageState createState() => _ledPageState();
}

class _ledPageState extends State<ledPage2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
        ),
        InkWell(
          onTap: () {
            widget.sendMessageA();
          },
          child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Text(
                "ON",
                style: TextStyle(color: Colors.grey[400], fontSize: 20),
              )),
        ),
        const SizedBox(
          height: 50,
        ),
        InkWell(
            onTap: () {
              widget.sendMessageK();
            },
            child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black,
                child: Text(
                  "OFF",
                  style: TextStyle(color: Colors.grey[400], fontSize: 20),
                ))),
      ],
    );
  }
}
