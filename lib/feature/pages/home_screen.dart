import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_overthought/feature/pages/create_note_screen.dart';
import 'package:stack_overthought/feature/pages/side_bar_screen.dart';
import 'package:stack_overthought/model/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  late List<Note> notes;
  final TextEditingController _searchController = TextEditingController();
  Tag? _tagFilter;

  @override
  void initState() {
    super.initState();
    notes = List.from(sampleNotes);
  }

  List<Note> get _filteredNotes {
    final q = _searchController.text.trim().toLowerCase();
    return notes.where((n) {
      final matchesQuery =
          q.isEmpty ||
          n.title.toLowerCase().contains(q) ||
          n.excerpt.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
      final matchesTag = _tagFilter == null || n.tag == _tagFilter;
      return matchesQuery && matchesTag;
    }).toList();
  }

  Future<void> _openFilterDialog() async {
    final selection = await showDialog<int?>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Filtrar por tag'),
          children: [
            SimpleDialogOption(
              onPressed: () => context.pop(0),
              child: const Text('Todas'),
            ),
            ...Tag.values.asMap().entries.map((entry) {
              final tag = entry.value;
              final index = entry.key + 1;
              return SimpleDialogOption(
                onPressed: () => context.pop(index),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: tag.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(tag.label),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
    if (selection != null) {
      setState(
        () => _tagFilter = selection == 0 ? null : Tag.values[selection - 1],
      );
    }
  }

  List<Tag> get _activeTags =>
      Tag.values.where((tag) => notes.any((note) => note.tag == tag)).toList();

  Future<void> _goToCreateNote() async {
    final newNote = await context.push<Note?>(Routes.createNote);
    if (newNote != null) {
      setState(() {
        notes.insert(0, newNote);
      });
    }
  }

  Future<void> _exportNoteAsPdf(Note note) async {
    final regularFont = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                note.title,
                style: pw.TextStyle(font: boldFont, fontSize: 24),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Tag: ${note.tag.label}',
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 14,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              note.excerpt,
              style: pw.TextStyle(font: regularFont, fontSize: 16),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Conteúdo:',
              style: pw.TextStyle(font: boldFont, fontSize: 16),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              note.content,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 14,
                lineSpacing: 4,
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Data: ${note.date}',
              style: pw.TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1100;
            return Row(
              children: [
                // Left sidebar
                Container(
                  width: wide ? 220 : 72,
                  color: Theme.of(context).colorScheme.surfaceTint,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (wide)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'nota.',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(8),
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _tagFilter = null),
                              child: SidebarItem(
                                label: 'Início',
                                count: notes.length,
                                selected: _tagFilter == null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            ..._activeTags.map(
                              (tag) => GestureDetector(
                                onTap: () => setState(() {
                                  _tagFilter = tag;
                                }),
                                child: SidebarItem(
                                  label: tag.label,
                                  count: notes
                                      .where((note) => note.tag == tag)
                                      .length,
                                  selected: _tagFilter == tag,
                                  color: tag.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              child: Text('JS', style: AppTextStyle.title),
                            ),
                            if (wide) ...[
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('João Silva', style: AppTextStyle.title),
                                  Text(
                                    'Pro · ${notes.length} notas',
                                    style: AppTextStyle.subtitle,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Middle content
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top controls: search, filter, new note
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: 'Pesquisar notas...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: _openFilterDialog,
                              icon: const Icon(Icons.filter_list),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _goToCreateNote,
                              icon: const Icon(Icons.add),
                              label: const Text('Nova nota'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Todas as notas',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: wide ? 2 : 1,
                                  childAspectRatio: 3.5,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: _filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = _filteredNotes[index];
                              return GestureDetector(
                                onTap: () => setState(
                                  () => selectedIndex = notes.indexOf(note),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (note.image != null)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.memory(
                                              base64Decode(note.image!),
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (note.image != null)
                                          const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: note.tag.backgroundColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            note.tag.label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: note.tag.color,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          note.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          note.excerpt,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          note.date.toString(),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right detail panel
                Container(
                  width: wide ? 360 : 0,
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(20),
                  child: wide
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (notes[selectedIndex].image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(notes[selectedIndex].image!),
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (notes[selectedIndex].image != null)
                              const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: notes[selectedIndex].tag.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                notes[selectedIndex].tag.label,
                                style: TextStyle(
                                  color: notes[selectedIndex].tag.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              notes[selectedIndex].title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(notes[selectedIndex].excerpt),
                            const SizedBox(height: 16),
                            Text(
                              'Pontos chave:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(notes[selectedIndex].content),
                            const Spacer(),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final edited = await context.push<Note?>(
                                      Routes.createNote,
                                      extra: notes[selectedIndex],
                                    );
                                    if (edited != null) {
                                      setState(() {
                                        notes[selectedIndex] = edited;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Nota atualizada'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Editar'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () =>
                                      _exportNoteAsPdf(notes[selectedIndex]),
                                  child: const Text('PDF'),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Excluir nota'),
                                        content: const Text(
                                          'Tem certeza que deseja excluir esta nota?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => ctx.pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => ctx.pop(true),
                                            child: const Text(
                                              'Excluir',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      setState(() {
                                        final removedIndex = selectedIndex;
                                        notes.removeAt(removedIndex);
                                        if (notes.isEmpty) {
                                          selectedIndex = 0;
                                          _tagFilter = null;
                                        } else if (removedIndex >=
                                            notes.length) {
                                          selectedIndex = notes.length - 1;
                                        } else {
                                          selectedIndex = removedIndex;
                                        }
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Nota excluída'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
