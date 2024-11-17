import 'package:dadding/pages/post/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        cursorColor: Colors.black,
        controller: _textController,
        onSubmitted: (value) {
          final searchQuery = _textController.text;
          Get.to(() => SearchPage(searchQuery: searchQuery));
          _textController.clear();
        },
        decoration: InputDecoration(
          hintText: '관심있는 내용을 검색해보세요!',
          hintStyle: _hintStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              final searchQuery = _textController.text;
              Get.to(() => SearchPage(searchQuery: searchQuery));
              _textController.clear();
            },
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