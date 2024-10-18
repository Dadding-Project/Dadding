import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF3B6DFF),
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
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(),
          SizedBox(height: 16),
          UserTags(),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: _textController,
          onSubmitted: (String value) {
            print('Search submitted: $value');
          },
          decoration: InputDecoration(
            hintText: '관심있는 내용을 검색해보세요!',
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: GestureDetector(
              onTap: () {
                print('Search icon tapped: ${_textController.text}');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: Color(0xFF3B6DFF),
                ),
              ),
            ),
          ),
        ),
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
      children: [
        UserTag(label: '아버지'),
        UserTag(label: '아빠'),
        UserTag(label: '38개월아빠'),
      ],
    );
  }
}

class UserTag extends StatelessWidget {
  final String label;

  const UserTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDFE7FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF3B6DFF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PostListSection extends StatelessWidget {
  const PostListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            '오늘의 인기있는 글이에요 📕',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: samplePosts.length,
            itemBuilder: (context, index) {
              final post = samplePosts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PostCard(
                  title: post.title,
                  content: post.content,
                  tags: post.tags,
                  author: post.author,
                  authorInfo: post.authorInfo,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String content;
  final List<String> tags;
  final String author;
  final String authorInfo;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
    required this.tags,
    required this.author,
    required this.authorInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: tags.map((tag) => UserTag(label: tag)).toList(),
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage("https://via.placeholder.com/34x34"),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                author,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                authorInfo,
                style: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Text(
                      '더보기',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Post {
  final String title;
  final String content;
  final List<String> tags;
  final String author;
  final String authorInfo;

  const Post({
    required this.title,
    required this.content,
    required this.tags,
    required this.author,
    required this.authorInfo,
  });
}

final List<Post> samplePosts = [
  const Post(
    title: '아들과 다양한 활동을 하고 싶습니다.',
    content: '아들과 정말 좋은 추억을 만들고 싶은데 무엇을 하는 것이 아들이 나중에 좋은 기억으로 될 수 있을까요?',
    tags: ['아빠', '아들과'],
    author: '낚**',
    authorInfo: '40대 / 남',
  ),
  const Post(
    title: '14살 아들과 어떤 이야기 하나요?',
    content: '14살 아들과 어떤 주제로 이야기를 해야 할지 잘 모르겠습니다. 보통 무슨 이야기하나요?',
    tags: ['아빠', '아들과'],
    author: '바**',
    authorInfo: '30대 / 남',
  ),
];