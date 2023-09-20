import 'package:flutter/material.dart';
// breakfast_screen.dart


class BreakfastScreen extends StatelessWidget {
  final Map<String, dynamic> selectedMenuData;

  const BreakfastScreen({Key? key, required this.selectedMenuData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use selectedMenuData to display breakfast details
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakfast Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        // Display breakfast details using selectedMenuData
        child: Center(
          child: Text(
            selectedMenuData.toString(),
          ),
        ),
      ),
    );
  }
}
