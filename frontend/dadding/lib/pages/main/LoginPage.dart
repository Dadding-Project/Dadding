import 'package:dadding/api/UserApi.dart';
import 'package:dadding/pages/signup/InformationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dadding/pages/MainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFFFFFF),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 130),
                _buildLogoSection(),
                const Spacer(),
                _buildLoginButton(),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/logo.svg'),
            const SizedBox(width: 8),
            const Text(
              'DADDYING',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3B6DFF),
                fontSize: 25,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: 300,
      decoration: ShapeDecoration(
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12.70,
            offset: Offset(1, 2),
            spreadRadius: 0,
          )
        ], 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: ElevatedButton(
        onPressed: _isSigningIn ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFAAAAAA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isSigningIn
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFFAAAAAA),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/google.svg'),
                  const SizedBox(width: 8),
                  const Text(
                    '구글 계정으로 로그인',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isSigningIn = true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign In was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      final userResponse = await UserApi().getUserById(user!.uid);
      if (userResponse['status'] == 404) {
        Get.offAll(() => const InformationPage());
      } else {
        Get.offAll(() => const MainPage());
      }
      
    } catch (e) {
      print('Error during Google sign in: $e');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
}