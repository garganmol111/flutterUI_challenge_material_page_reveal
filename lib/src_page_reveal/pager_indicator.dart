import 'dart:ui';

import 'package:flutter/material.dart';
import 'pages.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for(var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      var percentActive;
      if(i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if(i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if(i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        new PageBubble(
          viewModel: new PagerBubbleViewModel(
            Colors.white,
            percentActive, 
            page.iconAssetPath, 
            isHollow
          ),
        )
      );
    }

    final BUBBLE_WIDTH = 55.0;
    final baseTranslation = ((viewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2); // based on no. of pages and their rendered container height
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);
    if(viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if(viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,           
          ),
        )
      ],
      
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.activeIndex, this.pages, this.slideDirection, this.slidePercent);
}

class PageBubble extends StatelessWidget {

  final PagerBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: new Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow ? const Color(0x88FFFFFF).withAlpha((0x88 * viewModel.activePercent).round()) : const Color(0x88FFFFFF),
            border: new Border.all(
              color: viewModel.isHollow ? const Color(0x88FFFFFF).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round()) : Colors.transparent,
              width: 3.0
            )
          ),
          child: Opacity(
            opacity: viewModel.activePercent,
            child: new Image.asset(viewModel.iconAssetPath, color: viewModel.color)
          ),
        ),
      ),
    );
  }
}
 
class PagerBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PagerBubbleViewModel(
      this.color, this.activePercent, this.iconAssetPath, this.isHollow);
}
