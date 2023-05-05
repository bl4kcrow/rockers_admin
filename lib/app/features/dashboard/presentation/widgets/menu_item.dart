import 'package:flutter/material.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({
    super.key,
    required this.text,
    required this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final bool isActive;
  final Function() onPressed;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: widget.isActive ? AppColors.eerieBlack : Colors.transparent,
      child: InkWell(
        onTap: widget.isActive ? null : widget.onPressed,
        hoverColor: AppColors.eerieBlack,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: widget.isActive
                  ? const BorderSide(
                      color: AppColors.frenchWine,
                      width: 2.0,
                    )
                  : BorderSide.none,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive ? AppColors.frenchWine : null,
              ),
              const SizedBox(width: 5.0),
              Text(
                widget.text,
                style: bodyStyle.copyWith(
                  color: widget.isActive ? AppColors.frenchWine : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
