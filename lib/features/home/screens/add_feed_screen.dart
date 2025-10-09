import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:feed_flix/core/common/widgets/custom_elevated_button.dart';
import 'package:feed_flix/core/constants/asset_constants.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFeedScreen extends StatelessWidget {
  const AddFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191919),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    CustomElevatedButton(
                      onPressed: () {},
                      padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
                      bgColor: Colors.red.shade900.withOpacity(0.1),
                      borderColor: Colors.red.shade800.withOpacity(0.5),
                      borderRadius: 30,
                      child: Text(
                        AppStrings.sharePostText,
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteText,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22),
                // Video Selector
                Container(
                  decoration: DottedDecoration(
                    dash: [15],
                    shape: Shape.box,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 70),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetConstants.uploadIcon),
                        SizedBox(height: 20),
                        Text(
                          AppStrings.selectVideoText,
                          style: GoogleFonts.poppins(
                            color: AppColors.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                // Thumbnail Selector
                Container(
                  decoration: DottedDecoration(
                    dash: [15],
                    shape: Shape.box,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetConstants.thumbnailIcon, color: Colors.white),
                        const SizedBox(width: 15),
                        Text(
                          AppStrings.addThumbnailText,
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 22),
                // Add Description
                Text(
                  AppStrings.addDescriptionText,
                  style: GoogleFonts.poppins(
                    color: AppColors.whiteText,
                    fontSize: context.height * 0.019,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.loremtext,
                  style: GoogleFonts.poppins(color: AppColors.primaryTextColor, fontSize: 12),
                ),
                SizedBox(height: 18),

                Divider(color: Colors.grey.shade600),
                // Categories Section
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.categorizeProjectText,
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteText,
                          fontSize: context.height * 0.018,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Text(
                              AppStrings.viewallText,
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: context.height * 0.015,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),

                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AppColors.whiteColor),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: AppColors.whiteColor,
                                  size: context.height * 0.013,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: context.width * 0.02,
                  children: [
                    CategoryChip(AppStrings.physicsText),
                    CategoryChip(AppStrings.artificialIntelligenceText),
                    CategoryChip(AppStrings.mathematicsText),
                    CategoryChip(AppStrings.chemistryText),
                    CategoryChip(AppStrings.microBiologyText),
                    CategoryChip("Lorem ipsum dolor sit gre"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  const CategoryChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: Color(0xFF2C2322),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    );
  }
}
