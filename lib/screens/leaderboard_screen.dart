import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('loginCount', descending: true) // Sort by login count (higher first)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          if (users.isEmpty) {
            return const Center(child: Text("No leaderboard data available."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Text("#${index + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                title: Text(user['username'] ?? 'Unknown User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Login Count: ${user['loginCount'] ?? 0}", style: TextStyle(fontSize: 16)),
                trailing: Icon(Icons.star, color: Colors.amber),
              );
            },
          );
        },
      ),
    );
  }
}
