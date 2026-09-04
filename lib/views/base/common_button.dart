// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lekra/services/theme.dart';

// enum ButtonType { primary, secondary, tertiary }

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     Key? key,
//     this.title,
//     this.child,
//     this.type = ButtonType.primary,
//     required this.onTap,
//     this.disabledColor,
//     this.color,
//     this.height = 45,
//     this.isLoading = false,
//     this.radius = 6,
//     this.elevation = 0,
//     this.fontSize = 16,
//     this.textStyle,
//     this.borderColor,
//   })  : assert(title == null || child == null,
//             'Cannot provide both a title and a child\n'),
//         super(key: key);

//   const CustomButton.tertiary(
//       {Key? key,
//       this.title,
//       this.child,
//       this.type = ButtonType.tertiary,
//       required this.onTap,
//       this.disabledColor,
//       this.color,
//       this.height = 45,
//       this.isLoading = false,
//       this.radius = 6,
//       this.elevation = 0,
//       this.fontSize,
//       this.textStyle,
//       this.borderColor})
//       : assert(title == null || child == null,
//             'Cannot provide both a title and a child\n'),
//         super(key: key);

//   ///Button Title text
//   final String? title;

//   ///Button Title text
//   final Widget? child;

//   ///Button Type i.e. Primary or Secondary or Ternary
//   final ButtonType type;

//   ///Button isLoading if provided true will disable click on button and circular progress indicator will be visible
//   final bool isLoading;

//   ///Button buttonDisabled Color
//   final Color? disabledColor;

//   ///Button Color
//   final Color? color;
//   final Color? borderColor;

//   ///Button Height
//   final double? height;

//   ///Button Radius
//   final double radius;

//   ///Button onTap()
//   final Function()? onTap;

//   final double elevation;

//   final double? fontSize;

//   final TextStyle? textStyle;

//   @override
//   Widget build(BuildContext context) {
//     final _borderColor = borderColor ?? primaryColor;
//     if (type == ButtonType.primary) {
//       return MaterialButton(
//         onPressed: isLoading ? null : onTap,
//         height: height,
//         minWidth: 80,
//         elevation: elevation,
//         focusElevation: 0,
//         highlightElevation: 0,
//         disabledElevation: 0,
//         hoverElevation: 0,
//         color: color ?? Theme.of(context).primaryColor,
//         disabledColor: disabledColor ?? Theme.of(context).disabledColor,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(radius),
//             side: BorderSide(color: _borderColor)),
//         child: Center(
//           child: Builder(
//             builder: (context) {
//               if (isLoading) {
//                 return CircularProgressIndicator(
//                   color: color ?? Colors.white,
//                   strokeWidth: 2,
//                 );
//               }

//               return child ??
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                     child: Text(
//                       title!,
//                       textAlign: TextAlign.center,
//                       style: textStyle ??
//                           GoogleFonts.montserrat(
//                             color: Colors.white,
//                             fontSize: fontSize,
//                           ),
//                     ),
//                   );
//             },
//           ),
//         ),
//       );
//     } else if (type == ButtonType.secondary) {
//       return MaterialButton(
//         onPressed: isLoading ? null : onTap,
//         height: height,
//         minWidth: 80,
//         elevation: elevation,
//         focusElevation: 0,
//         highlightElevation: 0,
//         disabledElevation: 0,
//         hoverElevation: 0,
//         color: color ?? Colors.transparent,
//         disabledColor: disabledColor ?? Theme.of(context).disabledColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(radius),
//           side: BorderSide(color: _borderColor),
//         ),
//         child: Center(
//           child: Builder(
//             builder: (context) {
//               if (isLoading) {
//                 return CircularProgressIndicator(
//                   color: Theme.of(context).primaryColor,
//                   strokeWidth: 2,
//                 );
//               }

//               return child ??
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                     child: Text(
//                       title!,
//                       textAlign: TextAlign.center,
//                       style: textStyle ??
//                           GoogleFonts.montserrat(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: fontSize,
//                           ),
//                     ),
//                   );
//             },
//           ),
//         ),
//       );
//     } else {
//       return TextButton(
//         onPressed: isLoading ? null : onTap,
//         child: Builder(
//           builder: (context) {
//             if (isLoading) {
//               return CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//                 strokeWidth: 2,
//               );
//             }
//             if (child != null) {
//               return child!;
//             }
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 title!,
//                 textAlign: TextAlign.center,
//                 style: textStyle ??
//                     Theme.of(context).textTheme.labelLarge!.copyWith(
//                           fontSize: fontSize,
//                         ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lekra/services/theme.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.title,
    this.child,
    this.type = ButtonType.primary,
    required this.onTap,
    this.disabledColor,
    this.color,
    this.height = 45,
    this.isLoading = false,
    this.radius = 6,
    this.elevation = 0,
    this.fontSize = 16,
    this.textStyle,
    this.borderColor,
    this.borderWidth,

    // Gradient
    this.gradient,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
  })  : assert(
          title == null || child == null,
          'Cannot provide both a title and a child',
        ),
        super(key: key);

  const CustomButton.tertiary({
    Key? key,
    this.title,
    this.child,
    this.type = ButtonType.tertiary,
    required this.onTap,
    this.disabledColor,
    this.color,
    this.height = 45,
    this.isLoading = false,
    this.radius = 6,
    this.elevation = 0,
    this.fontSize,
    this.textStyle,
    this.borderColor,
    this.borderWidth,

    // Gradient
    this.gradient,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
  })  : assert(
          title == null || child == null,
          'Cannot provide both a title and a child',
        ),
        super(key: key);

  final String? title;
  final Widget? child;
  final ButtonType type;
  final bool isLoading;
  final Color? disabledColor;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double radius;
  final Function()? onTap;
  final double elevation;
  final double? fontSize;
  final TextStyle? textStyle;

  final Gradient? gradient;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(context);

      case ButtonType.secondary:
        return _buildSecondaryButton(context);

      case ButtonType.tertiary:
        return _buildTertiaryButton(context);
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final bool hasGradient = gradient != null;

    final Gradient? buttonGradient = isLoading
        ? null
        : gradient ??
            LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: [
                primaryColor,
                primaryColor.withValues(alpha: 0.75),
              ],
            );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: isLoading
              ? disabledColor ?? Theme.of(context).disabledColor
              : hasGradient
                  ? null
                  : color ?? Theme.of(context).primaryColor,
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? primaryColor,
            width: borderWidth ?? 1,
          ),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: _buildButtonContent(
              context,
              loadingColor: Colors.white,
              defaultTextColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final BorderSide borderSide = BorderSide(
      color: borderColor ?? primaryColor,
      width: borderWidth ?? 1,
    );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.fromBorderSide(borderSide),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: _buildButtonContent(
              context,
              loadingColor: primaryColor,
              defaultTextColor: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTertiaryButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onTap,
      child: _buildButtonContent(
        context,
        loadingColor: Theme.of(context).primaryColor,
        defaultTextColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildButtonContent(
    BuildContext context, {
    required Color loadingColor,
    required Color defaultTextColor,
  }) {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          color: loadingColor,
          strokeWidth: 2,
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Text(
        title ?? '',
        textAlign: TextAlign.center,
        style: textStyle ??
            GoogleFonts.montserrat(
              color: defaultTextColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
