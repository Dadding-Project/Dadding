import 'package:dadding/widgets/PostCard.dart';
import 'package:dadding/widgets/UserTag.dart';
import 'package:flutter/material.dart';

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
    author: '임정우',
    authorInfo: '40대 / 남',
    images: ['url1', 'url2'],
  ),
  const Post(
    title: '14살 아들과 어떤 이야기 하나요?',
    content: '14살 아들과 어떤 주제로 이야기를 해야 할지 잘 모르겠습니다. 보통 무슨 이야기하나요?',
    tags: ['아빠', '아들과'],
    author: '임정우',
    authorInfo: '40대 / 남',
    images: ['url1', 'url2'],
  ),
];

class ProfilePage extends StatelessWidget {
  static const _backgroundColor = Color(0xFF3B6DFF);
  
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _backgroundColor,
        child: Column(
          children: [
            const UserProfileHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const PostListSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  static const _padding = EdgeInsets.all(20);
  
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfo(),
          SizedBox(height: 13),
          UserTags(),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  static const _nameStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );
  
  static const _infoStyle = TextStyle(
    color: Color(0xFFDFDFDF),
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
  );

  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
      },
      child: const Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundImage: NetworkImage("https://via.placeholder.com/84x84"),
          ),
          SizedBox(width: 19),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('임정우', style: _nameStyle),
                Divider(color: Colors.white, thickness: 0.5),
                Text('40대 / 남', style: _infoStyle),
              ],
            ),
          ),
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
        UserTag(label: '사춘기 애 아빠'),
      ],
    );
  }
}

class PostListSection extends StatelessWidget {
  static const _titleStyle = TextStyle(
    fontSize: 22,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
  );
  
  static const _padding = EdgeInsets.all(20);
  static const _listPadding = EdgeInsets.symmetric(horizontal: 20);
  static const _cardPadding = EdgeInsets.only(bottom: 20);

  const PostListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: _padding,
          child: Text('내가 올린 글 📕', style: _titleStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: _listPadding,
            itemCount: samplePosts.length,
            itemBuilder: (context, index) {
              final post = samplePosts[index];
              return Padding(
                padding: _cardPadding,
                child: PostCard(
                  title: post.title,
                  content: post.content,
                  tags: post.tags,
                  author: post.author,
                  authorInfo: post.authorInfo,
                  images: post.images
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}