import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:feed_flix/core/common/widgets/custom_elevated_button.dart';
import 'package:feed_flix/core/constants/asset_constants.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/category_provider.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getCategories();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(MyFeedProvider myFeedProvider) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        myFeedProvider.setVideo(video);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick video: $e');
    }
  }

  Future<void> _pickThumbnail(MyFeedProvider myFeedProvider) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        myFeedProvider.setThumbnail(image);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick thumbnail: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191919),
      body: Consumer<MyFeedProvider>(
        builder: (context, myFeedProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.go('/home'),
                              child: Container(
                                padding: const EdgeInsets.all(5),
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
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                AppStrings.addFeedsText,
                                style: TextStyle(
                                  color: AppColors.whiteText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomElevatedButton(
                          onPressed: myFeedProvider.isUploading
                              ? null
                              : () async {
                                  final success = await myFeedProvider.uploadCurrentFeed();
                                  if (success) {
                                    _showSuccessSnackbar('Post shared successfully!');
                                    context.pop();
                                  } else {
                                    _showErrorSnackbar(myFeedProvider.errorMessage);
                                  }
                                },
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
                          bgColor: myFeedProvider.isFormValid && !myFeedProvider.isUploading
                              ? Colors.red.shade900.withOpacity(0.8)
                              : Colors.red.shade900.withOpacity(0.1),
                          borderColor: Colors.red.shade800.withOpacity(0.5),
                          borderRadius: 30,
                          child: myFeedProvider.isUploading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.whiteText,
                                  ),
                                )
                              : Text(
                                  AppStrings.sharePostText,
                                  style: GoogleFonts.poppins(
                                    color: myFeedProvider.isFormValid
                                        ? AppColors.whiteText
                                        : AppColors.whiteText.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Video Selector
                    GestureDetector(
                      onTap: () => _pickVideo(myFeedProvider),
                      child: Container(
                        decoration: DottedDecoration(
                          dash: const [15],
                          shape: Shape.box,
                          borderRadius: const BorderRadius.all(Radius.circular(13)),
                          color: myFeedProvider.selectedVideo != null
                              ? Colors.green.withOpacity(0.3)
                              : Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (myFeedProvider.selectedVideo != null) ...[
                                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                                const SizedBox(height: 10),
                                Text(
                                  'Video Selected',
                                  style: GoogleFonts.poppins(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  myFeedProvider.selectedVideo!.name,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.whiteColor,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ] else ...[
                                SvgPicture.asset(AssetConstants.uploadIcon),
                                const SizedBox(height: 20),
                                Text(
                                  AppStrings.selectVideoText,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Thumbnail Selector
                    GestureDetector(
                      onTap: () => _pickThumbnail(myFeedProvider),
                      child: Container(
                        decoration: DottedDecoration(
                          dash: const [15],
                          shape: Shape.box,
                          borderRadius: const BorderRadius.all(Radius.circular(13)),
                          color: myFeedProvider.selectedThumbnail != null
                              ? Colors.green.withOpacity(0.3)
                              : Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Center(
                          child: myFeedProvider.selectedThumbnail != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Thumbnail Selected',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      myFeedProvider.selectedThumbnail!.name,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.whiteColor,
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AssetConstants.thumbnailIcon,
                                      color: Colors.white,
                                    ),
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
                    ),
                    const SizedBox(height: 22),

                    // Add Description
                    Text(
                      AppStrings.addDescriptionText,
                      style: GoogleFonts.poppins(
                        color: AppColors.whiteText,
                        fontSize: context.height * 0.019,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.loremtext,
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description TextField
                    TextField(
                      controller: _descriptionController,
                      onChanged: (value) => myFeedProvider.setDescription(value),
                      maxLines: 4,
                      style: GoogleFonts.poppins(color: AppColors.whiteText, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Write your description here...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade800),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Divider(color: Colors.grey),

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
                          GestureDetector(
                            onTap: () {
                              _showAllCategoriesDialog(myFeedProvider);
                            },
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
                                  margin: const EdgeInsets.only(left: 10),
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
                    const SizedBox(height: 12),

                    // Categories from API
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        if (categoryProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryColor),
                          );
                        }

                        if (categoryProvider.errorMessage.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade900.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Failed to load categories: ${categoryProvider.errorMessage}',
                              style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: context.width * 0.02,
                          runSpacing: 8,
                          children: categoryProvider.categories.map((category) {
                            final categoryId = category['id'] is int
                                ? category['id'] as int
                                : int.tryParse(category['id'].toString()) ?? -1;
                            final isSelected = myFeedProvider.selectedCategories.contains(
                              categoryId,
                            );

                            return GestureDetector(
                              onTap: () => myFeedProvider.toggleCategory(categoryId),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.red.shade800.withOpacity(0.8)
                                      : const Color(0xFF2C2322),
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? Border.all(color: Colors.red.shade600, width: 2)
                                      : null,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  category['title'] ?? 'Unknown',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Upload Progress (if uploading)
                    if (myFeedProvider.isUploading) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uploading... ${(myFeedProvider.uploadProgress * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              color: AppColors.whiteText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: myFeedProvider.uploadProgress,
                            backgroundColor: Colors.grey.shade800,
                            color: AppColors.primaryColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAllCategoriesDialog(MyFeedProvider myFeedProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2322),
        title: Text('All Categories', style: GoogleFonts.poppins(color: Colors.white)),
        content: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  final categoryId = category['id'] is int
                      ? category['id'] as int
                      : int.tryParse(category['id'].toString()) ?? -1;
                  final isSelected = myFeedProvider.selectedCategories.contains(categoryId);

                  return ListTile(
                    title: Text(
                      category['title'] ?? 'Unknown',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                    onTap: () {
                      myFeedProvider.toggleCategory(categoryId);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
