import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int itemCount;
  final Color badgeColor;
  final Color badgeTextColor;

  const CartButton({
    Key key,
    @required this.itemCount,
    this.onPressed,
    this.badgeColor = Colors.red,
    this.badgeTextColor = Colors.white,
  })  : assert(itemCount >= 0),
        assert(badgeColor != null),
        assert(badgeTextColor != null),
        super(key: key);

  @override
  CartButtonState createState() => CartButtonState();
}

class CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  final Tween<Offset> _badgePositionTween = Tween(
    begin: const Offset(-0.5, 0.9),
    end: const Offset(0, 0),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        overflow: Overflow.visible,
        children: [
          const Icon(Icons.shopping_cart),
          Positioned(
            top: -8,
            right: -3,
            child: SlideTransition(
              position: _badgePositionTween.animate(_animation),
              child: Material(
                type: MaterialType.circle,
                elevation: 2,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.itemCount.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.badgeTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: widget.onPressed,
    );
  }

  @override
  void didUpdateWidget(CartButton oldWidget) {
    if (widget.itemCount != oldWidget.itemCount) {
      _animationController
        ..reset()
        ..forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
