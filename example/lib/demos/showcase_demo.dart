import 'package:division/division.dart';
import 'package:flutter/material.dart';

/// A screen built entirely out of `Parent` and `Txt`, to show how the pieces
/// read together rather than one method at a time.
class ShowcaseDemo extends StatefulWidget {
  const ShowcaseDemo({super.key});

  @override
  State<ShowcaseDemo> createState() => _ShowcaseDemoState();
}

class _ShowcaseDemoState extends State<ShowcaseDemo> {
  int _selected = 0;
  bool _following = false;

  static const List<String> _tabs = <String>['Overview', 'Stats', 'About'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#f4f5f7'),
      appBar: AppBar(title: const Text('Showcase')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
        children: <Widget>[
          _header(),
          const SizedBox(height: 16),
          _tabBar(),
          const SizedBox(height: 16),
          _statsRow(),
          const SizedBox(height: 16),
          _noticeCard(),
          const SizedBox(height: 16),
          _uploadZone(),
        ],
      ),
    );
  }

  Widget _header() {
    return Parent(
      style: ParentStyle()
        ..height(180)
        ..borderRadius(all: 18)
        ..overflow.hidden()
        ..background.image(
          path: 'assets/images/texture.png',
          fit: BoxFit.cover,
        ),
      child: Parent(
        style: ParentStyle()
          ..padding(all: 20)
          ..alignmentContent.bottomLeft()
          ..linearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              const Color(0x00000000),
              const Color(0xCC000000),
            ],
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt(
              'Division',
              style: TxtStyle()
                ..fontSize(30)
                ..bold()
                ..textColor(Colors.white)
                ..textElevation(4),
            ),
            Txt(
              'CSS-flavoured styling for Flutter widgets',
              style: TxtStyle()
                ..margin(top: 4)
                ..fontSize(13)
                ..textColor(Colors.white70),
            ),
            Txt(
              _following ? 'Following ✓' : 'Follow',
              style: TxtStyle()
                ..margin(top: 14)
                ..padding(horizontal: 20, vertical: 9)
                ..borderRadius(all: 20)
                ..bold()
                ..fontSize(13)
                ..background.color(_following ? Colors.white24 : Colors.white)
                ..textColor(_following ? Colors.white : hex('#3a7bd5'))
                ..ripple(true)
                ..animate(250, Curves.easeOut),
              gesture: Gestures()
                ..onTap(() => setState(() => _following = !_following)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Parent(
      style: ParentStyle()
        ..padding(all: 4)
        ..borderRadius(all: 12)
        ..background.color(Colors.white),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _tabs.length; i++)
            Expanded(
              child: Txt(
                _tabs[i],
                style: TxtStyle()
                  ..padding(vertical: 11)
                  ..borderRadius(all: 9)
                  ..fontSize(13)
                  ..bold(_selected == i)
                  ..textAlign.center()
                  ..background.color(
                      _selected == i ? hex('#3a7bd5') : Colors.transparent)
                  ..textColor(_selected == i ? Colors.white : Colors.black54)
                  ..animate(200, Curves.easeOut),
                gesture: Gestures()..onTap(() => setState(() => _selected = i)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: <Widget>[
        Expanded(child: _stat('Downloads', '48.2k', Colors.indigo)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Likes', '1.9k', Colors.pink)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Issues', '3', Colors.orange)),
      ],
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Parent(
      style: ParentStyle()
        ..padding(vertical: 16)
        ..borderRadius(all: 12)
        ..alignmentContent.center()
        ..background.color(Colors.white)
        ..boxShadow(
            color: Colors.black12, blur: 10, offset: const Offset(0, 4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Txt(
            value,
            style: TxtStyle()
              ..fontSize(20)
              ..bold()
              ..textColor(color),
          ),
          Txt(
            label,
            style: TxtStyle()
              ..margin(top: 2)
              ..fontSize(11)
              ..textColor(Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _noticeCard() {
    return Parent(
      style: ParentStyle()
        ..padding(all: 16)
        ..borderRadius(all: 12)
        ..background.hex('#fff8e1')
        ..border(left: 4, color: Colors.amber.shade700),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline, color: Colors.amber.shade800, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Txt(
                  'One-sided borders',
                  style: TxtStyle()
                    ..bold()
                    ..fontSize(14),
                ),
                Txt(
                  'This accent bar is a single `border(left: 4)` — no extra '
                  'widget needed.',
                  style: TxtStyle()
                    ..margin(top: 3)
                    ..fontSize(12)
                    ..textColor(Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadZone() {
    return Parent(
      style: ParentStyle()
        ..height(120)
        ..borderRadius(all: 12)
        ..alignmentContent.center()
        ..dashBorder(color: Colors.black26, strokeWidth: 2, dashLength: 8)
        ..ripple(true),
      gesture: Gestures()..onTap(() {}),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.cloud_upload_outlined,
              size: 28, color: Colors.black38),
          Txt(
            'Drop a file here',
            style: TxtStyle()
              ..margin(top: 8)
              ..fontSize(13)
              ..textColor(Colors.black54),
          ),
        ],
      ),
    );
  }
}
