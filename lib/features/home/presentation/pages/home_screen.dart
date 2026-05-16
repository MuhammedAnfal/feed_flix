import 'package:feed_flix/core/constants/asset_constants.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:feed_flix/features/home/presentation/providers/category_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/video_provider.dart';
import 'package:feed_flix/features/home/screens/widgets/video_player_widget.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  late VideoProvider _videoProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getCategories();
      context.read<FeedProvider>().getFeeds();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoProvider = context.read<VideoProvider>();
  }

  @override
  void dispose() {
    _videoProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 20),
        child: _buildFloatingButton(
          context: context,
          onPressed: () {
            context.push('/addFeed');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                //-- user icons and welcome text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Hello User',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Welcome back to Section',
                      style: GoogleFonts.poppins(color: const Color(0xFFB0B0B0), fontSize: 12),
                    ),
                    //-- user icon
                    trailing: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(AssetConstants.userIcon),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                //-- Category Buttons with FeedProvider consumer
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return Consumer<FeedProvider>(
                      builder: (context, feedProvider, child) {
                        return Column(
                          children: [
                            // Loading indicator above categories
                            if (categoryProvider.isLoading)
                              Container(
                                width: double.infinity,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 8),
                                child: const LinearProgressIndicator(
                                  color: AppColors.primaryColor,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      // Explore/All chip
                                      FilterChip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.circular(20),
                                        ),
                                        backgroundColor:
                                            feedProvider.selectedCategoryId == null
                                            ? Colors.red.shade800.withOpacity(0.8)
                                            : Colors.red.shade800.withOpacity(0.2),
                                        selectedColor: Colors.red.shade900.withOpacity(0.8),
                                        label: Text(
                                          AppStrings.exploreText,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.whiteText,
                                            fontSize: context.height * 0.014,
                                          ),
                                        ),
                                        selected: feedProvider.selectedCategoryId == null,
                                        onSelected: (_) {
                                          _onExploreSelected();
                                        },
                                      ),
                                      SizedBox(
                                        height: context.height * 0.05,
                                        child: VerticalDivider(
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          if (categoryProvider.errorMessage !='')
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                'Failed to load categories',
                                                style: TextStyle(
                                                  color: AppColors.primaryTextColor,
                                                  fontSize: context.height * 0.017,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          else
                                            ...categoryProvider.categories.map((category) {
                                              final categoryId = category['id'] is int
                                                  ? category['id'] as int
                                                  : int.tryParse(category['id'].toString()) ??
                                                        -1;

                                              final isSelected =
                                                  feedProvider.selectedCategoryId ==
                                                  categoryId;
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: FilterChip(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  backgroundColor: isSelected
                                                      ? Colors.red.shade800.withOpacity(0.8)
                                                      : AppColors.primaryColor,
                                                  selectedColor: Colors.red.shade900
                                                      .withOpacity(0.8),
                                                  label: Text(
                                                    category['title'] ?? 'Unknown',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.whiteText,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  selected: isSelected,
                                                  onSelected: (_) {
                                                    _onCategorySelected(
                                                      categoryId,
                                                      category['title'] ?? 'Explore',
                                                    );
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Show selected category title
                            if (feedProvider.selectedCategoryTitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Showing: ${feedProvider.selectedCategoryTitle}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                //-- Feed List (rest of your existing code remains the same)
                Consumer<FeedProvider>(
                  builder: (context, feedProvider, child) {
                    // Your existing feed list code remains exactly the same...
                    // Loading State
                    if (feedProvider.isLoading && feedProvider.feeds.isEmpty) {
                      return SizedBox(
                        height: context.height * 0.6,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryColor),
                        ),
                      );
                    }

                    // Error State
                    if (feedProvider.errorMessage !="" && feedProvider.feeds.isEmpty) {
                      return SizedBox(
                        height: context.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load feeds',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                feedProvider.errorMessage,
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => feedProvider.getFeeds(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    // Empty State
                    if (feedProvider.feeds.isEmpty) {
                      return SizedBox(
                        height: context.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.feed, size: 64, color: Colors.grey.shade600),
                              const SizedBox(height: 16),
                              Text(
                                'No feeds available',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                feedProvider.selectedCategoryId != null
                                    ? 'No feeds available for this category'
                                    : 'Be the first to share something!',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => context.go('/addFeed'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: const Text(
                                  'Create First Feed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Data State - Use the actual feed data from API
                    return SizedBox(
                      height: context.height * 0.75,
                      child: ListView.builder(
                        itemCount: feedProvider.feeds.length,
                        itemBuilder: (context, index) {
                          final feed = feedProvider.feeds[index];
                          return FeedCardItem(feed: feed, index: index);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(int categoryId, String categoryTitle) {
    // Change to int
    print('Selected category: $categoryTitle (ID: $categoryId)');

    // Use API call if you have category-specific endpoint
    // context.read<FeedProvider>().getFeedsByCategory(categoryId, categoryTitle);

    // Or use local filtering (you'll need to modify this based on your feed data structure)
    context.read<FeedProvider>().filterFeedsByCategory(categoryId, categoryTitle);
  }

  void _onExploreSelected() {
    print('Explore selected - showing all feeds');
    context.read<FeedProvider>().clearCategoryFilter();
  }

  // Your existing _buildFloatingButton method remains the same...
  Widget _buildFloatingButton({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton.extended(
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
          child: SizeTransition(sizeFactor: animation, axis: Axis.horizontal, child: child),
        ),
        child: Icon(Icons.add, color: AppColors.whiteColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
      backgroundColor: AppColors.buttonColor,
      onPressed: onPressed,
    );
  }
}

class FeedCardItem extends StatelessWidget {
  final Results feed;
  final int index;

  const FeedCardItem({super.key, required this.feed, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 0),
          leading: CircleAvatar(
            backgroundImage: feed.user?.image != null
                ? NetworkImage(feed.user!.image!)
                : AssetImage(AssetConstants.userIcon) as ImageProvider,
          ),
          title: Text(
            feed.user?.name ?? 'Unknown User',
            style: GoogleFonts.poppins(
              color: AppColors.whiteText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            _getTimeAgo(feed.createdAt),
            style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 11),
          ),
        ),
        // Video/Image card
        if (feed.video != null && feed.video!.isNotEmpty)
          // Show Video Player for videos
          VideoPlayerWidget(
            videoUrl: feed.video!,
            thumbnailUrl: feed.image ?? 'https://picsum.photos/400/300',
            index: index,
          )
        else if (feed.image != null && feed.image!.isNotEmpty)
          // Show Image for image-only posts
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  feed.image!,
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      height: 180,
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              if (feed.video != null && feed.video!.isNotEmpty)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.54),
                      ),
                      child: Icon(Icons.play_arrow, color: AppColors.whiteColor, size: 34),
                    ),
                  ),
                ),
            ],
          )
        else
          // Fallback if no media
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.photo, size: 50, color: Colors.grey),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            feed.description ?? 'No description',
            style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 12),
          ),
        ),
        // Engagement metrics
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _buildEngagementItem(Icons.thumb_up, feed.likes?.length ?? 0),
              const SizedBox(width: 16),
              _buildEngagementItem(Icons.thumb_down, feed.dislikes?.length ?? 0),
              const SizedBox(width: 16),
              _buildEngagementItem(Icons.bookmark, feed.bookmarks?.length ?? 0),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEngagementItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryTextColor),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 12),
        ),
      ],
    );
  }

  String _getTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Recently';

    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}
