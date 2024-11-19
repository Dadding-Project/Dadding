import 'package:flutter/material.dart';

class CommentCardSkeleton extends StatefulWidget {
  const CommentCardSkeleton({super.key});

  @override
  _CommentCardSkeletonState createState() => _CommentCardSkeletonState();

}

class _CommentCardSkeletonState extends State<CommentCardSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              _buildSkeletonItem(
                width: 36, 
                height: 36, 
                borderRadius: BorderRadius.circular(18)
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonItem(width: 100, height: 16),
                  const SizedBox(height: 5),
                  _buildSkeletonItem(width: 200, height: 14),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSkeletonItem(width: double.infinity, height: 20),
        ],
      ),
    );
  }

  Widget _buildSkeletonItem({
    required double width, 
    required double height, 
    BorderRadius? borderRadius
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300]!.withOpacity(_animation.value),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}