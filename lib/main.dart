import 'package:body_selector/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'انتخاب‌گر بدن',
      home: BodySelectorPage(),
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}

class BodySelectorPage extends StatefulWidget {
  const BodySelectorPage({super.key});

  @override
  State<BodySelectorPage> createState() => _BodySelectorPageState();
}

class _BodySelectorPageState extends State<BodySelectorPage> {
  final TransformationController _controller = TransformationController();
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('انتخاب‌گر بدن')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final svgAspect = 146.0 / 338.0;

            double displayWidth = constraints.maxWidth;
            double displayHeight = constraints.maxHeight;

            if (displayWidth / displayHeight > svgAspect) {
              displayWidth = displayHeight * svgAspect;
            } else {
              displayHeight = displayWidth / svgAspect;
            }

            return Center(
              child: SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: Stack(
                  children: [
                    // Interactive viewer ONLY for body and regions
                    InteractiveViewer(
                      transformationController: _controller,
                      minScale: 1,
                      maxScale: 5,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: SizedBox(
                        width: displayWidth,
                        height: displayHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: SvgPicture.asset(
                                'assets/front.svg',
                                fit: BoxFit.contain,
                              ),
                            ),

                            ...regions.map((r) {
                              return Positioned(
                                left: r.x * displayWidth,
                                top: r.y * displayHeight,
                                width: r.w * displayWidth,
                                height: r.h * displayHeight,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      _selected = r.name;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    decoration: BoxDecoration(
                                      color: _selected == r.name
                                          ? Colors.red.withValues(alpha: 0.45)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    // FIXED bottom container OUTSIDE InteractiveViewer
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _selected == null
                                ? 'یک قسمت را انتخاب کنید'
                                : 'انتخاب شده: $_selected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
