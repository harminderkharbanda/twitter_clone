import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:twitter_clone/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('enter username and password, login, view tweet, logout', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    Finder loginText = find.text("Log in to Twitter");
    expect(loginText, findsOneWidget);

    Finder emailField = find.byKey(ValueKey("userEmail"));
    Finder passwordField = find.byKey(ValueKey("userPassword"));
    Finder signinButton = find.byKey(ValueKey("signin"));
    Finder signoutButton = find.byKey(ValueKey("signout"));
    Finder profilePic = find.byKey(ValueKey("profilePic"));

    await tester.enterText(emailField, "hunny020@gmail.com");
    await tester.enterText(passwordField, "111111");
    await tester.tap(signinButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    Finder userText = find.text("harry");
    expect(userText, findsOneWidget);

    await tester.tap(profilePic);
    await tester.pumpAndSettle();

    await tester.tap(signoutButton);
    await tester.pumpAndSettle();

    expect(loginText, findsOneWidget);
  });

}