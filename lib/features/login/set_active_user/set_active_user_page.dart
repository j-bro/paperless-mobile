import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';

class SetActiveUserPage extends StatefulWidget {
  final String serverUrl;
  final String username;
  final String token;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;

  const SetActiveUserPage({
    super.key,
    required this.serverUrl,
    required this.username,
    required this.token,
    this.clientCertificate,
    this.additionalHeaders,
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
      additionalHeaders: widget.additionalHeaders,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
