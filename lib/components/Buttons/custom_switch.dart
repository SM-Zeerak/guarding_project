import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool) onChanged;

  CustomSwitch({required this.isActive, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive; // Initialize state from widget
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 20,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey, // Active vs Inactive color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {
            // Toggle state when tapped
            setState(() {
              isActive = !isActive;
            });
            // Notify the parent to update Firestore (or other state)
            widget.onChanged(isActive);
          },
          child: AnimatedAlign(
            duration: Duration(milliseconds: 200), // Smooth transition
            alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16, // The thumb's size
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
