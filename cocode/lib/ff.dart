import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_bloc/form_bloc.dart';

void main() {
  runApp(MaterialApp(home: SignUpForm()));
}

class SignUpFormBloc extends FormBloc<String, String> {
  final usernameField = TextFieldBloc();
  final passwordField =
      TextFieldBloc(validators: [Validators.passwordMin6Chars]);

  @override
  List<FieldBloc> get fieldBlocs => [usernameField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Form logic...
    try {
      await _signUp(
        throwException: true,
        username: usernameField.value,
        password: passwordField.value,
      );
      yield currentState.toSuccess();
    } catch (e) {
      // When get the error from the backend you can
      // add the error to the field:
      usernameField.addError('That username is taken. Try another.');

      yield currentState
          .toFailure('The error was added to the username field.');
    }
  }

  Future<void> _signUp({
    @required bool throwException,
    @required String username,
    @required String password,
  }) async {
    print(username);
    print(password);
    await Future<void>.delayed(Duration(seconds: 2));
    if (throwException) throw Exception();
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpFormBloc>(
      builder: (context) => SignUpFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<SignUpFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Sign Up Form')),
            body: FormBlocListener<SignUpFormBloc, String, String>(
              onSubmitting: (context, state) {
                // Show the progress dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => WillPopScope(
                    onWillPop: () async => false,
                    child: Center(
                      child: Card(
                        child: Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                );
              },
              onSuccess: (context, state) {
                // Hide the progress dialog
                Navigator.of(context).pop();
                // Navigate to success screen
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                // Hide the progress dialog
                Navigator.of(context).pop();
                // Show snackbar with the error
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failureResponse),
                    backgroundColor: Colors.red[300],
                  ),
                );
              },
              child: ListView(
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.usernameField,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.passwordField,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: formBloc.submit,
                      child: Center(child: Text('SUBMIT')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.sentiment_satisfied,
                size: 100,
              ),
              RaisedButton(
                color: Colors.green[100],
                child: Text('Sign out'),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignUpForm())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
