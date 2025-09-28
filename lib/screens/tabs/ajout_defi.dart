import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'package:SIRA/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/image_picker_widget.dart';

class AjoutDefi extends StatefulWidget {
  const AjoutDefi({super.key});

  @override
  State<AjoutDefi> createState() => _AjoutDefiState();
}

class _AjoutDefiState extends State<AjoutDefi> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _categorie = "Environnement";
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _allowContact = false;
  bool _loading = false;

  Future<void> _submitDefi() async {
    if (!_formKey.currentState!.validate()) return;

    // Vérifier que les champs obligatoires sont remplis
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une date")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Vérifier si l'utilisateur est connecté
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vous devez être connecté pour créer un défi")),
        );
        setState(() => _loading = false);
        return;
      }

      // Formater la date
      final formattedDate = DateFormat('yyyy-MM-dd').format(_date!);

      final response = await ApiService.add_defi(
        eventName: _eventNameController.text,
        description: _descriptionController.text,
        eventDate: formattedDate,
        location: _locationController.text,
        image: _selectedImage, // Utiliser _selectedImage au lieu de _image
      );

      final data = jsonDecode(response.body);

      // Vérifier le statusCode de la réponse HTTP
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Défi créé avec succès !")),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        // Token expiré ou invalide
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session expirée. Veuillez vous reconnecter.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${data['message'] ?? 'Erreur inconnue'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un Défi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomInput(
                controller: _eventNameController,
                label: "Titre",
                placeholder: "Titre du défi",
              ),
              const SizedBox(height: 15),
              CustomInput(
                controller: _descriptionController,
                label: "Description",
                placeholder: "Décrivez le défi",
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Catégorie",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _categorie,
                    items: const [
                      DropdownMenuItem(value: "Environnement", child: Text("Environnement")),
                      DropdownMenuItem(value: "Santé", child: Text("Santé")),
                      DropdownMenuItem(value: "Éducation", child: Text("Éducation")),
                    ],
                    onChanged: (val) => setState(() => _categorie = val),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une catégorie';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Sélectionnez une catégorie",
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color(0xFFE4E5E7),
                          width: 1,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color(0xFFE4E5E7),
                          width: 1,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color(0xFFE4E5E7),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  // Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Date",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => _date = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE4E5E7), width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _date == null
                                        ? "Sélectionner une date"
                                        : "${_date!.day.toString().padLeft(2, '0')}/${_date!.month.toString().padLeft(2, '0')}/${_date!.year}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _date == null ? const Color(0xFF9CA3AF) : Colors.black,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: Color(0xFF6B7280),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Heure début / fin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Heure début",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final start = await showTimePicker(
                              context: context,
                              initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
                            );
                            if (start != null) {
                              setState(() => _startTime = start);

                              // Demander l'heure de fin
                              final end = await showTimePicker(
                                context: context,
                                initialTime: _endTime ?? TimeOfDay(hour: start.hour + 1, minute: start.minute),
                              );
                              if (end != null) setState(() => _endTime = end);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE4E5E7), width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _startTime == null || _endTime == null
                                        ? "Sélectionner l'heure"
                                        : "${_startTime!.format(context)} - ${_endTime!.format(context)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: (_startTime == null || _endTime == null)
                                          ? const Color(0xFF9CA3AF)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.access_time_outlined,
                                  size: 18,
                                  color: Color(0xFF6B7280),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CustomInput(
                controller: _locationController,
                label: "Lieu",
                placeholder: "Cimetière Yoff, Dakar",
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage de l'image sélectionnée (optionnel)
                  ImagePickerWidget(
                    initialImage: _selectedImage,
                    onImageSelected: (File? image) {
                      setState(() {
                        _selectedImage = image;
                      });

                      if (image != null) {
                        print('Image sélectionnée: ${image.path}');
                      } else {
                        print('Image supprimée');
                      }
                    },
                    title: "Ajouter une image pour le défi",
                    subtitle: "JPG, JPEG, PNG • Max 20MB",
                    fileInfo: "Ajouter une image",
                    maxSizeInMB: 20.0,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Section Contact - Switch personnalisé
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Autoriser d'être contacté par Message",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555257),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => _allowContact = !_allowContact),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _allowContact
                              ? const Color(0xFFFFC113)
                              : const Color(0xFFE5E7EB),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _allowContact
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              CustomButton(
                text: _loading ? "Création en cours..." : "Créer le défi",
                onPressed: _loading ? null : _submitDefi,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}