import 'package:feed_flix/core/constants/asset_constants.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 20),
        child: _buildFloatingButton(
          context: context,
          onPressed: () {
            context.go('/addFeed');
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
                SizedBox(height: 20),
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
                      style: GoogleFonts.poppins(color: Color(0xFFB0B0B0), fontSize: 12),
                    ),

                    //-- user icon
                    trailing: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        AssetConstants.userIcon,
                      ), // Replace with real profile image
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                //-- Category Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Wrap(
                        spacing: 10,
                        children: [
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            backgroundColor: Colors.red.shade800.withOpacity(0.2),
                            selectedColor: Colors.red.shade900.withOpacity(0.1),
                            label: Text(
                              AppStrings.exploreText,
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: context.height * 0.014,
                              ),
                            ),
                            onSelected: (_) {
                              print('object');
                            },
                          ),
                          SizedBox(
                            height: context.height * 0.05,
                            child: VerticalDivider(color: AppColors.primaryTextColor),
                          ),
                          Row(
                            children: [
                              FilterChip(
                                backgroundColor: AppColors.primaryColor,
                                label: Text(
                                  AppStrings.trendingText,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.whiteText,
                                    fontSize: context.height * 0.014,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(20),
                                ),
                                selected: false,
                                onSelected: (_) {},
                              ),
                            ],
                          ),
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            label: Text(
                              AppStrings.allCategoriesText,
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: context.height * 0.014,
                              ),
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            label: Text(
                              AppStrings.physicsText,
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: context.height * 0.014,
                              ),
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            label: Text(
                              AppStrings.chemistryText,
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: context.height * 0.014,
                              ),
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

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
            ),
          ),
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

Widget _buildFloatingButton({required BuildContext context, required VoidCallback onPressed}) {
  return FloatingActionButton.extended(
    label: AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
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
