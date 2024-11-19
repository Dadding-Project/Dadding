import 'package:dadding/api/PostApi.dart';
import 'package:dadding/api/UserApi.dart';
import 'package:dadding/util/Post.dart';
import 'package:dadding/util/User.dart' as custom;
import 'package:dadding/widgets/PostCard.dart';
import 'package:dadding/widgets/skeleton/PostListSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final String searchQuery;

  const SearchPage({
    super.key,
    required this.searchQuery,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _listPadding = EdgeInsets.symmetric(horizontal: 20);
  static const _cardPadding = EdgeInsets.only(bottom: 20);

  late Future<Map<String, dynamic>> _dataFuture;
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];

  Future<Map<String, dynamic>> fetchData() async {
    final posts = await fetchPosts();
    
    final userFutures = posts.map((post) => fetchUser(post.authorId)).toList();
    final users = await Future.wait(userFutures);

    return {
      'posts': posts,
      'user': users.isNotEmpty ? users.first : null,
    };
  }

  Future<List<Post>> fetchPosts() async {
    final api = await PostApi().getPosts();
    List<Post> posts = Post.fromJsonList(api);
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts.toList();
  }

  Future<custom.User> fetchUser(String authorId) async {
    final api = await UserApi().getUserById(authorId);
    custom.User user = custom.User.fromJson(api['data']);
    return user;
  }

  void _filterPosts(String query, List<Post> posts) {
    setState(() {
      if (query.isEmpty) {
        _filteredPosts = _allPosts;
      } else {
        _filteredPosts = _allPosts.where((post) {
          return post.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData().then((data) {
      _allPosts = data['posts'];
      _filterPosts(widget.searchQuery, _allPosts);
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 80,
        title: SearchBar(
          searchQuery: widget.searchQuery,
          onSearch: (query) {
            _filterPosts(query, _allPosts);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PostListSkeleton();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('데이터를 불러오지 못했습니다.'));
          } else {
            final user = snapshot.data!['user'] as custom.User;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 30),
                  child: Text(
                    '${_filteredPosts.length}개의 글이 있어요',
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: _listPadding,
                    itemCount: _filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = _filteredPosts[index];
                      return Padding(
                        padding: _cardPadding,
                        child: PostCard(
                          id: post.id,
                          title: post.title,
                          content: post.content,
                          tags: post.tags,
                          userId: user.id,
                          author: '${user.displayName.substring(0, 1)}**',
                          authorInfo:
                              '${_calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate))}세 / ${user.gender == 'male' ? '남' : '기타'}',
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
        },
      ),
    );
  }

  int _calculateAge(String birth) {
    DateTime birthDate = DateTime.parse(birth.replaceAll('.', '-'));
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class SearchBar extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearch;

  const SearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearch,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery);
  }

  static const _hintStyle = TextStyle(
    color: Color(0xFFCCCCCC),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSearch() {
    widget.onSearch(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 12.7,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: TextField(
        cursorColor: const Color(0xFF000000),
        controller: _textController,
        onSubmitted: (value) => _onSearch(),
        decoration: InputDecoration(
          hintText: '관심있는 내용을 검색해보세요!',
          hintStyle: _hintStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          suffixIcon: GestureDetector(
            onTap: _onSearch,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.search,
                size: 30,
                color: Color(0xFF3B6DFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}