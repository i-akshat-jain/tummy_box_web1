import 'home_vm.dart'; 
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


class HomeView extends StatefulWidget {
  final Function logoutCallback;

  const HomeView({required this.logoutCallback, Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double leftPadding = 16.0;
  double rightPadding = 16.0;

  @override
  void initState() {
    super.initState();
    final HomeViewModel _viewModel = HomeViewModel(loginCallback: (){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.92,
            color: Colors.blue, // Customize the color as needed
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRowWithWindows(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithWindows(context) {
    return Row(
      children: [
        _buildWindow(0, context),
        _buildWindow(1, context),
        _buildWindow(2, context),
      ],
    );
  }

  Widget _buildWindow(int windowIndex, BuildContext context) {
    double leftPadding = 16.0;
    double rightPadding = 16.0;

    return Expanded(
      child: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final delta = details.delta.dx;
            if (delta.isNegative) {
              leftPadding -= delta;
            } else {
              rightPadding += delta;
            }

            // Ensure padding values don't go below a certain limit
            leftPadding = leftPadding.clamp(0.0, double.infinity);
            rightPadding = rightPadding.clamp(0.0, double.infinity);

            // Rebuild the widget
            setState(() {});
          },
          // child: StreamBuilder<QuerySnapshot>(
          //   stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return CircularProgressIndicator(); // Show a loading indicator
          //     }

          //     if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     }

          //     final items = snapshot.data!.docs; // List of documents

              child: Container(
                height: MediaQuery.of(context).size.height * 0.92,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.only(
                  left: leftPadding,
                  right: rightPadding,
                  top: 16.0,
                  bottom: 16.0,
                ),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Text(
                      'Row , Window $windowIndex',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [ 
                        // final data = item.data() as Map<String, dynamic>;
                        // return ListTile(
                        //   title: Text(data['itemName']),
                        //   subtitle: Text(data['itemDescription']),
                        // );
                      ],
                    ),
                  ],
                ),
              ),
          ),
          ),
        );
  }
      // ),
    // );
  
}