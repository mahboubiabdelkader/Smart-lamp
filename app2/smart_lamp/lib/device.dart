import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  const BluetoothDeviceListEntry(
      {Key? key, required this.onTap, required this.device})
      : super(key: key);
  final VoidCallback onTap;
  final BluetoothDevice? device;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.devices),
      title: Text(device!.name ?? "unknown device"),
      subtitle: Text(device!.address.toString()),
      trailing: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.black,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 5,
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  'connect',
                  style: TextStyle(color: Colors.grey[400]),
                )),
          ),
        ),
      ),
    );
  }
}
