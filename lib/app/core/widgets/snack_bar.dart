import 'package:flutter/material.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';

SnackBar customSnackBar({
  required text,
}) {
  return SnackBar(
    content: Text(
      text,
      style: heading2Style.copyWith(color: AppColors.white),
    ),
    backgroundColor: AppColors.oldMauve,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(5),
  );
}
