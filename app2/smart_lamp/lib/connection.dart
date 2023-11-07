import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'device.dart';

class SelectBondedDevicePage extends StatefulWidget {
  final bool? checkAvailability;
  final Function? onCahtPage;

  const SelectBondedDevicePage(
      {super.key, this.checkAvailability = true, required this.onCahtPage});

  @override
  _SelectBondedDevicePageState createState() => _SelectBondedDevicePageState();
}

enum _DeviceAvailability {
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  final BluetoothDevice? device;
  final _DeviceAvailability? availability;
   int? rssi;

  _DeviceWithAvailability(this.device, this.availability)
      : super(address: "");
}





class _SelectBondedDevicePageState extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool? _isDiscovering;

  @override
  void initState() {
    super.initState();
    _isDiscovering = widget.checkAvailability!;
    if (_isDiscovering!) {
      _startDiscovery();
    }
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                  device,
                  widget.checkAvailability!
                      ? _DeviceAvailability.maybe
                      : _DeviceAvailability.yes),
            )
            .toList();
      });
    });
  }






  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var device = i.current;
          if (device.device == r.device) {
            device.availability = _DeviceAvailability.yes;
            device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription!.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }





  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map(
          (device) => BluetoothDeviceListEntry(
            device: device.device,
            // rssi: _device.rssi,
            // enabled: _device.availability == _DeviceAvailability.yes,
            onTap: () {
              widget.onCahtPage!(device.device);
            },
          ),
        )
        .toList();
    return ListView(
      children: list,
    );
  }
}
