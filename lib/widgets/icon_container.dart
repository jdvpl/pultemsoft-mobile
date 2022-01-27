import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconContainer extends StatelessWidget {
  final double size;
  const IconContainer({Key key, @required this.size})
      : assert(size != null && size > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(this.size * .15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(this.size * 0.15),
      child: Center(
        child: SvgPicture.asset(
          'assets/icon.svg',
          width: this.size * 0.7,
          height: this.size * 0.7,
        ),
      ),
    );
  }
}
