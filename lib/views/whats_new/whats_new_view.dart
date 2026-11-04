import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/whats_new_view_model.dart';
import 'package:work_time/views/whats_new/components/whats_new_card.dart';

class WhatsNewView extends StatefulWidget {
  const WhatsNewView({super.key});

  @override
  State<WhatsNewView> createState() => _WhatsNewViewState();
}

class _WhatsNewViewState extends State<WhatsNewView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WhatsNewViewModel>().markSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'ما الجديد والتحديثات ✨',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      body: Consumer<WhatsNewViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (vm.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkSurface : AppColors.primaryLight,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_outlined,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أنت على أحدث إصدار!',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'سيتم نشر التحديثات والميزات الجديدة هنا فور إطلاقها.',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => vm.loadWhatsNew(forceRefresh: true),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.all(16),
              itemCount: vm.items.length,
              itemBuilder: (context, index) {
                final item = vm.items[index];
                return WhatsNewCard(
                  item: item,
                  isLatest: index == 0,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

