import 'package:dadding/api/CommentApi.dart';
import 'package:dadding/api/PostApi.dart';
import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/user/OtherUserPage.dart';
import 'package:dadding/util/Comment.dart';
import 'package:dadding/util/Post.dart';
import 'package:dadding/util/User.dart' as custom;
import 'package:dadding/widgets/CommentCard.dart';
import 'package:dadding/widgets/skeleton/CommentCardSkeleton.dart';
import 'package:dadding/widgets/skeleton/PostInnerPageSkeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class PostInnerPage extends StatefulWidget {
  final String postId;

  const PostInnerPage({super.key, required this.postId});

  @override
  _PostInnerPageState createState() => _PostInnerPageState();
}

class _PostInnerPageState extends State<PostInnerPage> {
  late Future<Map<String, dynamic>> _dataFuture;
  late Future<List<dynamic>> _commentsFuture;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
    _commentsFuture = fetchComments();
  }

  Future<List<dynamic>> fetchComments() async {
    return await CommentApi().getComments(widget.postId);
  }

  Future<Map<String, dynamic>> fetchCommentsWithUserData() async {
    final comments = await fetchComments();
    
    final commentUsersData = await Future.wait(
      comments.map((commentData) async {
        final comment = Comment.fromJson(commentData);
        final userData = await UserApi().getUserById(comment.userId);
        return {
          'comment': comment,
          'user': custom.User.fromJson(userData['data']),
        };
      }),
    );

    return {
      'comments': commentUsersData,
      'commentCount': comments.length,
    };
  }

  Future<Map<String, dynamic>> fetchData() async {
    final post = await fetchPost();
    final user = await fetchUser(post.authorId);
    return {'post': post, 'user': user};
  }

  Future<Post> fetchPost() async {
    final postData = await PostApi().getPostById(widget.postId);
    return Post.fromJson(postData);
  }

  Future<custom.User> fetchUser(String authorId) async {
    final userData = await UserApi().getUserById(authorId);
    return custom.User.fromJson(userData['data']);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return FutureBuilder(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PostInnerPageSkeleton();
            } else if (snapshot.hasError) {
              return Container();
            } else if (!snapshot.hasData) {
              return Container();
            }

            final post = snapshot.data!['post'] as Post;
            final user = snapshot.data!['user'] as custom.User;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: _buildAppBar(context, post),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                    ),
                    _buildPostSection(screenWidth, screenHeight, post, user),
                    SizedBox(height: screenHeight * 0.06),
                    _buildSeparator(),
                    SizedBox(height: screenHeight * 0.03),
                    _buildCommentSection(screenWidth, screenHeight, post),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(screenWidth, screenHeight),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Color(0xFFE8E8E9),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 14, right: 17, bottom: 30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F7FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        onSubmitted: (value) {
                          if (value.isEmpty) return;

                          CommentApi().createComment(widget.postId, value);
                          PostApi().updatePostCommentCount(widget.postId);
                          _textController.clear();
                          setState(() {
                            fetchData();
                          });
                        },
                        cursorColor: const Color(0xFF000000),
                        decoration: const InputDecoration(
                          hintText: '댓글을 작성해주세요.',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            fontSize: 18,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_textController.text.isEmpty) return;
                        
                        CommentApi().createComment(widget.postId, _textController.text);
                        PostApi().updatePostCommentCount(widget.postId);
                        _textController.clear();
                        setState(() {
                          fetchData();
                        });
                      },
                      child: SvgPicture.asset('assets/icons/send-btn.svg'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Post post) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '게시물',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        if (post.authorId == FirebaseAuth.instance.currentUser?.uid)
          IconButton(
            icon: SvgPicture.asset('assets/icons/more.svg'),
            onPressed: () {
              showMenu(
                context: context,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                menuPadding: const EdgeInsets.symmetric(horizontal: 10),
                position: const RelativeRect.fromLTRB(1, 100, 0, 0),
                items: [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      '게시물 수정',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      '게시물 삭제',
                      style: TextStyle(
                        color: Color(0xFFF30000),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 0) {
                  // Handle edit action
                } else if (value == 1) {
                  // Handle delete action
                }
              });
            },
          )
      ],
    );
  }

  Widget _buildPostSection(double screenWidth, double screenHeight, Post post, custom.User user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(screenWidth, user),
          SizedBox(height: screenHeight * 0.04),
          _buildPostTitle(post),
          SizedBox(height: screenHeight * 0.03),
          _buildPostContent(post),
          SizedBox(height: screenHeight * 0.03),
          post.images.isNotEmpty ? _buildPostImage(screenWidth, screenHeight) : Container(),
          SizedBox(height: screenHeight * 0.02),
          _buildPostDate(post),
        ],
      ),
    );
  }

  Widget _buildUserHeader(double screenWidth, custom.User user) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => OtherUserPage(userId: user.id));
          },
          child: CircleAvatar(
            radius: 21,
            backgroundImage: NetworkImage(user.profilePicture),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Text(
          '${user.displayName.substring(0, 1)}**',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: screenWidth * 0.01),
        Text(
          '${custom.User.calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate))}세 / ${user.gender == 'male' ? '남' : '기타'}',
          style: const TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPostTitle(Post post) {
    return Text(
      post.title,
      style: const TextStyle(
        fontSize: 22,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildPostContent(Post post) {
    return Text(
      post.content,
      style: const TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 16,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPostImage(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.4,
      decoration: ShapeDecoration(
        image: const DecorationImage(
          image: NetworkImage("https://via.placeholder.com/339x340"),
          fit: BoxFit.fill,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPostDate(Post post) {
    return Text(
      DateFormat('yyyy.MM.dd a hh:mm', 'ko').format(post.createdAt),
      style: const TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCommentSection(screenWidth, screenHeight, Post post) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCommentsWithUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                3,
                (index) => Column(
                  children: [
                    const CommentCardSkeleton(),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Container();
        } else if (!snapshot.hasData || snapshot.data!['comments'].isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '댓글 ${snapshot.data!['commentCount'] ?? 0}개',
                  style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Center(
                  child: Text(
                  '아직 댓글이 없습니다.',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final commentData = snapshot.data!['comments'];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '댓글 ${snapshot.data!['commentCount'] ?? 0}개',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ...commentData.map((data) {
                return Column(
                  children: [
                    CommentCard(
                      comment: data['comment'], 
                      user: data['user']
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: double.infinity,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 8,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x7FEBF0F7),
          ),
        ),
      ),
    );
  }
}