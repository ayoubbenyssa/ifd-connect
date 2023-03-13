library navigation_dot_bar;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/Fonts.dart';

class BottomNavigationDotBar extends StatefulWidget {
  final List<BottomNavigationDotBarItem> items;
  final Color activeColor;
  final Color color;
  final Function func;
  final int indexPageSelected;

  const BottomNavigationDotBar(
      {@required this.items,
      this.activeColor,
      this.color,
      this.indexPageSelected,
        this.func,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationDotBarState();
}

class _BottomNavigationDotBarState extends State<BottomNavigationDotBar> {
  GlobalKey _keyBottomBar = GlobalKey();
  double _numPositionBase, _numDifferenceBase, _positionLeftIndicatorDot;
  int _indexPageSelected = 0;
  Color _color, _activeColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _color = widget.color ?? Colors.black45;
    _activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    _indexPageSelected = widget.indexPageSelected;
    final sizeBottomBar =
        (_keyBottomBar.currentContext.findRenderObject() as RenderBox).size;
    _numPositionBase = ((sizeBottomBar.width / widget.items.length));
    _numDifferenceBase = (_numPositionBase - (_numPositionBase / 2) + 2);
    setState(() {
      _positionLeftIndicatorDot = _numPositionBase - _numDifferenceBase;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        padding:
            EdgeInsets.only(top: 8.w, bottom: 8.w, left: 24.w, right: 24.w),
        //margin: EdgeInsets.symmetric(horizontal: 16.w),
        child:  Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                  border: new Border.all(
                      color: Fonts.col_grey.withOpacity(0.4), width: 1.2),
                  borderRadius: BorderRadius.circular(62.r),
                  color: Colors.white),
              // padding: EdgeInsets.symmetric(vertical: 0.h),
              child: Stack(
                key: _keyBottomBar,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h, top: 4.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _createNavigationIconButtonList(
                            widget.items.asMap())),
                  ),
                  /* AnimatedPositioned(
                      child: CircleAvatar(
                          radius: 2.5, backgroundColor: _activeColor),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      left: _positionLeftIndicatorDot,
                      bottom: 0),*/
                ],
              ),
            ),
      );

  List<_NavigationIconButton> _createNavigationIconButtonList(
      Map<int, BottomNavigationDotBarItem> mapItem) {
    List<_NavigationIconButton> children = List<_NavigationIconButton>();
    mapItem.forEach((index, item) => children.add(_NavigationIconButton(
            item.icon,
            item.name,
            (index == _indexPageSelected) ? _activeColor : _color,
            item.onTap, () {
          _changeOptionBottomBar(index);
        }, widget.func)));
    return children;
  }

  void _changeOptionBottomBar(int indexPageSelected) {
    if (indexPageSelected != _indexPageSelected) {
      setState(() {
        _positionLeftIndicatorDot =
            (_numPositionBase * (indexPageSelected + 1)) - _numDifferenceBase;
        _indexPageSelected = indexPageSelected;
      });
    }
  }
}

class BottomNavigationDotBarItem {
  final String icon;
  final NavigationIconButtonTapCallback onTap;
  final String name;
  final int indexPageSelected;

  const BottomNavigationDotBarItem(
      {@required this.icon,
      @required this.name,
      this.onTap,
      this.indexPageSelected})
      : assert(icon != null);
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {
  final String _icon;
  final String _name;
  final Function func;

  final Color _colorIcon;
  final NavigationIconButtonTapCallback _onTapInternalButton;
  final NavigationIconButtonTapCallback _onTapExternalButton;

  const _NavigationIconButton(this._icon, this._name, this._colorIcon,
      this._onTapInternalButton, this._onTapExternalButton,this.func,
      {Key key})
      : super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _scaleAnimation;
  double _opacityIcon = 1;
  Function func;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.93).animate(_controller);
  }

  @override
  Widget build(BuildContext context) => widget._icon == "add"
      ? FloatingActionButton(
          onPressed: () {
            //show();
            widget.func();
          },
          child: SvgPicture.asset(
           "assets/icons/Plus.svg",
            width: 24.w,
            color: Colors.white,
          ),
          backgroundColor: Fonts.col_app,
        )
      : GestureDetector(
          onTapDown: (_) {
            _controller.forward();
            setState(() {
              _opacityIcon = 0.7;
            });
          },
          onTapUp: (_) {
            _controller.reverse();
            setState(() {
              _opacityIcon = 1;
            });
          },
          onTapCancel: () {
            _controller.reverse();
            setState(() {
              _opacityIcon = 1;
            });
          },
          onTap: () {
            widget._onTapInternalButton();
            widget._onTapExternalButton();
          },
          child: ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedOpacity(
                  opacity: _opacityIcon,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(widget._icon,
                          width: 24.w,
                         // height: 28.h,
                          fit: BoxFit.contain,
                          color: widget._colorIcon),
                      Container(height: 4.h),
                      Text(widget._name,
                          style: TextStyle(
                              color: widget._colorIcon,
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.w600)),
                      /* Container(height: 4.h),
                  Container(
                      width: 32.w, height: 3.5.h, color: widget._colorIcon),*/
                    ],
                  ))));
}
