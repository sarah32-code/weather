import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../config/translations/strings_enum.dart';

Future<void> showLoadingOverLay({
  required Future<void> Function() asyncFunction,
  String? msg,
}) async {
  await Get.showOverlay(
    asyncFunction: () async {
      try {
        await asyncFunction();
      } catch (error, stackTrace) {
        Logger().e(error);
        Logger().e(stackTrace);
        // Optionally, you can rethrow the error
        // rethrow;
      }
    },
    loadingWidget: LoadingIndicator(msg: msg),
    opacity: 0.7,
    opacityColor: Colors.black,
  );
}

class LoadingIndicator extends StatelessWidget {
  final String? msg;
  const LoadingIndicator({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 40.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitCubeGrid(
            color: theme.primaryColor,
            size: 30.0,
          ),
          const SizedBox(height: 30),
          Text(
            msg ?? Strings.loading.tr,
            style: theme.textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
