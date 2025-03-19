import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/screens/home_screen.dart'; // Correct import path

void main() {
  testWidgets('To-Do List App UI Test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: TodoListScreen()));

    // Verify the app bar title exists
    expect(find.text('To-Do List'), findsOneWidget);

    // Enter a task in the text field
    await tester.enterText(find.byKey(const Key('taskField')), 'Buy groceries');

    // Tap the add button
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pumpAndSettle();

    // Verify the task is added to the list
    expect(find.text('Buy groceries'), findsOneWidget);

    // Tap the delete button next to the task
    await tester.tap(find.byKey(const Key('deleteTaskButton_0'))); // Unique key
    await tester.pumpAndSettle();

    // Verify the task is removed
    expect(find.text('Buy groceries'), findsNothing);
  });
}
