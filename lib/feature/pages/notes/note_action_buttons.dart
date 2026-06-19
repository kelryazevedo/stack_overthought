import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_w;
import 'package:printing/printing.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/model/note.dart';

class NoteActionButtons extends StatelessWidget {
  const NoteActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final stackOverthoughtCubit = context.read<StackOverthoughtCubit>();
    return Wrap(
      spacing: 6,
      children: [
        ElevatedButton(
          onPressed: () => context.push(Routes.editNote),
          child: const Text(editNoteTitle),
        ),
        OutlinedButton(
          child: const Text(pdfTitle),
          onPressed: () =>
              _exportNoteAsPdf(stackOverthoughtCubit.state.selectedNote!),
        ),
        TextButton.icon(
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(deleteNoteTitle),
                content: const Text(deleteNoteSubtitle),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      stackOverthoughtCubit.removeNote(
                        stackOverthoughtCubit.state.selectedNote!,
                      );
                      context.pop();
                    },
                    child: const Text(
                      deleteNoteButton,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },

          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text(
            deleteNoteButton,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Future<void> _exportNoteAsPdf(Note note) async {
    final regularFont = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    final pdf = pdf_w.Document()
      ..addPage(
        pdf_w.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              pdf_w.Header(
                level: 0,
                child: pdf_w.Text(
                  note.title,
                  style: pdf_w.TextStyle(font: boldFont, fontSize: 24),
                ),
              ),
              pdf_w.SizedBox(height: 8),
              pdf_w.Text(
                'Tag: ${note.tag.label}',
                style: pdf_w.TextStyle(
                  font: regularFont,
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
              pdf_w.SizedBox(height: 12),
              pdf_w.Text(
                note.excerpt,
                style: pdf_w.TextStyle(font: regularFont, fontSize: 16),
              ),
              pdf_w.SizedBox(height: 16),
              pdf_w.Text(
                'Conteúdo:',
                style: pdf_w.TextStyle(font: boldFont, fontSize: 16),
              ),
              pdf_w.SizedBox(height: 8),
              pdf_w.Text(
                note.content,
                style: pdf_w.TextStyle(
                  font: regularFont,
                  fontSize: 14,
                  lineSpacing: 4,
                ),
              ),
              pdf_w.SizedBox(height: 16),
              pdf_w.Text(
                'Data: ${note.date}',
                style: pdf_w.TextStyle(
                  font: regularFont,
                  fontSize: 12,
                  color: PdfColors.grey500,
                ),
              ),
            ];
          },
        ),
      );

    final bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }
}
