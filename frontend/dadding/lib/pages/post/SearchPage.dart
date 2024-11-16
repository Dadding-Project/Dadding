import 'package:dadding/widgets/PostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

class SearchPage extends StatefulWidget {
  final String searchQuery;

  const SearchPage({
    super.key,
    required this.searchQuery,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _listPadding = EdgeInsets.symmetric(horizontal: 20);
  static const _cardPadding = EdgeInsets.only(bottom: 20);

  List<Post> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _filterPosts(widget.searchQuery);
  }

  void _filterPosts(String query) {
    setState(() {
      _filteredPosts = samplePosts.where((post) {
        return post.title.contains(query) ||
               post.content.contains(query) ||
               post.tags.any((tag) => tag.contains(query));
      }).toList();
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
            _filterPosts(query);
          },
        ),
      ),
      body: Column(
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
          const SizedBox(height: 12,),
          Expanded(
            child: ListView.builder(
              padding: _listPadding,
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                final post = _filteredPosts[index];
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
      )
    );
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
