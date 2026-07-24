import '../../../shared.dart';



class JudgeProgressInline extends StatelessWidget {

  const JudgeProgressInline({

    super.key,

    required this.total,

    required this.scored,

    required this.unscored,

  });



  final int total;

  final int scored;

  final int unscored;



  @override

  Widget build(BuildContext context) {

    final progress = total == 0 ? 0.0 : scored / total;

    final seal = context.sealTheme;

    return Semantics(

      label: L10nService.strings.scoringProgressSemantic(scored, unscored),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          Text(

            '$scored/$total ${L10nService.strings.scoringProgressTitle.toLowerCase()}',

            style: TextStyle(

              color: seal.onSurfaceVariant,

              fontWeight: FontWeight.w700,

            ),

          ),

          const SizedBox(height: 6),

          ClipRRect(

            borderRadius: BorderRadius.circular(999),

            child: LinearProgressIndicator(

              value: progress,

              minHeight: 6,

              color: unscored == 0 ? context.sealSecondary : context.sealPrimary,

              backgroundColor: seal.surfaceContainerHighest,

            ),

          ),

        ],

      ),

    );

  }

}

