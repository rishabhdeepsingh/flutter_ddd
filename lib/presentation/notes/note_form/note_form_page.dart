import 'package:dartz/dartz.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_ddd/domain/notes/note.dart';
import 'package:flutter_ddd/injection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_ddd/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:flutter_ddd/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:flutter_ddd/presentation/routes/router.gr.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({Key? key, this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (prev, curr) =>
            prev.saveFailureOrSuccessOption != curr.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(() {}, (either) {
            either.fold(
              (failure) => FlushbarHelper.createError(
                  message: failure.map(
                insufficientPermissions: (_) => 'Insufficient permissions ❌',
                unableToUpdate: (_) =>
                    "Couldn't update the note. Was it deleted from another device?",
                unexpected: (_) =>
                    'Unexpected error occured, please contact support.',
              )).show(context),
              (_) => {
                // why popUntil coz FlushBar is also a route.
                context.router.popUntil((route) {
                  return route.settings.name == NotesOverviewPageRoute.name;
                })
              },
            );
          });
        },
        buildWhen: (prev, curr) => prev.isSaving != curr.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              NoteFormPageScaffold(),
              SavingInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                "Saving",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (prev, curr) => prev.isEditing != curr.isEditing,
          builder: (context, state) {
            return Text("${state.isEditing ? "Editing" : "Create"} a Note");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  BodyField(),
                  ColorField(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
