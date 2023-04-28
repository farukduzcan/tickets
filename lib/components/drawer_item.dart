import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String title;
  final Function press;
  const DrawerItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.press,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.white,
        shape: const StadiumBorder(),
        leading: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        onTap: () {
          press();
        },
      ),
    );
  }
}
