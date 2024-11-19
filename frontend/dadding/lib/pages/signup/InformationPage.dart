import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/MainPage.dart';
import 'package:dadding/pages/signup/ProfileSettingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InformationPageState createState() => _InformationPageState();
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


class _InformationPageState extends State<InformationPage> {
  String? _selectedGender;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedGender = '남자';
    _nameController.addListener(_validateForm);
    _dateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _dateController.text.length == 10 &&
          _selectedGender != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
              const Text(
                '반가워요!\n정보를 작성해주세요.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildInfoField(
                hintText: '이름을 작성해주세요.',
                subText: '실명을 입력해주세요 (필수)',
                controller: _nameController,
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildInfoField(
                hintText: '0000.00.00',
                subText: '태어난연도를 입력해주세요 (필수)',
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
    required String subText,
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
        const SizedBox(height: 10),
        Text(
          subText,
          style: const TextStyle(
            color: Color(0xFF909090),
            fontSize: 13,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
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
        const SizedBox(height: 10),
        const Text(
          '성별을 선택해주세요 (필수)',
          style: TextStyle(
            color: Color(0xFF909090),
            fontSize: 13,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
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
            _validateForm();
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
      onTap: _isButtonEnabled ? _onNextButtonPressed : null,
      child: Container(
        width: screenWidth * 0.88,
        height: screenHeight * 0.07,
        decoration: ShapeDecoration(
          color: _isButtonEnabled ? const Color(0xFF3B6DFF) : const Color(0xFFCCCCCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Center(
          child: Text(
            '넘어가기',
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
    // Get.to(() => ProfileSettingPage(
    //   name: _nameController.text,
    //   birth: _dateController.text,
    //   gender: _selectedGender ?? '남자',
    // ));

    UserApi().createUser(_nameController.text, FirebaseAuth.instance.currentUser!.photoURL ?? '', _dateController.text, _selectedGender ?? '남자');
    Get.offAll(() => const MainPage());
  }
}
