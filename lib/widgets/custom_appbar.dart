import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onFavoritesTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onFavoritesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        if (onFavoritesTap != null)
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: onFavoritesTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
