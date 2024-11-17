import 'package:dadding/widgets/skeleton/PostListSkeleton.dart';
import 'package:flutter/material.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserProfileHeaderSkeleton(),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const PostListSkeleton(),
          ),
        ),
      ],
    );
  }
}

class UserProfileHeaderSkeleton extends StatelessWidget {
  static const _padding = EdgeInsets.all(20);

  const UserProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserInfoSkeleton(),
          const SizedBox(height: 13),
          Row(
            children: List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: SkeletonBox(width: 80, height: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoSkeleton extends StatelessWidget {
  const UserInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SkeletonBox(
          width: 84,
          height: 84,
          shape: BoxShape.circle,
        ),
        const SizedBox(width: 19),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(width: 120, height: 24),
              const SizedBox(height: 8),
              Container(
                height: 0.5,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              const SkeletonBox(width: 100, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}