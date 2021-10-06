import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/data/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final storage = GetStorage();
  final Repository? repository;
  LoginCubit({this.repository}) : super(LoginInitial());
  void login(String username, String password) {
    if (username.isEmpty) {
      emit(LoginError(error: "username is empty"));
      return;
    }
    if (password.isEmpty) {
      emit(LoginError(error: "password is empty"));
      return;
    }
    emit(LoggingIn());
    repository!.login(username, password).then((token) {
      print("alors");
      print(token);
      if (token != null) {
        print(token);
        storage.write("jwt", token);
        emit(LoggedIn());
      }
    });
  }

  void signIn(String username, String password) {
    if (username.length < 4) {
      emit(LoginError(error: "username is too short"));
      return;
    }
    if (password.length < 4) {
      emit(LoginError(error: "password is too short"));
      return;
    }
    emit(LoggingIn());

    repository!.signup(username, password).then((res) {
      if (res == 201) {
        emit(LoggedIn());
      } else if (res == 409) {
        emit(LoginError(error: "This username already exists"));
      } else {
        emit(LoginError(error: "Gomprenpa"));
      }
    });
  }
}
