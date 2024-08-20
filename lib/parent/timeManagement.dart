import 'package:flutter/material.dart';

class SetTimeLimitScreen extends StatefulWidget {
  @override
  _SetTimeLimitScreenState createState() => _SetTimeLimitScreenState();
}

class _SetTimeLimitScreenState extends State<SetTimeLimitScreen> {
  final List<Map<String, String>> timeLimits = [
    {"day": "Monday", "time": "30 min"},
    {"day": "Tuesday", "time": "30 min"},
    {"day": "Wednesday", "time": "30 min"},
    {"day": "Thursday", "time": "30 min"},
    {"day": "Friday", "time": "1 hr"},
    {"day": "Saturday", "time": "2 hr 30 min"},
    {"day": "Sunday", "time": "2 hr"},
  ];

  void _editTimeLimit(int index) {
    TextEditingController controller = TextEditingController();
    controller.text = _extractMinutes(timeLimits[index]["time"]!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Time Limit for ${timeLimits[index]["day"]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter time limit in minutes',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    timeLimits[index]["time"] = _convertToReadableFormat(int.parse(controller.text));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _extractMinutes(String time) {
    if (time.contains('hr')) {
      List<String> parts = time.split(' ');
      int hours = int.parse(parts[0]);
      int minutes = (parts.length > 2) ? int.parse(parts[2]) : 0;
      return (hours * 60 + minutes).toString();
    } else {
      return time.split(' ')[0];
    }
  }

  String _convertToReadableFormat(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours hr';
      if (remainingMinutes > 0) {
        formattedTime += ' $remainingMinutes min';
      }
    } else {
      formattedTime = '$remainingMinutes min';
    }
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Screen Time Limit'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: timeLimits.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  timeLimits[index]["day"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeLimits[index]["time"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editTimeLimit(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
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
  home: SetTimeLimitScreen(),
));
