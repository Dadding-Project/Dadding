import 'package:dadding/api/PostApi.dart';
import 'package:dadding/pages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _categories = [];

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
           _categories.isNotEmpty &&
           _contentController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateFormState);
    _contentController.addListener(_updateFormState);
  }

  void _updateFormState() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(),
              const SizedBox(height: 24),
              _buildCategorySection(),
              const SizedBox(height: 24),
              _buildContentSection(),
              const SizedBox(height: 24),
              _buildPhotoSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '글쓰기',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '제목',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          cursorColor: Colors.black,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
          decoration: const InputDecoration(
            hintText: '제목을 입력해주세요.',
            hintStyle: TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
            contentPadding: EdgeInsets.only(top: 20),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFCCCCCC)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFCCCCCC)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            '최대 30자',
            style: TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카테고리',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: _buildBorderDecoration(),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    '카테고리를 입력해주세요.',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            _buildCircleButton(),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ..._categories.map((category) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _buildCategoryChip(category),
            )),
          ],
        )
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '내용',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          maxLines: null,
          cursorColor: Colors.black,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
          maxLength: 1000,
          buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
            return Text(
              '$currentLength / $maxLength',
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            );
          },
          decoration: InputDecoration(
            hintText: '내용을 작성해주세요. (최대 1,000자)',
            hintStyle: const TextStyle(
              color: Color(0xFFBFBFBF),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFB3B3B3)),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFB3B3B3)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '사진 (선택, 최대 10장)',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '사진을 업로드해주세요.',
          style: TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Future<void> pickImage() async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {

              }
            }

            pickImage();
          },
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  color: const Color(0xFFCAD7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/picture.svg',
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _buildPictureCircleButton(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isFormValid ? () {
        PostApi().createPost(
          _contentController.text, 
          _titleController.text, 
          _categories, 
          [],
        );

        //TODO: 이미지 업로드 구현

        Get.offAll(() => const MainPage());
      } : null,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: ShapeDecoration(
          color: _isFormValid ? const Color(0xFF3B6DFF) : const Color(0xFFCCCCCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Center(
          child: Text(
            '작성하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPictureCircleButton() {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: const ShapeDecoration(
          color: Color(0xFF3B6DFF),
          shape: CircleBorder(),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton() {
    bool isMaxCategories = _categories.length >= 3;
    return GestureDetector(
      onTap: isMaxCategories ? null : () {
        _showCategoryDialog();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: ShapeDecoration(
          color: isMaxCategories ? const Color(0xFFCCCCCC) : const Color(0xFF3B6DFF),
          shape: const CircleBorder(),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    if (_categories.length >= 3) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCategory = '';
        return AlertDialog(
          backgroundColor: const Color(0xFFE2E2E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Center(
            child: Text(
              '카테고리 추가',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 17,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          content: TextField(
            cursorColor: const Color(0xFF000000),
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(
              hintText: "새 카테고리를 입력하세요",
              focusColor: Color(0xFF898989),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xFF898989)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xFF898989)),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text(
                '돌아가기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF)
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '추가하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF)
                ),
              ),
              onPressed: () {
                setState(() {
                  if (!_categories.contains(newCategory) && _categories.length < 3) {
                    _categories.add(newCategory);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCategoryDialog(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE2E2E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '카테고리를 ',
                    style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                    ),
                  ),
                  TextSpan(
                    text: '삭제',
                    style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF2E00),
                    ),
                  ),
                  TextSpan(
                    text: '하시겠습니까?',
                    style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text(
                '돌아가기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF)
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '삭제하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF007AFF)
                ),
              ),
              onPressed: () {
                setState(() {
                  _categories.remove(category);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(String label) {
    return GestureDetector(
      onTap: () {
        _showDeleteCategoryDialog(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: ShapeDecoration(
          color: const Color(0xFFDFE7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3B6DFF),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBorderDecoration() {
    return const BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: Color(0xFFCCCCCC)),
      ),
    );
  }
}