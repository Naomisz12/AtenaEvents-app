import 'dart:io';
import 'package:atena_events_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atena_events_app/services/event_service.dart';

class EditEventScreen extends StatefulWidget {
  final int eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String _title = '';
  String _description = '';
  DateTime? _selectedDate;
  String? _selectedBadge;

  bool loading = false;
  bool loadingDelete = false;
  bool loadingFetch = true;
  String? errorMessage;

  final List<String> _badges = ['Curso', 'Recreação', 'Treinamento', 'Palestra'];

  final ImagePicker _picker = ImagePicker();
  final EventService _eventService = EventService();

  Future<void> _fetchEvent() async {
    try {
      final event = await _eventService.getEventById(widget.eventId);

      setState(() {
        _title = event["title"];
        _description = event["description"];
        _selectedBadge = event["type"];
        _selectedDate = DateTime.tryParse(event["date"]);
        loadingFetch = false;
      });
    } catch (e) {
      setState(() {
        loadingFetch = false;
        errorMessage = "Erro ao carregar evento: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      if (mounted) Navigator.pop(context);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar Foto'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      await _eventService.updateEvent(
        eventId: widget.eventId,
        title: _title.trim(),
        type: _selectedBadge!,
        description: _description.trim(),
        date: _selectedDate!.toIso8601String().split('.').first,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Evento alterado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => errorMessage = "Erro ao salvar: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Tem certeza que deseja excluir este evento? Essa ação não pode ser desfeita."),
        actions: [
          TextButton(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.black),
            child: const Text("Deletar"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => loadingDelete = true);

    try {
      await _eventService.deleteEvent(widget.eventId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Evento excluído"), backgroundColor: Color.fromARGB(255, 47, 138, 15)),
      );

      Navigator.popUntil(context, ModalRoute.withName(AppRouter.home));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao excluir"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => loadingDelete = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFetch) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final fixedTypes = {
      ..._badges,
      if (_selectedBadge != null) _selectedBadge!,
    }.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Evento"),
        actions: [
          loadingDelete
              ? const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
              : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteEvent,
                )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                  image: _selectedImage != null
                      ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                      : null,
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicionar Capa do Evento',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: "Título", border: OutlineInputBorder()),
              onSaved: (v) => _title = v ?? "",
              validator: (v) => v == null || v.isEmpty ? "Informe o título" : null,
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Data do Evento",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                child: Text(
                  _selectedDate == null
                      ? "Selecione a data"
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _selectedBadge,
              decoration: const InputDecoration(
                labelText: "Categoria",
                border: OutlineInputBorder(),
              ),
              items: fixedTypes.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedBadge = v),
            ),
            const SizedBox(height: 16),

            TextFormField(
              initialValue: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
              onSaved: (v) => _description = v ?? "",
            ),

            const SizedBox(height: 25),

            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  loading ? "Salvando..." : "Salvar alterações",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: loading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
