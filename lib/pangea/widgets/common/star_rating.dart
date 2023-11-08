import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color color;

  StarRating(
      {Key? key,
      this.starCount = 5,
      this.rating = 0,
      this.onRatingChanged,
      required this.color})
      : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,
        size: 20, color: Color(0xffFFC403),
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        //?? Theme.of(context).primaryColor,
        size: 20,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        //?? Theme.of(context).primaryColor,
        size: 20,
      );
    }
    return InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
