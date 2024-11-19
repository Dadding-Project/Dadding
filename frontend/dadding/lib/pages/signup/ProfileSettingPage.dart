import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/MainPage.dart';
import 'package:dadding/util/User.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileSettingPage extends StatefulWidget {
  final String name;
  final String birth;
  final String gender;

  const ProfileSettingPage({
    super.key,
    required this.name,
    required this.birth,
    required this.gender,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            top: screenHeight * 0.02,
            bottom: screenWidth * 0.23,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '프로필을\n추가해 주세요.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              const SizedBox(
                child: Text(
                  '사진을 선택해주세요 (선택)',
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.09),
              Center(
                child: Column(
                  children: [
                    // SvgPicture.asset(
                    //   'assets/icons/profile-setting.svg',
                    // ),
                    // SizedBox(height: screenHeight * 0.03),
                    Text(
                      '${widget.name}님',
                      style: const TextStyle(
                        color: Color(0xFF656565),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                        '${custom.User.calculateAge(widget.birth)}세 / ${widget.gender == '남자' ? '남' : '기타'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ),
              const Spacer(),
              _buildNextButton(screenWidth, screenHeight),
            ],
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
            '완료',
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
    UserApi().createUser(widget.name, FirebaseAuth.instance.currentUser?.photoURL ?? '', widget.birth, widget.gender);
    Get.offAll(() => const MainPage());
  }
}
