import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String addType;
  final Function()? onPressed;
  const AddButton({Key? key, required this.addType, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add),
          Text('Add $addType'),
        ],
      ),
    );
  }
}
