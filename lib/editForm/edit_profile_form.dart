import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialphoto_url;
  final String initialGender;
  final Function(String, String, String)
      onSave; // Add email and phone number parameters

  EditProfileDialog({
    required this.initialName,
    required this.initialphoto_url,
    required this.initialGender,
    required this.onSave,
  });

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _photo_urlController; // Add email controller
  late TextEditingController _genderController; // Add phone number controller

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _photo_urlController = TextEditingController(
        text: widget.initialphoto_url); // Initialize email controller
    _genderController = TextEditingController(
        text: widget.initialGender); // Initialize phone number controller
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
            controller: _photo_urlController,
            decoration: InputDecoration(labelText: 'Email'), // Add email field
          ),
          TextField(
            controller: _genderController,
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
            String newEmail = _photo_urlController.text; // Get email input
            String newPhoneNumber =
                _genderController.text; // Get phone number input
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
    _photo_urlController.dispose(); // Dispose of email controller
    _genderController.dispose(); // Dispose of phone number controller
    super.dispose();
  }
}
