import 'package:flutter/material.dart';

class ChangeUsernamePage extends StatelessWidget {
  final Map<String, dynamic> queueStatus;

  const ChangeUsernamePage({super.key, required this.queueStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            queueStatus['userState'] == 'IN_QUEUE'
                ? Column(
                    children: [
                      Text(
                        'Your position in the list:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        queueStatus['queuePosition'].toString(),
                        style: TextStyle(fontSize: 23),
                      ),
                    ],
                  )
                : Text(
                    "It's your turn!",
                    style: TextStyle(fontSize: 23),
                  ),
            SizedBox(height: 10),
            Text(
              'Choose your Tawkie name',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic to update the username
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
