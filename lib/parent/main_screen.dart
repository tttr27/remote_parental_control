import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './userProfile/userProfile.dart';
import './location.dart';
import 'timeManagement.dart';
import './filter.dart';

class ParentMainScreen extends StatefulWidget {
  @override
  _ParentMainScreenState createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  List<String> _children = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      // Fetch additional user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        setState(() {
          _children = List<String>.from(userDoc['children'] ?? []);
        });
      }
    }
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ParentProfileScreen(parentEmail: _currentUser?.email ?? 'Unknown', children: _children)),
    );
  }

  void _navigateToSetTimeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetTimeLimitScreen()),
    );
  }

  void _navigateToFilterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContentFilteringScreen()),
    );
  }

  void _navigateToMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );
  }

  void _onChildChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Open settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (currentIndex > 0) {
                      _onChildChanged(currentIndex - 1);
                    }
                  },
                ),
                UserIcon(name: _children.isNotEmpty ? _children[currentIndex] : 'No Children'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (currentIndex < _children.length - 1) {
                      _onChildChanged(currentIndex + 1);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 60),
            Center(
              child: Column(
                children: [
                  Text(
                    _children.isNotEmpty
                        ? 'The Screen Time Spent by ${_children[currentIndex]}'
                        : 'No Child Data Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    value: 0.5, // Example value, should be dynamic
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '30 mins', // Example value, should be dynamic
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 170),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _navigateToSetTimeScreen,
                  icon: Icon(Icons.access_time),
                  label: Text('Set Time'),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToFilterScreen,
                  icon: Icon(Icons.filter_list),
                  label: Text('Filter'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '3', // Example notification count
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          if (index == 2) {
            _navigateToMapScreen();
          } else if (index == 3) {
            _navigateToProfileScreen();
          }
        },
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  final String name;

  UserIcon({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(Icons.person),
        ),
        SizedBox(height: 8),
        Text(name),
      ],
    );
  }
}
