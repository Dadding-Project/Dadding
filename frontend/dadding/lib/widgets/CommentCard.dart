import 'package:dadding/pages/user/OtherUserPage.dart';
import 'package:dadding/util/Comment.dart';
import 'package:dadding/util/User.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final User user;

  const CommentCard({
    super.key,
    required this.comment,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(4, 4),
                spreadRadius: 0
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => OtherUserPage(userId: user.id));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.profilePicture),
                    ),
                  ),
                  const SizedBox(width: 12.03),
                  Expanded(
                    child: Text(
                      comment.content,
                      style: const TextStyle(
                        color: Color(0xFF535353),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy.MM.dd a hh:mm', 'ko').format(comment.createdAt),
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${user.displayName.substring(0, 1)}**',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${User.calculateAge(DateFormat('yyyy.MM.dd').format(user.birthDate))}세 / ${user.gender == 'male' ? '남' : '기타'}',
                        style: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}