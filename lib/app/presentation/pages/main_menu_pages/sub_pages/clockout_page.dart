import 'package:flutter/material.dart';

class ClockoutPage extends StatefulWidget {
  @override
  _ClockoutPageState createState() => _ClockoutPageState();
}

class _ClockoutPageState extends State<ClockoutPage> {
  final TextEditingController _reasonController = TextEditingController();

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to submit your reason?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reasonController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reason submitted successfully!')),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ask manager to leave early",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: "Input your reason",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showConfirmationDialog,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
