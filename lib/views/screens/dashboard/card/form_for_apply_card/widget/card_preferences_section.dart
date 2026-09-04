// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lekra/controllers/card_controller.dart';
// import 'package:lekra/generated/assets.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/theme.dart';
// import 'package:lekra/views/base/custom_dropdown.dart';
// import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_heading_text.dart';
// import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_title_row.dart';

// import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

// enum NameType { printed, embossed }

// class CardPreferencesSection extends StatefulWidget {
//   const CardPreferencesSection({super.key});

//   @override
//   State<CardPreferencesSection> createState() => _CardPreferencesSectionState();
// }

// class _CardPreferencesSectionState extends State<CardPreferencesSection> {
//   NameType selectedNameType = NameType.printed;

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CardController>(builder: (cardController) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CardFormTitleRow(icon: Assets.svgsCard2, title: "Card Preferences"),
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomDropDownList(
//                   items: cardController.productCategoryList,
//                   value: cardController.selectProductCategory,
//                   onChanged: (value) {
//                     cardController.selectProductCategory = value;
//                     cardController.update();
//                   },
//                   headingWidget: CardFormHeadingText(
//                     heading: "PRODUCT CATEGORY",
//                   ),
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select product category';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: CustomDropDownList(
//                   items: cardController.cardNatureList,
//                   itemWidget: cardController.cardNatureListText
//                       .map((e) => Text(e,
//                           style: Helper(context).textTheme.bodyMedium?.copyWith(
//                                 fontSize: 14,
//                                 color: black,
//                               )))
//                       .toList(),
//                   value: cardController.cardNature,
//                   onChanged: (value) {
//                     cardController.updateCardNature(value);
//                   },
//                   headingWidget: CardFormHeadingText(
//                     heading: "CARD NATURE",
//                   ),
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select card nature';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           AppTextFieldWithHeading(
//             headingWidget: CardFormHeadingText(heading: "PRODUCT NAME"),
//             controller: cardController.productNameController,
//             hindText: "Enter your product name",
//             readOnly: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter product name';
//               }

//               return null;
//             },
//           ),
//           SizedBox(height: 16),
//           CardFormHeadingText(heading: "PERSONALIZATION TYPE"),
//           SizedBox(height: 6),
//           RadioGroup<NameType>(
//             groupValue: selectedNameType,
//             onChanged: (value) {
//               setState(() {
//                 selectedNameType = value!;
//               });
//             },
//             child: Wrap(
//               spacing: 20,
//               children: [
//                 Row(
//                   children: [
//                     Radio<NameType>(
//                       value: NameType.printed,
//                     ),
//                     const Text("Personalized"),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     });
//   }
// }
