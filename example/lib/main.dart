import 'package:example/example_candidate_model.dart';
import 'package:example/example_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    ),
  );
}

class Example extends StatefulWidget {
  const Example({
    super.key,
  });

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final CardSwiperController controller = CardSwiperController();
  final List<Widget> cards = candidates.map(ExampleCard.new).toList();
  CardSwiperDirection? _previousSwipeDirection;
  int _currentTopCardIndex = 0; // To track the current top card index
  int? _specialCardIndex;
  bool _hasSwipedRightStarted = false; // To prevent multiple insertions

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleRightSwipeStart(int index) {
    print("Right swipe started at index: $index");
    if (!_hasSwipedRightStarted) {
      setState(() {
        _hasSwipedRightStarted = true;
        _specialCardIndex = index + 1;
        cards.insert(
          _specialCardIndex!,
          ExampleCard(ExampleCandidateModel(
              name: 'Special',
              job: 'Test',
              city: 'Valencia',
              color: Colors.accents)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onSwipeDirectionChange: _onSwipeDirectionChange,
                onRightSwipeStart: _handleRightSwipeStart,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index % cards.length],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.bottom),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (currentIndex != null) {
      setState(() {
        _currentTopCardIndex = currentIndex % cards.length;
        _hasSwipedRightStarted = false;
      });
    }
    return true;
  }

  void _onSwipeDirectionChange(CardSwiperDirection newDirection, CardSwiperDirection? previousDirection) {
    debugPrint('Swipe Direction Changed - Previous: $previousDirection, New: $newDirection');
    setState(() {
      _previousSwipeDirection = newDirection;
    });
  }

  

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}