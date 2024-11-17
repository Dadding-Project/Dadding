import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/user/MyPage.dart';
import 'package:dadding/util/User.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numbers = newValue.text;
    
    if (numbers.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = '';
    
    for (int i = 0; i < numbers.length; i++) {
      if (i == 4 || i == 6) {
        formatted += '.';
      }
      formatted += numbers[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}


class _EditProfilePageState extends State<EditProfilePage> {
  String? _selectedGender;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<custom.User> fetchUser() async {
    final api = await UserApi().getUserById(FirebaseAuth.instance.currentUser!.uid);
    custom.User user = custom.User.fromJson(api['data']);
    return user;
  }

  @override
  void initState() {
    super.initState();
    fetchUser().then((user) {
      _nameController.text = user.displayName;
      _dateController.text = DateFormat('yyyy.MM.dd').format(user.birthDate);
      _selectedGender = user.gender == 'male' ? '남자' : '기타';
      return user;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '정보 수정',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            top: screenHeight * 0.05,
            bottom: screenWidth * 0.15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset('assets/icons/profile-setting.svg'),
              ),
              const SizedBox(height: 59.9),
              _buildInfoField(
                hintText: '이름을 작성해주세요.',
                controller: _nameController,
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildInfoField(
                hintText: '0000.00.00',
                controller: _dateController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DateInputFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildGenderSelection(),
              const Spacer(),
              _buildNextButton(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String hintText,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: ShapeDecoration(
            color: const Color(0xFFF4F7FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              keyboardType: keyboardType,
              textAlign: TextAlign.start,
              cursorColor: const Color(0xFF000000),
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 18,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
                errorStyle: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 18,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildGenderButton('남자'),
            const SizedBox(width: 15),
            _buildGenderButton('기타'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String text) {
    final isSelected = _selectedGender == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = text;
          });
        },
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xFF3B6DFF) : const Color(0xFFF4F7FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(66),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFAAAAAA),
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: _onNextButtonPressed,
      child: Container(
        width: screenWidth * 0.88,
        height: screenHeight * 0.07,
        decoration: ShapeDecoration(
          color: const Color(0xFF3B6DFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Center(
          child: Text(
            '작성하기',
            textAlign: TextAlign.center,
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

  _onNextButtonPressed() {
    //TODO 업데이트 유저 정보
    //TODO 프로필 이미지
    //TODO 스켈레톤 ... 적용....
    
    Get.offAll(() => const MyPage());
  }
}
