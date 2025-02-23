// test/features/dashboard/presentation/view_model/dashboard_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_state.dart';

void main() {
  group('DashboardCubit', () {
    late DashboardCubit dashboardCubit;

    setUp(() {
      dashboardCubit = DashboardCubit();
    });

    tearDown(() {
      dashboardCubit.close();
    });

    test('initial state is DashboardState.initial()', () {
      final initialState = DashboardState.initial();
      expect(dashboardCubit.state.selectedIndex, equals(initialState.selectedIndex));
      expect(dashboardCubit.state.views.length, equals(initialState.views.length));
    });

    blocTest<DashboardCubit, DashboardState>(
      'emits state with updated selectedIndex when onTabTapped is called',
      build: () => DashboardCubit(),
      act: (cubit) => cubit.onTabTapped(2),
      expect: () => [
        isA<DashboardState>()
            .having((state) => state.selectedIndex, 'selectedIndex', equals(2))
            .having((state) => state.views.length, 'views length', equals(4)),
      ],
    );
  });
}
