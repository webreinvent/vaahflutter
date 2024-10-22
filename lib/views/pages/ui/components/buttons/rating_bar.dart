import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/widgets/atoms/rating_bar.dart';
import '../code_preview.dart';
import '../commons.dart';

class RatingBarPreview extends StatelessWidget {
  const RatingBarPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rating Bar', style: heading),
        verticalMargin16,
        RatingBar(
          unratedColor: Colors.amber.withOpacity(0.3),
          ratedColor: Colors.amber,
          onRatingUpdate: (_) {
            // Log.info(_.toString(), disableCloudLogging: true);
          },
        ),
      ],
    );
  }
}

class RatingBarCode extends StatelessWidget {
  const RatingBarCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CodePreview(
          code: [
            "RatingBar(",
            "    unratedColor: Colors.amber.withOpacity(0.3),",
            "    ratedColor: Colors.amber,",
            "    onRatingUpdate: (_) {",
            "        Log.info(_.toString(), disableCloudLogging: true);",
            "    },",
            "),",
          ],
        ),
      ],
    );
  }
}
