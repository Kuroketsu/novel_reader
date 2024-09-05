import 'package:flutter/material.dart';
import 'package:novel_reader/common/custom/custom_scroll_behavior.dart';

class Helpers {
  static void showGenericDialog({
    required BuildContext parentContext,
    required String title,
    required String description,
    double minWidth = 0,
    double contentButtonSpacing = 32,
    Color? backgroundColor,
    String? negativeButtonText,
    String? positiveButtonText,
    Color? positiveButtonColor,
    VoidCallback? negativeCallback,
    VoidCallback? positiveCallback,
    bool hideBackgroundShadow = false,
  }) {
    final width = MediaQuery.of(parentContext).size.width * 0.2 > minWidth
        ? MediaQuery.of(parentContext).size.width * 0.2
        : minWidth;

    showDialog<dynamic>(
      context: parentContext,
      barrierColor: hideBackgroundShadow ? null : Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final dialogContext = context;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            width: width,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Form(
              child: ScrollConfiguration(
                behavior: const CustomScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 0.15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: negativeButtonText != null ||
                            positiveButtonText != null,
                        child: SizedBox(height: contentButtonSpacing),
                      ),
                      Row(
                        mainAxisAlignment: negativeButtonText != null &&
                                positiveButtonText != null
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (negativeButtonText != null)
                            ElevatedButton(
                              child: Text(negativeButtonText),
                              onPressed: () {
                                if (negativeCallback != null) {
                                  negativeCallback();
                                }
                                Navigator.pop(dialogContext);
                              },
                            ),
                          if (positiveButtonText != null)
                            ElevatedButton(
                              child: Text(positiveButtonText),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                if (positiveCallback != null) {
                                  positiveCallback();
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showCustomContentGenericDialog({
    required BuildContext parentContext,
    required String title,
    required Widget content,
    double minWidth = 0,
    double contentButtonSpacing = 32,
    Color? backgroundColor,
    String? negativeButtonText,
    String? positiveButtonText,
    Color? positiveButtonColor,
    VoidCallback? negativeCallback,
    VoidCallback? positiveCallback,
    bool hideBackgroundShadow = false,
  }) {
    final width = MediaQuery.of(parentContext).size.width * 0.2 > minWidth
        ? MediaQuery.of(parentContext).size.width * 0.2
        : minWidth;

    showDialog<dynamic>(
      context: parentContext,
      barrierColor: hideBackgroundShadow ? null : Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final dialogContext = context;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            width: width,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Form(
              child: ScrollConfiguration(
                behavior: const CustomScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 0.15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      content,
                      Visibility(
                        visible: negativeButtonText != null ||
                            positiveButtonText != null,
                        child: SizedBox(height: contentButtonSpacing),
                      ),
                      Row(
                        mainAxisAlignment: negativeButtonText != null &&
                                positiveButtonText != null
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (negativeButtonText != null)
                            ElevatedButton(
                              child: Text(negativeButtonText),
                              onPressed: () {
                                if (negativeCallback != null) {
                                  negativeCallback();
                                }
                                Navigator.pop(dialogContext);
                              },
                            ),
                          if (positiveButtonText != null)
                            ElevatedButton(
                              child: Text(positiveButtonText),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                if (positiveCallback != null) {
                                  positiveCallback();
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
