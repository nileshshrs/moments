import 'package:flutter/material.dart';

class CreatePostBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'Create a Post',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Text Input for the Post
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Post Button
          ElevatedButton(
            onPressed: () {
              print('Post created!');
              Navigator.pop(context); // Close the bottom sheet
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
