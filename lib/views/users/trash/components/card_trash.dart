import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/app_card.dart';

import '../../../../data/models/user.dart';
import '../../../../view_models/user_view_model.dart';

class CustomCardTrash extends StatelessWidget {
  const CustomCardTrash(this.user, {super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.job.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.job,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final userModel = User(
                    id: user.id,
                    name: user.name,
                    job: user.job,
                    salary: user.salary,
                    isDeleted: 0,
                  );
                  userViewModel.updateUser(userModel);
                },
                icon: const Icon(
                  Icons.restore_rounded,
                  color: AppColors.success,
                  size: 22,
                ),
                tooltip: 'إستعادة',
              ),
              IconButton(
                onPressed: () {
                  userViewModel.deleteUser(user);
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.danger,
                  size: 22,
                ),
                tooltip: 'حذف نهائي',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
