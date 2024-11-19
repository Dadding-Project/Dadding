import 'package:dadding/api/PostApi.dart';
import 'package:dadding/api/UserApi.dart';
import 'package:dadding/util/Post.dart';
import 'package:dadding/widgets/PostCard.dart';
import 'package:dadding/widgets/UserTags.dart';
import 'package:dadding/widgets/skeleton/PostListSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:dadding/widgets/SearchBar.dart' as custom;
import 'package:dadding/util/User.dart' as custom;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _dataFuture;

  Future<Map<String, dynamic>> fetchData() async {
    final posts = await fetchPosts();
    
    final userFutures = posts.map((post) => fetchUser(post.authorId)).toList();
    final users = await Future.wait(userFutures);
    
    final postsWithUsers = Map.fromIterables(
      posts.map((post) => post.id),
      users,
    );

    return {
      'posts': posts,
      'postsWithUsers': postsWithUsers,
    };
  }

  Future<List<Post>> fetchPosts() async {
    final api = await PostApi().getPosts();
    List<Post> posts = Post.fromJsonList(api);
    posts.sort((a, b) => b.commentCount.compareTo(a.commentCount));
    return posts.take(2).toList();
  }

  Future<custom.User> fetchUser(String authorId) async {
    final api = await UserApi().getUserById(authorId);
    custom.User user = custom.User.fromJson(api['data']);
    return user;
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

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
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _dataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const PostListSkeleton();
                    } else if (snapshot.hasError) {
                      return Container();
                    } else if (!snapshot.hasData) {
                      return Container();
                    } else {
                      final posts = snapshot.data!['posts'] as List<Post>;
                      final postsWithUsers = snapshot.data!['postsWithUsers'] as Map<String, custom.User>;
                      return PostListSection(
                        posts: posts,
                        postsWithUsers: postsWithUsers,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostListSection extends StatelessWidget {
  final List<Post> posts;
  final Map<String, custom.User> postsWithUsers;

  static const _titleStyle = TextStyle(
    fontSize: 22,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
  );

  const PostListSection({
    super.key, 
    required this.posts,
    required this.postsWithUsers,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;

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
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final user = postsWithUsers[post.id]!;
              return Padding(
                padding: EdgeInsets.only(bottom: padding),
                child: PostCard(
                  id: post.id,
                  title: post.title,
                  content: post.content,
                  tags: post.tags,
                  userId: user.id,
                  author: '${user.displayName.substring(0, 1)}**',
                  authorInfo: '${custom.User.calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate))}세 / ${user.gender == 'male' ? '남' : '기타'}',
                  commentCount: post.commentCount,
                  imageUrl: user.profilePicture,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

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