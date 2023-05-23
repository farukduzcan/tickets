import 'package:flutter/material.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

class BottomSheetArea extends StatelessWidget {
  final String bottomsheettitle;
  final Widget child;
  const BottomSheetArea({
    super.key,
    required this.widget,
    required this.bottomsheettitle,
    required this.child,
  });

  final TicketDetailsBody widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Stack(
              children: [
                Center(
                  child: Divider(
                    color: Colors.black.withOpacity(0.70),
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.4,
                    endIndent: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Text(
            bottomsheettitle,
            style: const TextStyle(color: Colors.black),
          ),
          child,
        ],
      ),
    );
  }
}
