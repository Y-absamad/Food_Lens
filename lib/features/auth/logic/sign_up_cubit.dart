import 'package:flutter/widgets.dart';
import 'package:food_lens/features/Profile/repo/user_epository.dart';
import 'package:food_lens/features/auth/logic/auth_cubit.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';

class SignUpCubit extends BaseAuthCubit {
  final UserRepository userRepository = UserRepository();

  SignUpCubit() : super(AuthInitial());

  Future<void> signUp(BuildContext context, AuthMethod authMethod) async {
    if (authMethod is EmailPasswordAuth && !isAllFieldsValidate()) {
      emit(FieldsError("Please fill in all fields"));
      return;
    }

    await authenticate(context, authMethod, isSignUp: true);
  }

  @override
  bool isAllFieldsValidate() {
    final isNameValid = fullNameFieldKey.currentState?.validate() ?? false;
    final isEmailValid = emailFieldKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFieldKey.currentState?.validate() ?? false;
    return isNameValid && isEmailValid && isPasswordValid;
  }


  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Include at least one uppercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) return "Include at least one number";
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }
}
