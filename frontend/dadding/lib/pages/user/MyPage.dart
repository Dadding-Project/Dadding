import 'package:dadding/pages/main/LoginPage.dart';
import 'package:dadding/pages/user/EditProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back-arrow.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '계정 관리',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.to(() => const EditProfilePage());
            },
            child: Padding(
              padding: EdgeInsets.only(
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              top: screenHeight * 0.05,
              ),
              child: SizedBox(
              child: Row(
                children: [
                const Text(
                  '정보 수정',
                  style: TextStyle(
                  color: Color(0xFF898A8D),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/arrow.svg',
                )
                ],
              ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          Container(
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
          ),
          SizedBox(height: screenHeight * 0.04),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.075),
            child: TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.to(() => const LoginPage());
              }, 
              child: const Text(
              '로그아웃',
              style: TextStyle(
                color: Color(0xFFE64234),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
              )
          )
        ],
      ),
    );
  }
}