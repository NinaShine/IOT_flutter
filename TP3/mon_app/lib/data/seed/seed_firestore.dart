import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  final FirebaseFirestore db;

  FirestoreSeeder(this.db);

  /// Seed sans doublons:
  /// - thèmes avec IDs fixes: themes/{themeKey}
  /// - questions avec IDs fixes: themes/{themeKey}/questions/{questionKey}
  ///
  /// Le bouton peut être cliqué plusieurs fois:
  /// -> ça met à jour (merge) au lieu de dupliquer.
  Future<void> run() async {
    final data = <String, Map<String, dynamic>>{
      "reseaux": {
        "title": "Réseaux",
        "imageUrl": "https://picsum.photos/seed/theme_networks/800/450",
        "description": "OSI, IP, DNS, routage…",
        "difficulty": "medium",
        "order": 1,
        "isActive": true,
        "questions": <String, Map<String, dynamic>>{
          "osi_routing": {
            "text": "Quelle couche du modèle OSI gère le routage ?",
            "imageUrl": "https://picsum.photos/seed/q_osi_routing/800/450",
            "choices": ["Physique", "Réseau", "Transport", "Session"],
            "correctIndex": 1,
          },
          "dhcp": {
            "text": "Quel protocole attribue automatiquement une adresse IP ?",
            "imageUrl": "https://picsum.photos/seed/q_dhcp/800/450",
            "choices": ["DNS", "DHCP", "HTTP", "FTP"],
            "correctIndex": 1,
          },
          "http_port": {
            "text": "Quel est le port par défaut de HTTP ?",
            "imageUrl": "https://picsum.photos/seed/q_http_port/800/450",
            "choices": ["21", "22", "80", "443"],
            "correctIndex": 2,
          },
          "dns_role": {
            "text": "À quoi sert DNS ?",
            "imageUrl": "https://picsum.photos/seed/q_dns/800/450",
            "choices": ["Chiffrer", "Traduire nom↔IP", "Routage", "Attribuer IP"],
            "correctIndex": 1,
          },
        },
      },

      "iot": {
        "title": "IoT",
        "imageUrl": "https://picsum.photos/seed/theme_iot/800/450",
        "description": "ESP32, capteurs, MQTT…",
        "difficulty": "easy",
        "order": 2,
        "isActive": true,
        "questions": <String, Map<String, dynamic>>{
          "ldr": {
            "text": "Quel composant mesure la lumière ?",
            "imageUrl": "https://picsum.photos/seed/q_ldr/800/450",
            "choices": ["LDR", "NTC", "Buzzer", "Relais"],
            "correctIndex": 0,
          },
          "ntc": {
            "text": "Quel capteur est utilisé pour mesurer la température (simple) ?",
            "imageUrl": "https://picsum.photos/seed/q_ntc/800/450",
            "choices": ["LDR", "NTC", "LED", "Bouton poussoir"],
            "correctIndex": 1,
          },
          "mqtt": {
            "text": "Quel protocole est souvent utilisé pour l’IoT (pub/sub) ?",
            "imageUrl": "https://picsum.photos/seed/q_mqtt/800/450",
            "choices": ["FTP", "MQTT", "SSH", "SMTP"],
            "correctIndex": 1,
          },
          "esp_wireless": {
            "text": "Sur ESP32, quel module permet le sans-fil ?",
            "imageUrl": "https://picsum.photos/seed/q_esp_wifi/800/450",
            "choices": ["UART", "Wi-Fi/Bluetooth", "GPIO", "ADC"],
            "correctIndex": 1,
          },
        },
      },

      "flutter": {
        "title": "Flutter",
        "imageUrl": "https://picsum.photos/seed/theme_flutter/800/450",
        "description": "Widgets, state, navigation…",
        "difficulty": "easy",
        "order": 3,
        "isActive": true,
        "questions": <String, Map<String, dynamic>>{
          "stateless": {
            "text": "Quel widget est immuable (sans état) ?",
            "imageUrl": "https://picsum.photos/seed/q_stateless/800/450",
            "choices": [
              "StatefulWidget",
              "StatelessWidget",
              "InheritedWidget",
              "StreamBuilder"
            ],
            "correctIndex": 1,
          },
          "setstate": {
            "text": "À quoi sert setState() ?",
            "imageUrl": "https://picsum.photos/seed/q_setstate/800/450",
            "choices": [
              "Naviguer",
              "Relancer build()",
              "Lire Firestore",
              "Créer un Provider"
            ],
            "correctIndex": 1,
          },
          "listview": {
            "text": "Quel widget permet une liste optimisée (lazy) ?",
            "imageUrl": "https://picsum.photos/seed/q_listview/800/450",
            "choices": ["Row", "Column", "ListView.builder", "Container"],
            "correctIndex": 2,
          },
        },
      },

      "firebase": {
        "title": "Firebase",
        "imageUrl": "https://picsum.photos/seed/theme_firebase/800/450",
        "description": "Auth, Firestore, Storage…",
        "difficulty": "medium",
        "order": 4,
        "isActive": true,
        "questions": <String, Map<String, dynamic>>{
          "auth_service": {
            "text": "Quel service gère la connexion utilisateur ?",
            "imageUrl": "https://picsum.photos/seed/q_firebase_auth/800/450",
            "choices": ["Firestore", "Auth", "Storage", "Remote Config"],
            "correctIndex": 1,
          },
          "model": {
            "text": "Firestore stocke les données sous forme de…",
            "imageUrl": "https://picsum.photos/seed/q_firestore_model/800/450",
            "choices": ["Tables", "Documents/Collections", "Fichiers", "Sockets"],
            "correctIndex": 1,
          },
          "storage": {
            "text": "Quel service sert à stocker des images/fichiers ?",
            "imageUrl": "https://picsum.photos/seed/q_storage/800/450",
            "choices": ["Storage", "Auth", "Functions", "Analytics"],
            "correctIndex": 0,
          },
        },
      },
    };

    // 1) Write themes with fixed IDs (merge)
    WriteBatch batch = db.batch();
    int ops = 0;

    for (final entry in data.entries) {
      final themeKey = entry.key;
      final themeData = Map<String, dynamic>.from(entry.value);
      final questions = (themeData.remove("questions")
      as Map<String, dynamic>)
          .cast<String, Map<String, dynamic>>();

      final themeRef = db.collection("themes").doc(themeKey);
      batch.set(themeRef, themeData, SetOptions(merge: true));
      ops++;

      // 2) Write questions with fixed IDs (merge)
      for (final qEntry in questions.entries) {
        final qKey = qEntry.key;
        final qRef = themeRef.collection("questions").doc(qKey);
        batch.set(qRef, qEntry.value, SetOptions(merge: true));
        ops++;

        // limite batch Firestore ~500 ops
        if (ops >= 450) {
          await batch.commit();
          batch = db.batch();
          ops = 0;
        }
      }
    }

    if (ops > 0) {
      await batch.commit();
    }
  }
}
