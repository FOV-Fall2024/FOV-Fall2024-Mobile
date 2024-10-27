import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [
    {
      "title": "Your monthly income has been sent",
      "subtext": "You received 12,500,000 VND for this month",
      "isRead": false
    },
    {
      "title": "System Maintenance Scheduled",
      "subtext": "Maintenance will take place from 10:00 PM - 12:00 AM",
      "isRead": false
    },
  ];

  void markAllAsRead() {
    setState(() {
      notifications = notifications.map((notification) {
        notification['isRead'] = true;
        return notification;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Notification"),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: Text(
              "Mark all as read",
              style: TextStyle(color: Colors.blue[300]),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(
              notification['isRead']
                  ? Icons.mark_email_read
                  : Icons.mark_email_unread,
              color: notification['isRead'] ? Colors.grey : Colors.blue,
            ),
            title: Text(notification['title']),
            subtitle: Text(notification['subtext']),
            tileColor: notification['isRead'] ? Colors.grey[200] : Colors.white,
          );
        },
      ),
    );
  }
}
