// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/input_decoration.dart';
// import 'package:lekra/services/theme.dart';

// class AppTextFieldWithHeading extends StatefulWidget {
//   final TextEditingController controller;
//   final String? heading;
//   final Widget? headingWidget;
//   final String hindText;
//   final TextStyle? hintStyle;
//   final String? prefixText;
//   TextStyle? prefixStyle;
//   final Widget? preFixWidget;
//   final TextInputType? keyboardType;
//   final Widget? suffix;
//   final FormFieldValidator<String>? validator; // made nullable for flexibility
//   final bool obscureText;
//   final List<TextInputFormatter>? inputFormatters;
//   final int? maxLines;
//   final bool isRequired;
//   final bool readOnly;
//   final Color? borderColor;
//   final double? borderWidth;
//   final Color? bgColor;
//   final Function()? onTap;
//   final double borderRadius;
//   final Function(String)? onChanged;
//   final TextInputAction? textInputAction;
//   final Function(String)? onFieldSubmitted;

//   AppTextFieldWithHeading({
//     super.key,
//     required this.controller,
//     required this.hindText,
//     this.hintStyle,
//     this.validator,
//     this.heading,
//     this.headingWidget,
//     this.keyboardType,
//     this.suffix,
//     this.prefixText,
//     this.prefixStyle,
//     this.obscureText = false,
//     this.inputFormatters,
//     this.maxLines,
//     this.preFixWidget,
//     this.isRequired = false,
//     this.readOnly = false,
//     this.borderColor,
//     this.borderWidth,
//     this.bgColor,
//     this.onTap,
//     this.onChanged,
//     this.borderRadius = 12.0,
//     this.textInputAction,
//     this.onFieldSubmitted,
//     // this.hight = 48,
//   });

//   Color get borderColorLocal =>
//       borderColor ??
//       grey.withValues(
//         alpha: 0.5,
//       );
//   Color get bgColorLocal => bgColor ?? grey.withValues(alpha: 0.1);

//   @override
//   State<AppTextFieldWithHeading> createState() =>
//       _AppTextFieldWithHeadingState();
// }

// class _AppTextFieldWithHeadingState extends State<AppTextFieldWithHeading> {
//   late bool _obscure;

//   @override
//   void initState() {
//     super.initState();
//     _obscure = widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hintStyleLocal = widget.hintStyle ??
//         Helper(context).textTheme.bodyMedium?.copyWith(
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//               color: greyText,
//             );

//     // Ensure single-line when obscured. If caller passed >1, we override.
//     final int effectiveMaxLines = _obscure ? 1 : (widget.maxLines ?? 1);

//     // If caller provided a suffix, use it; otherwise if field is obscured show a toggle eye.
//     final Widget? suffixWidget = widget.suffix ??
//         (widget.obscureText
//             ? IconButton(
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//                 icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
//                 onPressed: () {
//                   setState(() {
//                     _obscure = !_obscure;
//                   });
//                 },
//               )
//             : null);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.heading != null || widget.headingWidget != null) ...[
//           Row(
//             children: [
//               Expanded(
//                 child: widget.headingWidget ??
//                     Text(
//                       widget.heading!,
//                       style: Helper(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//               ),
//               const SizedBox(width: 4),
//               if (widget.isRequired)
//                 Text(
//                   "*",
//                   style: Helper(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.red),
//                 ),
//             ],
//           ),
//           sizedBoxHeight(height: 7),
//         ],
//         TextFormField(
//           textInputAction:
//               widget.textInputAction ?? TextInputAction.next, // 👈 Add this
//           onFieldSubmitted: widget.onFieldSubmitted,
//           onTap: widget.onTap,
//           controller: widget.controller,
//           keyboardType: widget.keyboardType,
//           obscureText: _obscure,
//           inputFormatters: widget.inputFormatters,
//           maxLines: effectiveMaxLines,
//           readOnly: widget.readOnly,
//           onChanged: widget.onChanged,
//           decoration: CustomDecoration.inputDecoration(
//             borderRadius: widget.borderRadius,
//             suffix: suffixWidget,
//             icon: widget.preFixWidget,
//             prefixText: widget.prefixText,
//             prefixStyle: widget.prefixStyle,
//             bgColor: widget.bgColorLocal,
//             hint: widget.hindText,
//             hintStyle: hintStyleLocal,
//             borderColor: widget.borderColorLocal,
//             borderWidth: widget.borderWidth ?? 0.5,
//           ),
//           validator: widget.validator,
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';

