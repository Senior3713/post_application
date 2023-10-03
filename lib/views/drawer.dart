import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments_with_firebase/blocs/auth/auth_bloc.dart';
import 'package:post_comments_with_firebase/services/strings.dart';

class MyDrawer extends StatelessWidget {
  final void showWarningDialog;
  const MyDrawer({super.key, required this.showWarningDialog});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final String name = state is GetUserSuccess
                  ? state.user.displayName!
                  : "accountName";
              final String email =
              state is GetUserSuccess ? state.user.email! : "accountName";

              return UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
              );
            },
          ),
          ListTile(
            onTap: () => showWarningDialog,
            title: const Text(I18N.deleteAccount),
          )
        ],
      ),
    );
  }
}
