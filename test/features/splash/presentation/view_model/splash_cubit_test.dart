// test/features/splash/presentation/view_model/splash_cubit_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/features/auth/presentation/view/login_screen.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/dashboard/presentation/dashboard_view.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fake PostBloc so that DashboardView can retrieve one.
class FakePostBloc extends Fake {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    // Register a dummy DashboardCubit (if needed) and the missing PostBloc.
    getIt.registerSingleton<DashboardCubit>(DashboardCubit());
    getIt.registerSingleton<FakePostBloc>(FakePostBloc());
    // If DashboardView uses getIt<PostBloc>(), you can register it like:
    // getIt.registerSingleton<PostBloc>(FakePostBloc());
  });

  tearDown(() {
    getIt.reset();
  });

  group('SplashCubit Navigation', () {
    late LoginBloc loginBloc;
    late SplashCubit splashCubit;

    setUp(() {
      loginBloc = FakeLoginBloc(); // Create a FakeLoginBloc as needed.
      splashCubit = SplashCubit(loginBloc);
    });


    testWidgets('navigates to LoginScreen when tokens do not exist', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'accessToken': '',
        'refreshToken': '',
        'userID': '',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            splashCubit.init(context);
            return Container();
          }),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(DashboardView), findsNothing);
    });
  });
}

// Minimal FakeLoginBloc implementation.
class FakeLoginBloc extends Fake implements LoginBloc {}
