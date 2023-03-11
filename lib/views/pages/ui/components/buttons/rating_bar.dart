import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/services/logging_library/logging_library.dart';
import '../../../../../vaahextendflutter/widgets/atoms/rating_bar.dart';
import '../code_preview.dart';
import '../commons.dart';

class RatingBarPreview extends StatelessWidget {
  const RatingBarPreview({Key? key}) : super(key: key);

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
            Log.info(_.toString(), disableCloudLogging: true);
          },
        ),
      ],
    );
  }
}

class RatingBarCode extends StatelessWidget {
  const RatingBarCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
