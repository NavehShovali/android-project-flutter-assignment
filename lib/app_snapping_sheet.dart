import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'authentication/user_repository.dart';

class AppSnappingSheet extends StatefulWidget {
  final Widget child;
  final BuildContext scaffoldContext;

  AppSnappingSheet({
    @required this.child,
    @required this.scaffoldContext,
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppSnappingSheetState();
}

class _AppSnappingSheetState extends State<AppSnappingSheet> with SingleTickerProviderStateMixin {
  final profilePicturePicker = ImagePicker();
  final _sheetController = SnappingSheetController();
  AnimationController _arrowIconAnimationController;
  Animation<double> _arrowIconAnimation;
  bool _blur = false;
  double _position;

  @override
  void initState() {
    super.initState();
    _arrowIconAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _arrowIconAnimation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(
            curve: Curves.elasticOut,
            reverseCurve: Curves.elasticIn,
            parent: _arrowIconAnimationController
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);

    if (userRepository.status != Status.Authenticated) {
      return widget.child;
    }

    final parentSize = MediaQuery.of(context).size.height / 2;
    final blurAmount = _position != null ? 15.0 * ((_position - 50) / parentSize) : null;

    return SnappingSheet(
      child: widget.child,
      snappingSheetController: _sheetController,
      snapPositions: const [
        SnapPosition(positionPixel: 0.0, snappingCurve: Curves.elasticOut, snappingDuration: Duration(milliseconds: 750)),
        SnapPosition(positionFactor: 0.2),
      ],
      onSnapEnd: () {
        if (_sheetController.snapPositions.last != _sheetController.currentSnapPosition) {
          _arrowIconAnimationController.reverse();
        } else {
          _arrowIconAnimationController.forward();
        }
      },
      onMove: (moveAmount) {
        setState(() {
          _blur = moveAmount >= 50;
          _position = moveAmount;
        });
      },
      grabbingHeight: MediaQuery.of(context).padding.bottom + 50,
      grabbing: InkWell(
        onTap: toggleExpanded,
        child: Container(
          padding: EdgeInsets.all(15.0),
          color: Colors.blueGrey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Welcome back, ${userRepository.user?.email}'
              ),
              RotationTransition(
                child: Icon(Icons.keyboard_arrow_up_rounded),
                turns: _arrowIconAnimation,
              )
            ],
          ),
        ),
      ),
      sheetBelow: SnappingSheetContent(
        child: UserProfile(scaffoldContext: widget.scaffoldContext)
      ),
      sheetAbove: _blur
          ? SnappingSheetContent(
              child: GestureDetector(
                onTap: toggleExpanded,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                        sigmaX: blurAmount > 5.0 ? 5.0 : blurAmount,
                        sigmaY: blurAmount > 5.0 ? 5.0 : blurAmount
                    ),
                    child: Container(color: Colors.transparent,),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  void toggleExpanded() {
    if (_sheetController.snapPositions.last != _sheetController.currentSnapPosition) {
      _sheetController.snapToPosition(_sheetController.snapPositions.last);
    } else {
      _sheetController.snapToPosition(_sheetController.snapPositions.first);
    }
  }
}