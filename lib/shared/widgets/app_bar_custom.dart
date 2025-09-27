import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? AppColors.onSurface,
              ),
            )
          : null,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Gradient gradient;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const GradientAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.gradient = const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryContainer],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: AppBar(
        title: title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor ?? AppColors.onPrimary,
                ),
              )
            : null,
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? AppColors.onPrimary,
        elevation: elevation,
        automaticallyImplyLeading: automaticallyImplyLeading,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

class SliverAppBarCustom extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  const SliverAppBarCustom({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? AppColors.onSurface,
              ),
            )
          : null,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      elevation: elevation,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }
}

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? additionalActions;

  const NotificationAppBar({
    super.key,
    this.title,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onMenuTap,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            )
          : null,
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      actions: [
        if (additionalActions != null) ...additionalActions!,
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: onNotificationTap,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99 ? '99+' : notificationCount.toString(),
                    style: const TextStyle(
                      color: AppColors.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}
