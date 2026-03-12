import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pro_dictant/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/mapper.dart';
import '../../../../core/s.dart';
import '../../domain/usecases/login.dart';
import '../manager/login_bloc/login_bloc.dart';
import '../manager/login_bloc/login_event.dart';
import '../manager/login_bloc/login_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginWithEmailInProcess = false;
  bool isSignUpWithEmailInProcess = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenLoginCheck', true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (state is LoginFailure) {
          final message =
              ErrorMapper.mapFailureToMessage(context, state.failure);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      keyboardVisible
                          ? SizedBox.shrink()
                          : SizedBox(height: 40),
                      SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: 220,
                        height: 220,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF626749), BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40),
                      !isLoginWithEmailInProcess
                          ? _buildLoginOptions(context)
                          : _buildEmailLogin(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildEmailLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              AuthTextField(
                controller: _emailController,
                hint: S.of(context).enterEmail,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return S.of(context).enterEmail;
                  if (value.length < 3) return S.of(context).emailIsTooShort;
                  final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegExp.hasMatch(value)) {
                    return S.of(context).emailIsNotValid;
                  }
                  return null;
                },
              ),
              AuthTextField(
                controller: _passwordController,
                hint: S.of(context).enterPassword,
                isHidden: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return S.of(context).enterPassword;
                  if (value.length < 6) return S.of(context).passwordIsTooShort;
                  if (!value.contains(RegExp(r'[0-9]')))
                    return S.of(context).atLeastOneDigit;
                  return null;
                },
              ),
              !isSignUpWithEmailInProcess
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            _showResetPasswordSheet(context);
                          },
                          child: Text(
                            S.of(context).forgotPassword,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              isSignUpWithEmailInProcess
                  ? AuthButton(
                      text: S.of(context).signUpButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                              SignupWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                        }
                      },
                    )
                  : AuthButton(
                      text: S.of(context).loginButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitted(
                              email: _emailController.text,
                              password: _passwordController.text));
                        }
                      },
                    ),
            ],
          ),
        ),
        Column(
          children: [
            !isSignUpWithEmailInProcess
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginWithEmailInProcess = false;
                        });
                      },
                      child: Text(
                        S.of(context).chooseOtherLoginOption,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12,
                                ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            !isSignUpWithEmailInProcess
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpWithEmailInProcess = true;
                        });
                      },
                      child: Text(
                        S.of(context).createAnAccount,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12,
                                ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpWithEmailInProcess = false;
                        });
                      },
                      child: Text(
                        S.of(context).alreadyHaveAccount,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12,
                                ),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Column _buildLoginOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthButton(
          text: S.of(context).login,
          onPressed: () {
            setState(() {
              isLoginWithEmailInProcess = true;
            });
          },
        ),
        const SizedBox(height: 12),
        AuthButton(
          text: S.of(context).continueWithGoogle,
          fontSize: 14,
          onPressed: () {
            context.read<LoginBloc>().add(GoogleSignInPressed());
          },
        ),
        const SizedBox(height: 12),
        AuthButton(
          text: S.of(context).continueWithoutAccount,
          fontSize: 12,
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasSeenLoginCheck', true);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showResetPasswordSheet(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).resetPasswordDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: emailController,
                hint: S.of(context).enterEmail,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return S.of(context).enterEmail;
                  if (value.length < 3) return S.of(context).emailIsTooShort;
                  final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegExp.hasMatch(value)) {
                    return S.of(context).emailIsNotValid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffd9c3ac),
                        foregroundColor: const Color(0xFF243120),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(S.of(context).cancel),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilledButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              ForgotPasswordPressed(emailController.text),
                            );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).resetPasswordSentMessage),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF85977F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(S.of(context).sendButton),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
