import 'package:flutter/material.dart';

class ParentProfileScreen extends StatefulWidget {
  final String parentEmail;
  final List<String> children;

  ParentProfileScreen({required this.parentEmail, required this.children});

  @override
  _ParentProfileScreenState createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  late TextEditingController _emailController;
  late List<TextEditingController> _childrenControllers;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.parentEmail);
    _childrenControllers = widget.children.map((child) => TextEditingController(text: child)).toList();
  }

  void _saveProfile() {
    // Add logic to save the profile information
    final updatedEmail = _emailController.text;
    final updatedChildren = _childrenControllers.map((controller) => controller.text).toList();

    // Update state or save to database
    print('Updated email: $updatedEmail');
    print('Updated children: $updatedChildren');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
  }

  void _addChild() {
    setState(() {
      _childrenControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Children',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._childrenControllers.map((controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.child_care),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addChild,
              child: Text('Add Child'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _childrenControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
