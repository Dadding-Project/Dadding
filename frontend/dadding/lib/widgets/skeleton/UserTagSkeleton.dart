import 'package:flutter/material.dart';

class UserTagSkeleton extends StatelessWidget {
  const UserTagSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class UserTagsSkeleton extends StatefulWidget {
  const UserTagsSkeleton({super.key});

  @override
  State<UserTagsSkeleton> createState() => _UserTagsSkeletonState();
}

class _UserTagsSkeletonState extends State<UserTagsSkeleton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Row(
            children: List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(right: 6),
                child: UserTagSkeleton(),
              ),
            ),
          ),
        );
      },
    );
  }
}