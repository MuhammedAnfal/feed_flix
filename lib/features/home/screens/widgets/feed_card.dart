import 'package:feed_flix/features/home/domain/entities/feed_entity.dart';
import 'package:feed_flix/features/home/screens/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final FeedEntity feed;
  final int index;

  const FeedCard({super.key, required this.feed, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: feed.user.profilePicture != null
                  ? NetworkImage(feed.user.profilePicture!)
                  : null,
              child: feed.user.profilePicture == null ? const Icon(Icons.person) : null,
            ),
            title: Text(feed.user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Video Player
          VideoPlayerWidget(videoUrl: feed.video, thumbnailUrl: feed.image, index: index),

          // Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(feed.description, style: const TextStyle(fontSize: 14)),
          ),

          // Categories
          if (feed.categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Wrap(
                spacing: 8,
                children: feed.categories.map((category) {
                  return Chip(
                    label: Text(category.name, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
