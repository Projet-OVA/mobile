import 'package:flutter/material.dart';

class ActionDart extends StatelessWidget {
  const ActionDart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('../../assets/images/profile.png'),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hintText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.bookmarks),
            onPressed: () {
            },
          ),

          const SizedBox(width: 12),

          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}
