import 'package:flutter/material.dart';

/// Standard page scaffold: safe area, max content width on large screens,
/// and consistent horizontal padding.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.scrollable = true,
    this.maxContentWidth = 640,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: body);
    if (scrollable) {
      content = SingleChildScrollView(
        padding: padding.add(const EdgeInsets.only(bottom: 32)),
        child: body,
      );
    }
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: content,
          ),
        ),
      ),
    );
  }
}
