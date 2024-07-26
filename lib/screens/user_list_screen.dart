// lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';
import '../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService().fetchUsers();
  }

  void _logout() async {
    // Show confirmation dialog
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List',style: TextStyle(fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7, // Adjust this ratio to control item aspect
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return Card(
                  elevation: 5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: user.thumbnail != null
                            ? Image.network(
                          user.thumbnail!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.account_circle, size: 100.0),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(user.description),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Price: ${user.price}'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
