import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Alarm extends StatefulWidget {
  const Alarm(
      {Key? key, required this.sendMessageA, required this.sendMessageK})
      : super(key: key);
  final Function sendMessageA;
  final Function sendMessageK;
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  Timer? _timer;
  bool _actionPerformed = false;
  TimeOfDay? _selectedTime;
  BluetoothConnection? connection;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_selectedTime != null) {
      final now = DateTime.now();
      final targetTime = DateTime(now.year, now.month, now.day,
          _selectedTime!.hour, _selectedTime!.minute);
      final difference = targetTime.difference(now);

      if (difference.isNegative) {
        // The selected time is already passed for today, add one day
        final tomorrow = now.add(const Duration(days: 1));
        final newTargetTime = DateTime(tomorrow.year, tomorrow.month,
            tomorrow.day, _selectedTime!.hour, _selectedTime!.minute);
        _timer = Timer(newTargetTime.difference(now), performAction);
      } else {
        _timer = Timer(difference, performAction);
      }
    }
  }

  void performAction() {
    setState(() {
      _actionPerformed = true;
    });
    widget.sendMessageA();
    widget.sendMessageK();

    // Perform your action here
    // ...
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _actionPerformed
          ? const Text('Action performed!')
          : _selectedTime == null
              ? ElevatedButton(
                  onPressed: () => selectTime(context),
                  child: const Text('Select Time'),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Target Time: ${_selectedTime!.format(context)}'),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
    );
  }
}
