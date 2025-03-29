import 'package:flutter/material.dart';
import 'facebookpost.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      "user": "John Reynolds",
      "date": "March 14, 2025",
      "message": "liked your post.",
      "image": "assets/images/1.png",
      "read": false
    },
    {
      "user": "Samantha Lee",
      "date": "March 13, 2025",
      "message": "commented: 'Awesome post! 🔥'",
      "image": "assets/images/2.png",
      "read": false
    },
    {
      "user": "Michael Carter",
      "date": "March 12, 2025",
      "message": "shared your post.",
      "image": "assets/images/3.png",
      "read": true
    },
    {
      "user": "Daniel Thompson",
      "date": "March 11, 2025",
      "message": "mentioned you in a comment.",
      "image": "assets/images/4.png",
      "read": true
    },
    {
      "user": "James Walker",
      "date": "March 10, 2025",
      "message": "reacted ❤️ to your post.",
      "image": "assets/images/5.png",
      "read": true
    },
  ];

  void _onMenuSelected(int index, String action) {
    setState(() {
      if (action == 'delete') {
        notifications.removeAt(index);
      } else if (action == 'read') {
        notifications[index]["read"] = true;
      }
    });
  }

  void _markAsRead(int index) {
    setState(() {
      notifications[index]["read"] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Updated AppBar without Notification Icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.facebook, color: Colors.blue, size: 30),
            SizedBox(width: 10),
            Text(
              "FLUTTER CRUD",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // ✅ Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ],
      ),

      // ✅ Main Body with Notifications
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Today" Section with Three-Dot Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'clear') {
                      setState(() {
                        notifications.clear();
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'clear', child: Text('Clear All')),
                  ],
                  child: const Icon(Icons.more_vert), // Three dots for "Today" menu
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationTile(notification, index);
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar - Reused from main.dart
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // ✅ Set active tab to Notifications
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // ✅ Go back to Home
          } else if (index == 1) {
            // ✅ Navigate to FacebookPost
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FacebookPost()),
            );
          } else if (index == 2) {
            // ✅ Stay on NewsfeedScreen
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Friends"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification, int index) {
    return GestureDetector(
      onTap: () => _markAsRead(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: notification["read"] ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(notification["image"]),
              radius: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                            children: [
                              TextSpan(
                                text: notification["user"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " ${notification["message"]}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (action) => _onMenuSelected(index, action),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'read', child: Text('Mark as Read')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                        child: const Icon(Icons.more_horiz, size: 24), // Three dots aligned in middle
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        notification["date"],
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      if (!notification["read"])
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.circle, size: 8, color: Colors.blue),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
