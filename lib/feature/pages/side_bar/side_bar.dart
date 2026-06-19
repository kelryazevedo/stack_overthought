import 'package:flutter/material.dart';
import 'package:stack_overthought/core/ui_core/app_color.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/pages/side_bar/side_bar_content.dart';
import 'package:stack_overthought/feature/pages/side_bar/side_bar_user.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth < 600
              ? 200
              : MediaQuery.of(context).size.width * 0.15,
          color: AppColors.secondary.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  projectName,
                  style: AppTextStyle.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(child: SideBarContent()),
              SideBarUser(),
            ],
          ),
        );
      },
    );
  }
}