class AppTextFieldWithHeading extends StatefulWidget {
  final TextEditingController controller;

  final String? heading;
  final Widget? headingWidget;

  final String hindText;
  final TextStyle? hintStyle;

  final String? prefixText;
  TextStyle? prefixStyle;

  final Widget? preFixWidget;
  final Widget? suffix;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Keyboard action button
  final TextInputAction? textInputAction;

  final FormFieldValidator<String>? validator;

  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final bool isRequired;
  final bool readOnly;

  final Color? borderColor;
  final double? borderWidth;
  final Color? bgColor;

  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  final double borderRadius;

  final bool enabled;
  final bool autofocus;

  AppTextFieldWithHeading({
    super.key,
    required this.controller,
    required this.hindText,
    this.heading,
    this.headingWidget,
    this.hintStyle,
    this.prefixText,
    this.prefixStyle,
    this.preFixWidget,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.isRequired = false,
    this.readOnly = false,
    this.borderColor,
    this.borderWidth,
    this.bgColor,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderRadius = 12.0,
    this.enabled = true,
    this.autofocus = false,
  });

  Color get borderColorLocal => borderColor ?? grey.withValues(alpha: 0.5);

  Color get bgColorLocal => bgColor ?? grey.withValues(alpha: 0.1);

  @override
  State<AppTextFieldWithHeading> createState() =>
      _AppTextFieldWithHeadingState();
}

class _AppTextFieldWithHeadingState extends State<AppTextFieldWithHeading> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();

    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle hintStyleLocal = widget.hintStyle ??
        Helper(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: greyText,
            ) ??
        TextStyle(
          fontSize: 13.sp,
          color: greyText,
        );

    // Password fields must always be single line.
    final int effectiveMaxLines = _obscure ? 1 : (widget.maxLines ?? 1);

    // If suffix is manually provided, use it.
    // Otherwise automatically show password visibility button.
    final Widget? suffixWidget = widget.suffix ??
        (widget.obscureText
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20.r,
                  color: greyText,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // HEADING
        // ============================================================

        if (widget.heading != null || widget.headingWidget != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.headingWidget ??
                  CustomText(
                    widget.heading!,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                  ),
              if (widget.isRequired) ...[
                SizedBox(width: 4.w),
                CustomText(
                  "*",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                ),
              ],
            ],
          ),
          SizedBox(height: 7.h),
        ],

        // ============================================================
        // TEXT FIELD
        // ============================================================

        TextFormField(
          controller: widget.controller,

          // Keyboard
          keyboardType: widget.keyboardType,

          // Keyboard action
          textInputAction: widget.textInputAction ?? TextInputAction.next,

          // Password
          obscureText: _obscure,

          // Formatting
          inputFormatters: widget.inputFormatters,

          // Lines
          maxLines: effectiveMaxLines,
          minLines: widget.minLines,

          // Length
          maxLength: widget.maxLength,

          // State
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,

          // Callbacks
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,

          // Decoration
          decoration: CustomDecoration.inputDecoration(
            borderRadius: widget.borderRadius,
            suffix: suffixWidget,
            icon: widget.preFixWidget,
            prefixText: widget.prefixText,
            prefixStyle: widget.prefixStyle,
            bgColor: widget.bgColorLocal,
            hint: widget.hindText,
            hintStyle: hintStyleLocal,
            borderColor: widget.borderColorLocal,
            borderWidth: widget.borderWidth ?? 0.5,
          ),

          // Validation
          validator: widget.validator,
        ),
      ],
    );
  }
}

