import 'package:flutter/material.dart';
import 'package:bsit3bcrud/login_screen.dart';
import 'user_model.dart';
import 'api_service.dart';
import 'newsfeed_screen.dart';
import 'facebookpost.dart';

void main() {
  runApp(
    MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false, // ✅ Hide Debug Banner
    ),
  );
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<User>> futureUsers;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int? editingId;

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  // ✅ Refresh Users List
  void refreshUsers() {
    setState(() {
      futureUsers = ApiService.getUsers();
    });
  }

  // ✅ Handle Add or Update User
  void handleSave() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      showMessage("❗ Please fill in both fields.");
      return;
    }

    try {
      if (editingId == null) {
        // ✅ Add New User
        await ApiService.addUser(name, email);
        showMessage("✅ User added successfully!");
      } else {
        // ✅ Update Existing User
        await ApiService.updateUser(editingId!, name, email);
        showMessage("✅ User updated successfully!");
      }

      nameController.clear();
      emailController.clear();
      editingId = null;
      refreshUsers();
    } catch (e) {
      showMessage("❌ Error adding/updating user!");
    }
  }

  // ✅ Handle Edit Action
  void handleEdit(User user) {
    setState(() {
      nameController.text = user.name;
      emailController.text = user.email;
      editingId = user.id;
    });
  }

  // ✅ Handle Delete Action
  void handleDelete(int id) async {
    await ApiService.deleteUser(id);
    showMessage("✅ User deleted successfully!");
    refreshUsers();
  }

  // ✅ Handle Logout Action
  void handleLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // ✅ Show Snackbar Message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Facebook-like AppBar
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
            onPressed: handleLogout,
          ),
        ],
      ),

      // ✅ Body Content
      body: Column(
        children: [
          // ✅ Input Form - Styled like a Facebook Post Input
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "What's your name?",
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(height: 10),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Enter your email",
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Save Button - Styled like Facebook Post Button
          ElevatedButton.icon(
            onPressed: handleSave,
            icon: const Icon(Icons.add_circle, color: Colors.white),
            label: Text(
              editingId == null ? "Add User" : "Update User",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ✅ User List - Styled like Facebook Feed
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Users Found"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    User user = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => handleEdit(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => handleDelete(user.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ✅ Updated Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // ✅ Track active tab
        onTap: (index) {
          if (index == 0) {
            // Home - Stay on the current page
          } else if (index == 1) {
            // ✅ Navigate to FacebookPost when Friends is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FacebookPost()),
            );
          } else if (index == 2) {
            // ✅ Open NewsfeedScreen when Notifications is tapped
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
}
