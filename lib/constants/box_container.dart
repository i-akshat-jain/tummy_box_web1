import 'package:flutter/material.dart';

class BoxContainers extends StatelessWidget {
  
  final Widget nextPage; 
  final String pageName;

  const BoxContainers({required this.nextPage , required this.pageName,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => nextPage,
                        ),
                      );
                    },
                    child: Text(pageName),
                  ),
                );
  }
}