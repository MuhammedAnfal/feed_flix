import 'package:feed_flix/core/constants/asset_constants.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/features/feed/data/models/feed_model.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyFeedPage extends StatelessWidget {
  const MyFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MyFeedProvider>(
          builder: (context, feedProvider, child) {
            if (feedProvider.isLoading && feedProvider.myFeeds.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (feedProvider.errorMessage.isNotEmpty && feedProvider.myFeeds.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${feedProvider.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => feedProvider.getMyFeeds(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (feedProvider.myFeeds.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_library, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No feeds yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text(
                      'Add your first feed to get started!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.whiteColor),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.whiteColor,
                            size: context.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        AppStrings.addFeedsText,
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteText,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                //-- Feed List
                SizedBox(
                  height: context.height * 0.75,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return FeedCardItem(
                        profileName: 'anint',
                        timeAgo: '5 dY',
                        imageAsset: AssetConstants.userIcon,
                        description: 'aldfjska;lfkjas;',
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FeedCardItem extends StatelessWidget {
  final String profileName;
  final String timeAgo;
  final String imageAsset;
  final String description;
  const FeedCardItem({
    super.key,
    required this.profileName,
    required this.timeAgo,
    required this.imageAsset,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 0),
          leading: CircleAvatar(
            backgroundImage: AssetImage(AssetConstants.userIcon), // Replace with profile image
          ),
          title: Text(
            profileName,
            style: GoogleFonts.poppins(
              color: AppColors.whiteText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            timeAgo,
            style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 11),
          ),
        ),
        // Video/Image card
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            description,
            style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
