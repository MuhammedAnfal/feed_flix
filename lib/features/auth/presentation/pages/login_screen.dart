import 'package:feed_flix/core/common/widgets/custom_elevated_button.dart';
import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:feed_flix/core/snackbar/snackbar_service.dart';
import 'package:feed_flix/core/utils/extensions/size_extension.dart';
import 'package:feed_flix/core/utils/validators/app_validators.dart';
import 'package:feed_flix/features/auth/presentation/providers/auth_providers.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //-- variables
  TextEditingController numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleLogin({
    required BuildContext context,
    required AuthProvider authProvider,
  }) async {
    // Validate form first

    final phoneNumber = numberController.text.trim();

    final success = await authProvider.login(number: phoneNumber);

    if (success && context.mounted) {
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to home screen after a short delay
      await Future.delayed(Duration(milliseconds: 1500));
      if (context.mounted) {
        context.go('/home');
      }
    } else if (context.mounted && authProvider.errorMessage.isNotEmpty) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color redColor = Color(0xFFD10A12);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Consumer<AuthProvider>(
            builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      AppStrings.mobNoText1,
                      style: GoogleFonts.poppins(
                        color: AppColors.whiteText,
                        fontSize: context.height * 0.03,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      AppStrings.mobNoText2,
                      style: GoogleFonts.poppins(
                        color: AppColors.whiteText,
                        fontSize: context.height * 0.03,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryTextColor,
                        fontSize: context.height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.height * 0.016),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF191919),
                          ),
                          child: Center(
                            child: Text(
                              '+91',
                              style: GoogleFonts.poppins(
                                color: AppColors.whiteText,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                validator: (value) {
                                  return AppValidators().validatePhoneNumber(value!);
                                },
                                controller: numberController,
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: AppStrings.enterNumberText,
                                  hintStyle: GoogleFonts.poppins(
                                    color: AppColors.whiteText,
                                    fontSize: context.height * 0.015,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Center(
                      child: CustomElevatedButton(
                        buttonHeight: context.height * 0.055,
                        buttonWidth: context.width * 0.35,
                        borderRadius: 24,
                        bgColor: AppColors.primaryColor,
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                _handleLogin(context: context, authProvider: authProvider);
                              },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppStrings.continueText,
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryTextColor,
                                fontSize: 16,
                              ),
                            ),

                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: redColor,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
