import 'package:flutter/material.dart';

class EditUserDialog extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhoneNumber;
  final Function(String, String, String)
      onSave; // Add email and phone number parameters

  EditUserDialog({
    required this.initialName,
    required this.initialEmail,
    required this.initialPhoneNumber,
    required this.onSave,
  });

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController; // Add email controller
  late TextEditingController
      _phoneNumberController; // Add phone number controller

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(
        text: widget.initialEmail); // Initialize email controller
    _phoneNumberController = TextEditingController(
        text: widget.initialPhoneNumber); // Initialize phone number controller
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'), // Add email field
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
                labelText: 'Phone Number'), // Add phone number field
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
            String newEmail = _emailController.text; // Get email input
            String newPhoneNumber =
                _phoneNumberController.text; // Get phone number input
            widget.onSave(newName, newEmail,
                newPhoneNumber); // Call the onSave function with all inputs
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
    _emailController.dispose(); // Dispose of email controller
    _phoneNumberController.dispose(); // Dispose of phone number controller
    super.dispose();
  }
}
