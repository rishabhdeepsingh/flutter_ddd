import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddd/infrastructure/notes/note_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd/domain/notes/note_failure.dart';
import 'package:flutter_ddd/domain/notes/note.dart';
import 'package:flutter_ddd/infrastructure/core/firestore_helpers.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    // users/{User Id}/notes/{Note id}
    final userDocument = await _firestore.userDocument();
    // snapshots is optimized to send only the edited/changed document with caching
    yield* userDocument.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) => right<NoteFailure, KtList<Note>>(
              snapshot.docs
                  .map((doc) => NoteDto.fromFirestore(doc).toDomain())
                  .toImmutableList(),
            ))
        .onErrorReturnWith((e, _) {
      if (e is PlatformException && e.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        // LOG.e("Unexpected");
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncomplete() async* {
    // users/{User Id}/notes/{Note id}
    final userDocument = await _firestore.userDocument();
    // snapshots is optimized to send only the edited/changed document with caching
    yield* userDocument.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NoteDto.fromFirestore(doc).toDomain())
              .toImmutableList(),
        )
        .map((notes) => right<NoteFailure, KtList<Note>>(
              notes.filter((note) =>
                  note.todos.getOrCrash().any((todoItem) => !todoItem.done)),
            ))
        .onErrorReturnWith((e, _) {
      if (e is PlatformException && e.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        // LOG.e("Unexpected");
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message!.contains("NOT_FOUND")) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message!.contains("NOT_FOUND")) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
