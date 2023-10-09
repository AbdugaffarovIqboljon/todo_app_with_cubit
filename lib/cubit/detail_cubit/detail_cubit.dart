import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:learn_bloc/main.dart';
import 'package:learn_bloc/model/todo_model.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailInitial());

  void create(String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      emit(const DetailFailure(message: "Please fill in all the fields"));
      return;
    }
    emit(DetailLoading());
    try {
      final todo = Todo(
        id: 1,
        title: title,
        description: description,
        isCompleted: false,
      );
      await sql.insert(todo);
      emit(DetailCreateSuccess());
    } catch (e) {
      debugPrint("Error: $e");
      emit(DetailFailure(message: "DETAIL ERROR:$e"));
    }
  }

  void delete(int id) async {
    emit(DetailLoading());
    try {
      await sql.delete(id);
      emit(DetailDeleteSuccess());
    } catch (e) {
      debugPrint("Error: $e");
      emit(DetailFailure(message: "DETAIL ERROR:$e"));
    }
  }

  void edit(String title, String description, int id) async {
    emit(DetailLoading());

    try {
      if (title.isEmpty || description.isEmpty) {
        emit(const DetailFailure(message: "Please fill in all the fields"));
        return;
      }
      await sql.delete(id);

      final todo = Todo(
        id: 1,
        title: title,
        description: description,
        isCompleted: false,
      );

      await sql.insert(todo);
      emit(DetailCreateSuccess());
    } catch (e) {
      emit(DetailFailure(message: "Detail Error : $e"));
    }
  }

  void complete(Todo todo) async {
    emit(DetailLoading());
    try {
      todo.isCompleted = !todo.isCompleted;
      sql.update(todo);
      emit(DetailUpdateSuccess());
    } catch (e) {
      emit(DetailFailure(message: "DETAIL ERROR: $e"));
    }

  }
}
