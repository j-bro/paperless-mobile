import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/document_details/document_print/cubit/document_print_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DocumentPrintButton extends StatelessWidget {
  const DocumentPrintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentPrintCubit, DocumentPrintState>(
      builder: (context, state) {
        return IconButton(
          tooltip: S.of(context)!.print,
          onPressed: () => context.read<DocumentPrintCubit>().printDocument(),
          icon: const Icon(Icons.print),
        );
      },
    );
  }
}
