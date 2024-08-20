import 'package:flutter/material.dart';

class ContentFilteringScreen extends StatefulWidget {
  @override
  _ContentFilteringScreenState createState() => _ContentFilteringScreenState();
}

class _ContentFilteringScreenState extends State<ContentFilteringScreen> {
  bool applyFiltering = true;
  Map<String, bool> categories = {
    "Chat rooms": true,
    "Dating websites": true,
    "E-Commerce": true,
    "Entertainment": true,
    "Gambling": true,
    "Games": true,
    "Hacking/ Illegal": true,
    "Hate or extremist": true,
    "Pornography": true,
    "Social Media": true,
    "Violent": true,
    "Blogs": true,
    "News": false,
    "Forums": false,
    "Streaming": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Filtering'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text('Apply Filtering'),
                subtitle: Text(
                    'Enable it to help filter the content on websites that your children access through.'),
                value: applyFiltering,
                onChanged: (bool value) {
                  setState(() {
                    applyFiltering = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Websites Blocker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Enable it to block access for certain categories of websites.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String key = categories.keys.elementAt(index);
                  return ListTile(
                    title: Text(key),
                    trailing: Switch(
                      value: categories[key]!,
                      onChanged: (bool value) {
                        setState(() {
                          categories[key] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  home: ContentFilteringScreen(),
));
