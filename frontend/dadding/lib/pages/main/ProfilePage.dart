import 'package:dadding/api/PostApi.dart';
import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/user/MyPage.dart';
import 'package:dadding/util/Post.dart';
import 'package:dadding/widgets/PostCard.dart';
import 'package:dadding/widgets/UserTags.dart';
import 'package:dadding/widgets/skeleton/ProfileSkeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dadding/util/User.dart' as custom;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _backgroundColor = Color(0xFF3B6DFF);
  
  late Future<Map<String, dynamic>> _dataFuture;

  Future<Map<String, dynamic>> fetchData() async {
    final postsFuture = fetchPosts();
    final userFuture = fetchUser();

    final results = await Future.wait([postsFuture, userFuture]);
    return {
      'posts': results[0],
      'user': results[1],
    };
  }

  Future<List<Post>> fetchPosts() async {
    final api = await PostApi().getPosts();
    List<Post> posts = Post.fromJsonList(api);
    posts = posts.where((post) => post.authorId == FirebaseAuth.instance.currentUser!.uid).toList();
    return posts;
  }

  Future<custom.User> fetchUser() async {
    final api = await UserApi().getUserById(FirebaseAuth.instance.currentUser!.uid);
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
        color: _backgroundColor,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProfileSkeleton();
            } else if (snapshot.hasError) {
              return Container();
            } else if (!snapshot.hasData) {
              return Container();
            }

            final user = snapshot.data!['user'] as custom.User;
            final posts = snapshot.data!['posts'] as List<Post>;

            return Column(
              children: [
                UserProfileHeader(user: user),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: PostListSection(posts: posts, user: user),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  static const _padding = EdgeInsets.all(20);
  final custom.User user;
  
  const UserProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfo(user: user),
          const SizedBox(height: 13),
          const UserTags(),
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

  final custom.User user;

  const UserInfo({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final age = custom.User.calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate));
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        Get.to(() => const MyPage()),
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundImage: NetworkImage(user.profilePicture),
          ),
          const SizedBox(width: 19),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName, style: _nameStyle),
                const Divider(color: Colors.white, thickness: 0.5),
                Text('$age세 / ${user.gender == 'male' ? '남' : '기타'}', 
                  style: _infoStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostListSection extends StatelessWidget {
  final List<Post> posts;
  final custom.User user;
  
  static const _titleStyle = TextStyle(
    fontSize: 22,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
  );

  const PostListSection({
    super.key, 
    required this.posts,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: const Text('내가 올린 글 📕', style: _titleStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: EdgeInsets.only(bottom: padding),
                child: PostCard(
                  id: post.id,
                  title: post.title,
                  content: post.content,
                  tags: post.tags,
                  userId: user.id,
                  author: user.displayName,
                  authorInfo: "${custom.User.calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate))}세 / ${user.gender == 'male' ? '남' : '기타'}",
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