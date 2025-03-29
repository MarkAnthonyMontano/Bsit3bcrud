import 'package:flutter/material.dart';
import 'newsfeed_screen.dart';
import 'login_screen.dart';
import 'main.dart';

class FacebookPost extends StatefulWidget {
  const FacebookPost({super.key});

  @override
  _FacebookPostState createState() => _FacebookPostState();
}

class _FacebookPostState extends State<FacebookPost> {
  final List<String> reactions = ["👍", "❤️", "😂", "😮", "😢", "😡", "🥰"];
  String selectedFilter = "Most Relevant";

  final List<Map<String, dynamic>> posts = [
    {
      "name": "Mark Anthony P. Montaño",
      "date": "March 14, 2025",
      "caption":
          "Hello, I'm Mark Anthony P. Montaño, a 3rd-year IT student, 21 years old.",
      "hashtag": "#KayatoLateGame",
      "profileImage": "assets/images/FacebookImage.jpg",
      "postImage": "assets/images/FacebookImage.jpg",
      "likes": "3,570",
      "comments": " 97 Comments",
      "shares": "53 Shares",
      "commentSection": 1,
      "showReactions": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Modified AppBar without Notifications
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
              // ✅ Logout to LoginScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      // ✅ Facebook Post Body
      body: SingleChildScrollView(
        child: Column(
          children: posts
              .asMap()
              .entries
              .map((entry) => _buildFacebookPost(entry.value, entry.key))
              .toList(),
        ),
      ),

      // ✅ Bottom Navigation Bar from main.dart
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // ✅ Set Friends (FacebookPost) as the active tab
        onTap: (index) {
          if (index == 0) {
            // ✅ Navigate to Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserScreen()),
            );
          } else if (index == 1) {
            // ✅ Stay on FacebookPost
          } else if (index == 2) {
            // ✅ Navigate to NewsfeedScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsfeedScreen()),
            );
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

  // ✅ Build Individual Facebook Post
  Widget _buildFacebookPost(Map<String, dynamic> post, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: _profileImage(post["profileImage"]),
          title: Row(
            children: [
              Text(post["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              const Icon(Icons.verified, color: Color(0xFF1877F2), size: 16),
            ],
          ),
          subtitle: Text(post["date"], style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.more_horiz),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(post["caption"]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Text(post["hashtag"], style: const TextStyle(color: Colors.blue)),
        ),
        _postImage(post["postImage"]),
        _postStats(post),
        const Divider(),
        _reactionButtons(index),
        const Divider(),
        _buildCommentSection(post["profileImage"]),
        _viewCommentsDropdown(),
      ],
    );
  }

  Widget _profileImage(String imagePath) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1877F2), width: 2),
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(imagePath),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _postImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: 375,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _postStats(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("👍❤️🥰", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 5),
              Text(post["likes"]),
            ],
          ),
          Text("${post["comments"]} • ${post["shares"]}"),
        ],
      ),
    );
  }

  Widget _reactionButtons(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (posts[index]["showReactions"])
          Positioned(bottom: 40, child: _reactionPopup()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onLongPress: () {
                setState(() {
                  posts[index]["showReactions"] = true;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  posts[index]["showReactions"] = false;
                });
              },
              child: _actionButton(Icons.thumb_up_alt_outlined, "Like"),
            ),
            _actionButton(Icons.insert_comment, "Comment"),
            
            _actionButton(Icons.share, "Share"),
          ],
        ),
      ],
    );
  }

  Widget _reactionPopup() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions
            .map(
              (emoji) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCommentSection(String profileImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(profileImage),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.grey[800]),
      label: Text(label, style: TextStyle(color: Colors.grey[800])),
    );
  }

  Widget _viewCommentsDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("View Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: selectedFilter,
            icon: const Icon(Icons.arrow_drop_down),
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            items: const [
              DropdownMenuItem(value: "Most Relevant", child: Text("Most Relevant")),
              DropdownMenuItem(value: "All Comments", child: Text("All Comments")),
            ],
          ),
        ],
      ),
    );
  }
}
