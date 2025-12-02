import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

class SetActiveUserPage extends StatefulWidget {
  final String serverUrl;
  final String username;
  final String token;
  final ClientCertificate? clientCertificate;

  const SetActiveUserPage({
    super.key,
    required this.serverUrl,
    required this.username,
    required this.token,
    this.clientCertificate,
  });

  @override
  State<SetActiveUserPage> createState() => _SetActiveUserPageState();
}

class _SetActiveUserPageState extends State<SetActiveUserPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().setActiveUser(
      serverUrl: widget.serverUrl,
      username: widget.username,
      token: widget.token,
      clientCertificate: widget.clientCertificate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
