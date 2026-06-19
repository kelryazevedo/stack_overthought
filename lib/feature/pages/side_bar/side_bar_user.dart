import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stack_overthought/core/ui_core/app_color.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';

class SideBarUser extends StatelessWidget {
  const SideBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StackOverthoughtCubit>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 12,
        children: [
          const CircleAvatar(child: Text('KF')),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Kelry Fernandes',
                  style: AppTextStyle.body,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${cubit.state.notes?.length ?? 0} notes',
                  style: AppTextStyle.description.copyWith(
                    color: AppColors.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
