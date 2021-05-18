import 'package:flutter/material.dart';
import 'package:flutter_ddd/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureDisplay({Key? key, required this.failure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("🙀", style: TextStyle(fontSize: 100)),
          Text(
            failure.maybeMap(
              orElse: () => "Unexpected Error\n Please contact support",
            ),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () => needHelpClicked(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.email),
                SizedBox(width: 4),
                Text("I NEED HELP"),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: avoid_print
  void needHelpClicked() => print("Sending Email");
}
