import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _prefsKeyPrefix = 'avatar_path_';

  String? _avatarPath;
  bool _loading = true;
  bool _saving = false;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('$_prefsKeyPrefix${widget.uid}');

      if (path != null && await File(path).exists()) {
        _avatarPath = path;
      } else {
        _avatarPath = null;
      }
    } catch (e) {
      _avatarPath = null;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur init profil: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickAndSaveAvatar() async {
    setState(() => _saving = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (picked == null) {
        setState(() => _saving = false);
        return;
      }

      // Dossier local de l'app
      final dir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${dir.path}/avatars/${widget.uid}');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      // Chemin fixe => pas de doublons
      final savedPath = '${avatarDir.path}/avatar.jpg';

      // Copie (remplace si existe)
      final file = File(picked.path);
      await file.copy(savedPath);

      // Persiste dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefsKeyPrefix${widget.uid}', savedPath);

      setState(() {
        _avatarPath = savedPath;
        _saving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Avatar mis à jour ✅")),
        );
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur avatar: $e")),
        );
      }
    }
  }

  Future<void> _removeAvatar() async {
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefsKeyPrefix${widget.uid}';
      final oldPath = prefs.getString(key);

      await prefs.remove(key);

      if (oldPath != null) {
        final f = File(oldPath);
        if (await f.exists()) {
          await f.delete();
        }
      }

      setState(() {
        _avatarPath = null;
        _saving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Avatar supprimé 🗑️")),
        );
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur suppression: $e")),
        );
      }
    }
  }

  Future<void> _playWin() async {
    debugPrint("PLAY WIN");
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/win.mp3'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Son WIN joué ")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur son WIN: $e")),
        );
      }
    }
  }


  Future<void> _playLose() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/lose.mp3'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Son LOSE joué ")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur son LOSE: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F3FF),
              Color(0xFFF2FAFF),
              Color(0xFFFFF7F2),
            ],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Avatar utilisateur",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: cs.primary.withOpacity(0.12),
                          backgroundImage: (_avatarPath != null)
                              ? FileImage(File(_avatarPath!))
                              : null,
                          child: (_avatarPath == null)
                              ? Icon(Icons.person_rounded,
                              size: 58, color: cs.primary)
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Avatar buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saving ? null : _pickAndSaveAvatar,
                            icon: const Icon(Icons.image_rounded),
                            label: Text(
                              _saving ? "Enregistrement..." : "Choisir un avatar",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: (_saving || _avatarPath == null)
                                ? null
                                : _removeAvatar,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text("Supprimer l’avatar"),
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 10),

                        // Sound test
                        Text(
                          "Test des sons (assets)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _playWin,
                                icon: const Icon(Icons.emoji_events_rounded),
                                label: const Text("WIN"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _playLose,
                                icon: const Icon(Icons.sentiment_dissatisfied_rounded),
                                label: const Text("LOSE"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: cs.onSurface.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
