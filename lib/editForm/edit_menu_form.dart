import 'package:flutter/material.dart';

class EditItemDialog extends StatefulWidget {
  final String initialName;
  final double initialPrice;
  final Function(String, double) onSave;

  EditItemDialog({
    required this.initialName,
    required this.initialPrice,
    required this.onSave,
  });

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _priceController =
        TextEditingController(text: widget.initialPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Item Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newName = _nameController.text;
            double newPrice = double.tryParse(_priceController.text) ?? 0.0;
            widget.onSave( newName, newPrice);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

// Update the MenuItemsList widget to include EditItemDialog.
