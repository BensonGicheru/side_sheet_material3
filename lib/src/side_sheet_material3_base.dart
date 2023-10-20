import 'package:flutter/material.dart';

/// Displays a Material Design 3 side sheet as a general dialog.
///
/// The [header] is a required string for the title of the side sheet.
///
/// The [body] is a required widget for the content of the side sheet.
///
/// The [barrierDismissible] boolean value determines if the dialog can be dismissed
/// by tapping outside of it or not. By default, it is set to false.
///
/// The [addBackIconButton] boolean value determines if the side sheet should
/// display a back button to close the dialog. By default, it is set to false.
///
/// The [addCloseIconButton] boolean value determines if the side sheet should
/// display a close button to close the dialog. By default, it is set to `true`.
///
/// The [addActions] boolean value determines if the side sheet should display
/// the action buttons or not. By default, it is set to `true`.
///
/// The [addDivider] boolean value determines if the side sheet should display
/// a divider between the body and action buttons or not. By default, it is set to `true`.
///
/// The [confirmActionTitle] is a string value for the text of the confirm action button.
/// By default, it is set to 'Save'.
///
/// The [cancelActionTitle] is a string value for the text of the cancel action button.
/// By default, it is set to 'Cancel'.
///
/// The [confirmActionOnPressed] is a function that will be called when the confirm action button
/// is pressed. By default, it is set to null.
///
/// The [cancelActionOnPressed] is a function that will be called when the cancel action button
/// is pressed. By default, it is set to null.
///
/// The [onClose] is a function that will be called when the close action button
/// is pressed. By default, it will call `Navigator.pop(context)`.
///
/// The [onDismiss] is a function that will be called when you dismiss side sheet
/// By default, it is set to null`.
///
/// The [closeButtonTooltip] is a string value for the text of the close button tooltip.
/// By default, it is set to 'Close'.
///
/// The [backButtonTooltip] is a string value for the text of the back button tooltip.
/// By default, it is set to 'Back'.
///
/// Example:
/// ```
/// await showSideSheet(
///   context: context,
///   header: 'Edit Profile',
///   body: ProfileEditForm(),
///   addBackIconButton: true,
///   addActions: true,
///   addDivider: true,
///   confirmActionTitle: 'Save',
///   cancelActionTitle: 'Cancel',
///   confirmActionOnPressed: () {
///     // Do something
///   },
///   cancelActionOnPressed: () {
///     // Do something
///   },
/// );
/// ```
Future<void> showModalSideSheet(
  BuildContext context, {
  required double width,
  required double height,
  required Widget body,
  required bool rightSide,
  required BorderRadius borderRadius,
  required Color color,
  required Color surfaceTintColor,
  bool barrierDismissible = false,
  bool addActions = true,
  bool addDivider = true,
  bool safeAreaTop = true,
  bool safeAreaBottom = false,
  String confirmActionTitle = 'Save',
  String cancelActionTitle = 'Cancel',
  void Function()? confirmActionOnPressed,
  void Function()? cancelActionOnPressed,
  void Function()? onDismiss,
  void Function()? onClose,
  Duration? transitionDuration,
}) async {
  await showGeneralDialog(
    context: context,
    transitionDuration: transitionDuration ?? Duration(milliseconds: 500),
    barrierDismissible: barrierDismissible,
    barrierColor: Theme.of(context).colorScheme.scrim.withOpacity(0.3),
    barrierLabel: 'Material 3 side sheet',
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset((rightSide ? 1 : -1), 0), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation1, animation2) {
      return Align(
        alignment: (rightSide ? Alignment.centerRight : Alignment.centerLeft),
        child: SideSheetMaterial3(
          width: width,
          height: height,
          body: body,
          rightSide: rightSide,
          borderRadius: borderRadius,
          color: color,
          surfaceTintColor: surfaceTintColor,
          addActions: addActions,
          addDivider: addDivider,
          safeAreaTop: safeAreaTop,
          safeAreaBottom: safeAreaBottom,
          confirmActionOnPressed: confirmActionOnPressed,
          cancelActionOnPressed: cancelActionOnPressed,
          confirmActionTitle: confirmActionTitle,
          cancelActionTitle: cancelActionTitle,
          onClose: onClose,
        ),
      );
    },
  ).then(
    (value) {
      if (!barrierDismissible) return;
      if (onDismiss != null) {
        onDismiss();
      }
    },
  );
}

class SideSheetMaterial3 extends StatelessWidget {
  final double width;
  final double height;
  final Widget body;
  final bool rightSide;
  final BorderRadius borderRadius;
  final Color color;
  final Color surfaceTintColor;
  final bool addActions;
  final bool addDivider;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final String confirmActionTitle;
  final String cancelActionTitle;

  final void Function()? confirmActionOnPressed;
  final void Function()? cancelActionOnPressed;
  final void Function()? onClose;
  const SideSheetMaterial3({
    super.key,
    required this.width,
    required this.height,
    required this.body,
    required this.rightSide,
    required this.borderRadius,
    required this.color,
    required this.surfaceTintColor,
    required this.addActions,
    required this.addDivider,
    required this.safeAreaBottom,
    required this.safeAreaTop,
    required this.cancelActionOnPressed,
    required this.confirmActionOnPressed,
    required this.cancelActionTitle,
    required this.confirmActionTitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 1,
      color: color,
      surfaceTintColor: surfaceTintColor,
      borderRadius: borderRadius,
      child: SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        minimum: EdgeInsets.only(top: 24),
        child: Container(
          constraints: BoxConstraints(
            minWidth: width,
            maxWidth: width <= size.width ? width : size.width,
            minHeight: height,
            maxHeight: height <= size.height ? height : size.height,
          ),
          child: Column(
            children: [
              Expanded(
                child: body,
              ),
              Visibility(
                visible: addActions,
                child: _buildFooter(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: addDivider,
          child: const Divider(
            indent: 24,
            endIndent: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16, 24, 24),
          child: Row(
            children: [
              FilledButton(
                onPressed: confirmActionOnPressed,
                child: Text(confirmActionTitle),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  if (cancelActionOnPressed == null) {
                    Navigator.pop(context);
                  } else {
                    cancelActionOnPressed!();
                  }
                },
                child: Text(cancelActionTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
