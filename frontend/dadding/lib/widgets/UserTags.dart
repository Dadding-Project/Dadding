import 'package:dadding/api/PostApi.dart';
import 'package:dadding/util/Post.dart';
import 'package:dadding/widgets/UserTag.dart';
import 'package:dadding/widgets/skeleton/UserTagSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserTags extends StatelessWidget {
  const UserTags({super.key});

  Future<List<String>> getTags() {
    return PostApi().getPosts().then((value) {
      value = Post.fromJsonList(value);
      final tags = value.expand((post) => post.tags).toList();
      final tagCounts = <String, int>{};
      for (var tag in tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
      final sortedTags = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topTags = sortedTags.take(3).map((e) => e.key).toList();
      return topTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FutureBuilder<List<String>>(
          future: getTags(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const UserTagSkeleton();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No tags available');
            } else {
              final tags = snapshot.data!;
              return Row(
                children: tags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 6), 
                  child: UserTag(label: tag),
                )).toList(),
              );
            }
          },
        )
      ],
    );
  }
}