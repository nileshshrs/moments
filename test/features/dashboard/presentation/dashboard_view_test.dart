// test/features/dashboard/presentation/view/dashboard_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/features/dashboard/presentation/dashboard_view.dart';
import 'package:moments/features/dashboard/presentation/view/home_screen.dart';
import 'package:moments/features/dashboard/presentation/view/search_screen.dart';
import 'package:moments/features/dashboard/presentation/view/chat_screen.dart';
import 'package:moments/features/dashboard/presentation/view/account_screen.dart'; // Assuming this is ProfileScreen.
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:moments/features/search/view_model/search_bloc.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fake implementations for required blocs.
/// These minimal fakes provide the initial state only.
class FakeDashboardCubit extends Cubit<DashboardState> implements DashboardCubit {
  FakeDashboardCubit() : super(DashboardState.initial());
  @override
  void onTabTapped(int index) => emit(state.copyWith(selectedIndex: index));
}

class FakePostBloc extends Cubit<PostState> implements PostBloc {
  FakePostBloc() : super(PostState.initial());
  
  @override
  void add(PostEvent event) {
    // TODO: implement add
  }
  
  @override
  void on<E extends PostEvent>(EventHandler<E, PostState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }
  
  @override
  void onEvent(PostEvent event) {
    // TODO: implement onEvent
  }
  
  @override
  void onTransition(Transition<PostEvent, PostState> transition) {
    // TODO: implement onTransition
  }
}

class FakeSearchBloc extends Cubit<SearchState> implements SearchBloc {
  FakeSearchBloc() : super(SearchState.initial());
  
  @override
  void add(SearchEvent event) {
    // TODO: implement add
  }
  
  @override
  void on<E extends SearchEvent>(EventHandler<E, SearchState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }
  
  @override
  void onEvent(SearchEvent event) {
    // TODO: implement onEvent
  }
  
  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    // TODO: implement onTransition
  }
}

class FakeProfileBloc extends Cubit<ProfileState> implements ProfileBloc {
  FakeProfileBloc() : super(ProfileState.initial());
  
  @override
  void add(ProfileEvent event) {
    // TODO: implement add
  }
  
  @override
  void on<E extends ProfileEvent>(EventHandler<E, ProfileState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }
  
  @override
  void onEvent(ProfileEvent event) {
    // TODO: implement onEvent
  }
  
  @override
  void onTransition(Transition<ProfileEvent, ProfileState> transition) {
    // TODO: implement onTransition
  }
}

class FakeConversationBloc extends Cubit<ConversationState> implements ConversationBloc {
  FakeConversationBloc() : super(ConversationState.initial());
  
  @override
  void add(ConversationEvent event) {
    // TODO: implement add
  }
  
  @override
  void on<E extends ConversationEvent>(EventHandler<E, ConversationState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }
  
  @override
  void onEvent(ConversationEvent event) {
    // TODO: implement onEvent
  }
  
  @override
  void onTransition(Transition<ConversationEvent, ConversationState> transition) {
    // TODO: implement onTransition
  }
}

class FakeInteractionsBloc extends Cubit<InteractionsState> implements InteractionsBloc {
  FakeInteractionsBloc() : super(InteractionsState.initial());
  
  @override
  void add(InteractionsEvent event) {
    // TODO: implement add
  }
  
  @override
  void on<E extends InteractionsEvent>(EventHandler<E, InteractionsState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }
  
  @override
  void onEvent(InteractionsEvent event) {
    // TODO: implement onEvent
  }
  
  @override
  void onTransition(Transition<InteractionsEvent, InteractionsState> transition) {
    // TODO: implement onTransition
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;

  // Register a SharedPreferences instance in GetIt.
  SharedPreferences.setMockInitialValues({'userID': 'dummyUser'});
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Register our fake blocs in GetIt.
  getIt.registerSingleton<DashboardCubit>(FakeDashboardCubit());
  getIt.registerSingleton<PostBloc>(FakePostBloc());
  getIt.registerSingleton<SearchBloc>(FakeSearchBloc());
  getIt.registerSingleton<ProfileBloc>(FakeProfileBloc());
  getIt.registerSingleton<ConversationBloc>(FakeConversationBloc());
  getIt.registerSingleton<InteractionsBloc>(FakeInteractionsBloc());

  group('DashboardView Widget Test', () {
    testWidgets('displays initial DashboardView with logo and bottom navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DashboardView(),
      ));

      await tester.pumpAndSettle();

      // When selectedIndex == 0, the AppBar is built with a logo image.
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          final assetImage = widget.image as AssetImage;
          return assetImage.assetName == 'assets/images/logo-light.png';
        }
        return false;
      }), findsOneWidget);

      // The body is set to the view corresponding to selectedIndex.
      // DashboardState.initial() returns views: [HomeScreen(), SearchScreen(), ChatScreen(), ProfileScreen()]
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify that BottomNavigationBar is present with 4 items.
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.items.length, equals(4));
    });

    testWidgets('updates view when DashboardCubit tab is tapped', (WidgetTester tester) async {
      // Retrieve our fake DashboardCubit from GetIt.
      final dashboardCubit = getIt<DashboardCubit>();

      await tester.pumpWidget(MaterialApp(
        home: DashboardView(),
      ));
      await tester.pumpAndSettle();

      // Initially, selectedIndex is 0 so HomeScreen is visible.
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SearchScreen), findsNothing);

      // Simulate tapping on the Search tab (index 1).
      dashboardCubit.onTabTapped(1);
      await tester.pumpAndSettle();

      // When selectedIndex becomes 1, the AppBar is null.
      expect(find.byType(AppBar), findsNothing);
      // SearchScreen should now be visible.
      expect(find.byType(SearchScreen), findsOneWidget);
    });
  });
}
