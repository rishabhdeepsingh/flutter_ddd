import 'package:dartz/dartz.dart';
import 'package:flutter_ddd/domain/notes/note.dart';
import 'package:flutter_ddd/domain/notes/note_failure.dart';
import 'package:kt_dart/collection.dart';

abstract class INoteRepository {
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  Stream<Either<NoteFailure, KtList<Note>>> watchUncomplete();
  Stream<Either<NoteFailure, Unit>> create();
  Stream<Either<NoteFailure, Unit>> update();
  Stream<Either<NoteFailure, Unit>> delete();
}
