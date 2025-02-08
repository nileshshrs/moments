import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/auth/presentation/view/registration_screen.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';

// Mock class for RegisterBloc
class MockRegisterBloc extends Mock implements RegisterBloc {
  @override
  Future<void> close() {
    return Future.value();
  }
}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockRegisterBloc mockRegisterBloc;

  // Register the fallback value for RegisterEvent
  setUpAll(() {
    // Registering the fallback value for RegisterUser event
    registerFallbackValue(RegisterUser(
      context: MockBuildContext(), // Using a valid context
      username: 'test',
      email: 'test@example.com',
      password: 'password123',
    ));
  });

  setUp(() {
    // Initialize mock objects before each test
    mockRegisterBloc = MockRegisterBloc();

    // Mock state and stream
    when(() => mockRegisterBloc.state)
        .thenReturn(RegisterState(isLoading: false, isSuccess: false));

    when(() => mockRegisterBloc.stream).thenAnswer(
        (_) => Stream.value(RegisterState(isLoading: false, isSuccess: false)));
  });

  Widget buildRegistrationScreen() {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>(
        create: (_) => mockRegisterBloc,
        child: RegistrationScreen(),
      ),
    );
  }

  testWidgets('Registration screen has correct initial UI', (tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(buildRegistrationScreen());
    await tester.pumpAndSettle();

    // Assert: Check for title and button presence
    expect(find.text("Connect with the world around you."), findsOneWidget);
    expect(find.text("Sign up"), findsOneWidget);
  });

  testWidgets('Email input is validated', (tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(buildRegistrationScreen());
    await tester.pumpAndSettle();

    // Act: Enter invalid email
    await tester.enterText(find.byType(TextFormField).first, 'invalid_email');
    await tester.tap(find.byType(ElevatedButton));

    // Trigger validation and widget rebuild
    await tester.pump();

    // Assert: Check for error message
    expect(find.text("Enter a valid email address."), findsOneWidget);
  });

  testWidgets('Username input is validated', (tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(buildRegistrationScreen());
    await tester.pumpAndSettle();

    // Act: Enter invalid username
    await tester.enterText(
        find.byType(TextFormField).at(1), 'invalid username');
    await tester.tap(find.byType(ElevatedButton));

    // Trigger validation and widget rebuild
    await tester.pump();

    // Assert: Check for error message
    expect(find.text("Username allows letters, numbers, and underscores only."),
        findsOneWidget);
  });

  testWidgets('Password input is validated', (tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(buildRegistrationScreen());
    await tester.pumpAndSettle();

    // Act: Enter invalid password
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.tap(find.byType(ElevatedButton));

    // Trigger validation and widget rebuild
    await tester.pump();

    // Assert: Check for error message
    expect(find.text("Password must be 8-24 characters, 1 digit, 1 uppercase."),
        findsOneWidget);
  });

  testWidgets('Form submission triggers RegisterUser event', (tester) async {
    // Ensure that add method is called during test
    when(() => mockRegisterBloc.add(any())).thenAnswer((_) async {});

    // Build the widget
    await tester.pumpWidget(buildRegistrationScreen());
    await tester.pumpAndSettle();

    // Simulate valid form input
    await tester.enterText(
        find.byType(TextFormField).first, 'validemail@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'validusername');
    await tester.enterText(find.byType(TextFormField).at(2), 'ValidPass123');
    await tester.tap(find.byType(ElevatedButton));

    // Wait for state updates
    await tester.pumpAndSettle();

    // Get the BuildContext dynamically during the test
    final context = tester.element(find.byType(RegistrationScreen));

    // Verify that the event is triggered with the correct parameters
    verify(() => mockRegisterBloc.add(RegisterUser(
          context: context, // Passing the actual BuildContext from the tester
          username: 'validusername',
          email: 'validemail@example.com',
          password: 'ValidPass123',
        ))).called(1);
  });
}
