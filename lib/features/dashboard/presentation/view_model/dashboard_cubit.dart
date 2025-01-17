import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
