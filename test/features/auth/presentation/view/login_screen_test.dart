import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/auth/presentation/view/login_screen.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';


class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget loadLoginScreen() {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('check for the text in login UI', (tester) async {
    await tester.pumpWidget(loadLoginScreen());

    await tester.pumpAndSettle();

    // find button by text
    final result = find.widgetWithText(ElevatedButton, 'Sign in');
    expect(result, findsOneWidget);
  });

  testWidgets('check for username and password input', (tester) async {
    await tester.pumpWidget(loadLoginScreen());

    await tester.pumpAndSettle();

    // enter username and password
    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    // press the sign in button
    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.text('kiran'), findsOneWidget);
    expect(find.text('kiran123'), findsOneWidget);
  });




  testWidgets('login success', (tester) async {
    when(() => loginBloc.state)
        .thenReturn(LoginState(isLoading: false, isSuccess: true));

    await tester.pumpWidget(loadLoginScreen());

    await tester.pumpAndSettle();

    // enter username and password
    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    // press the sign in button
    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}
