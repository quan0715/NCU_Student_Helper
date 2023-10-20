import 'package:flutter/material.dart';
import 'package:ncu_helper/view/theme/color.dart';
import 'package:ncu_helper/view/theme/text.dart';

class SettingSection extends StatelessWidget{
  const SettingSection({
    super.key,
    required this.title,
    this.children,
    this.subTitle,
    this.status,

  });
  final List<Widget>? children;
  final String title;
  final String? subTitle;
  final Widget? status;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: AppText.titleMedium(context).copyWith(color: AppColor.primary(context)),),
                                subTitle != null ? Text(subTitle!,
                                softWrap: true,
                                style: AppText.titleSmall(context).copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.secondary(context),
                                ),) : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          status ?? const SizedBox.shrink(),
                        ],
                      ),
                      const Divider(),
                      ...children != null ? children! : [],
                    ],
                  ),
                ),
            ],
          )
        ),
      );
  }
}