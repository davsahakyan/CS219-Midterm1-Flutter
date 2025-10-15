import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../models/homework.dart';
import '../repository/homework_repository.dart';

enum HomeworkStatus { initial, loading, ready }

class HomeworkState extends Equatable {
  final HomeworkStatus status;
  final List<Homework> items;

  const HomeworkState({required this.status, required this.items});

  const HomeworkState.initial() : this(status: HomeworkStatus.initial, items: const []);

  HomeworkState copyWith({HomeworkStatus? status, List<Homework>? items}) =>
      HomeworkState(status: status ?? this.status, items: items ?? this.items);

  @override
  List<Object?> get props => [status, items];
}

abstract class HomeworkEvent extends Equatable {
  const HomeworkEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomework extends HomeworkEvent {}

class AddHomeworkEvent extends HomeworkEvent {
  final String subject;
  final String title;
  final DateTime dueDate;
  const AddHomeworkEvent({required this.subject, required this.title, required this.dueDate});

  @override
  List<Object?> get props => [subject, title, dueDate];
}

class ToggleCompleteEvent extends HomeworkEvent {
  final String id;
  const ToggleCompleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc(this.repository) : super(const HomeworkState.initial()) {
    on<LoadHomework>(_onLoad);
    on<AddHomeworkEvent>(_onAdd);
    on<ToggleCompleteEvent>(_onToggle);
  }

  final HomeworkRepository repository;

  Future<void> _onLoad(LoadHomework event, Emitter<HomeworkState> emit) async {
    emit(state.copyWith(status: HomeworkStatus.loading));
    final items = await repository.fetchAll();
    emit(state.copyWith(status: HomeworkStatus.ready, items: items));
  }

  Future<void> _onAdd(AddHomeworkEvent event, Emitter<HomeworkState> emit) async {
    final newItem = Homework(
      id: const Uuid().v4(),
      subject: event.subject.trim(),
      title: event.title.trim(),
      dueDate: event.dueDate,
    );
    final updated = List<Homework>.from(state.items)..add(newItem);
    await repository.saveAll(updated);
    emit(state.copyWith(items: updated));
  }

  Future<void> _onToggle(ToggleCompleteEvent event, Emitter<HomeworkState> emit) async {
    final updated = state.items.map((h) {
      if (h.id == event.id) {
        return h.copyWith(completed: !h.completed);
      }
      return h;
    }).toList();
    await repository.saveAll(updated);
    emit(state.copyWith(items: updated));
  }
}