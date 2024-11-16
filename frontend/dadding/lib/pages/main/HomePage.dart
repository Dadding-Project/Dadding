import 'package:dadding/widgets/PostCard.dart';
import 'package:dadding/widgets/UserTag.dart';
import 'package:flutter/material.dart';
import 'package:dadding/widgets/SearchBar.dart' as custom;

class Post {
  final String title;
  final String content;
  final List<String> tags;
  final String author;
  final String authorInfo;
  final List<String> images;

  const Post({
    required this.title,
    required this.content,
    required this.tags,
    required this.author,
    required this.authorInfo,
    required this.images,
  });
}

final List<Post> samplePosts = [
  const Post(
    title: '아들과 다양한 활동을 하고 싶습니다.',
    content: '아들과 정말 좋은 추억을 만들고 싶은데 무엇을 하는 것이 아들이 나중에 좋은 기억으로 될 수 있을까요?',
    tags: ['아빠', '아들과'],
    author: '낚**',
    authorInfo: '40대 / 남',
    images: ['url1', 'url2'],
  ),
  const Post(
    title: '14살 아들과 어떤 이야기 하나요?',
    content: '14살 아들과 어떤 주제로 이야기를 해야 할지 잘 모르겠습니다. 보통 무슨 이야기하나요?',
    tags: ['아빠', '아들과'],
    author: '바**',
    authorInfo: '30대 / 남',
    images: ['url1', 'url2'],
  ),
];

List<Post> searchPosts(String query) {
  if (query.isEmpty) return samplePosts;
  
  final searchLower = query.toLowerCase();
  return samplePosts.where((post) {
    return post.title.toLowerCase().contains(searchLower) || 
           post.content.toLowerCase().contains(searchLower);
  }).toList();
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF3B6DFF),
        child: Column(
          children: [
            UserProfileHeader(onSearch: _updateSearchQuery),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: PostListSection(searchQuery: _searchQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class UserProfileHeader extends StatelessWidget {
  final Function(String) onSearch;

  const UserProfileHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          custom.SearchBar(),
          SizedBox(height: 16),
          UserTags(),
        ],
      ),
    );
  }
}
class UserTags extends StatelessWidget {
  const UserTags({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        UserTag(label: '아버지'),
        UserTag(label: '아빠'),
        UserTag(label: '38개월아빠'),
      ],
    );
  }
}
class PostListSection extends StatelessWidget {
  final String searchQuery;
  static const _titleStyle = TextStyle(
    fontSize: 22,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
  );

  const PostListSection({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;
    final filteredPosts = searchPosts(searchQuery);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: const Text('오늘의 인기있는 글이에요 📕', style: _titleStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return Padding(
                padding: EdgeInsets.only(bottom: padding),
                child: PostCard(
                  title: post.title,
                  content: post.content,
                  tags: post.tags,
                  author: post.author,
                  authorInfo: post.authorInfo,
                  images: post.images,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}