import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'comm_bottom_nav_state.dart';

class CommBottomNavCubit extends Cubit<CommBottomNavState> {
  CommBottomNavCubit() : super(CommBottomNavState(btnNo: 1));

  void changeId(int btnNo) {
    emit(CommBottomNavState(btnNo: btnNo));
  }
}
