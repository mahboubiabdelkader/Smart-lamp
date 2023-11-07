library send_messagee;

import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_lamp/alarm.dart';

import 'ledpage.dart';
import 'ledpage2.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ChatPage({
    Key? key,
    this.server,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  BluetoothConnection? connection;

  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;

  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this, initialIndex: 0);

    BluetoothConnection.toAddress(widget.server!.address).then((connection) {
      print('connected to device');
      connection = connection;

      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: const [
            Tab(
              text: "Led 1",
            ),
            Tab(
              text: "Led 2",
            ),
            Tab(
              text: "Alarm",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Align(
            alignment: Alignment.center,
            child: ledPage(
              sendMessageA: () => _sendMessage('1'),
              sendMessageK: () => _sendMessage('0'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ledPage2(
              sendMessageA: () => _sendMessage('a'),
              sendMessageK: () => _sendMessage('b'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Alarm(
              sendMessageA: () => _sendMessage('1'),
              sendMessageK: () => _sendMessage('a'),
            ),
          ),
        ],
      ),
    );
  }

  _sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state

      }
    }
  }
}
