import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';

class AddUserLoadingPage extends StatefulWidget {
  final String serverUrl;
  final String token;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;

  const AddUserLoadingPage({
    super.key,
    required this.serverUrl,
    required this.token,
    this.clientCertificate,
    this.additionalHeaders,
  });

  @override
  State<AddUserLoadingPage> createState() => _AddUserLoadingPageState();
}

class _AddUserLoadingPageState extends State<AddUserLoadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().addUser(
      serverUrl: widget.serverUrl,
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
