import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget? leading;

  const CustomAppbar({super.key, this.leading});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.systemGrey.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            border: null,
            leading: leading,
            automaticallyImplyLeading: false,
            middle: Container(), 
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}
