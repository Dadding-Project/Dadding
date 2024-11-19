import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostInnerPageSkeleton extends StatefulWidget {
  const PostInnerPageSkeleton({super.key});

  @override
  _PostInnerPageSkeletonState createState() => _PostInnerPageSkeletonState();
}

class _PostInnerPageSkeletonState extends State<PostInnerPageSkeleton> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back-arrow.svg',
          ), 
          onPressed: null,
        ),
        title: const Text(
          '게시물',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeaderSkeleton(),
              const SizedBox(height: 20),
              _buildTitleSkeleton(),
              const SizedBox(height: 15),
              _buildContentSkeleton(),
              const SizedBox(height: 15),
              _buildImageSkeleton(),
              const SizedBox(height: 15),
              _buildDateSkeleton(),
              const SizedBox(height: 30),
              _buildCommentHeaderSkeleton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeaderSkeleton() {
    return Row(
      children: [
        _buildSkeletonItem(
          width: 42, 
          height: 42, 
          borderRadius: BorderRadius.circular(21)
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonItem(width: 100, height: 16),
            const SizedBox(height: 5),
            _buildSkeletonItem(width: 80, height: 14),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSkeleton() {
    return _buildSkeletonItem(width: double.infinity, height: 30);
  }

  Widget _buildContentSkeleton() {
    return Column(
      children: [
        _buildSkeletonItem(width: double.infinity, height: 20),
        const SizedBox(height: 10),
        _buildSkeletonItem(width: double.infinity, height: 20),
      ],
    );
  }

  Widget _buildImageSkeleton() {
    return _buildSkeletonItem(
      width: double.infinity, 
      height: 200, 
      borderRadius: BorderRadius.circular(12)
    );
  }

  Widget _buildDateSkeleton() {
    return _buildSkeletonItem(width: 150, height: 16);
  }

  Widget _buildCommentHeaderSkeleton() {
    return _buildSkeletonItem(width: 100, height: 20);
  }
}