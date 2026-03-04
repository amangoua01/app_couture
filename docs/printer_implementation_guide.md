# Guide d'Implémentation de l'Impression Thermique Bluetooth (ESC/POS)

Ce document détaille la stratégie et l'implémentation technique utilisées dans ce projet pour assurer une découverte fiable et une connexion stable aux imprimantes thermiques.

## 1. Stack Technologique (Packages Clés)

L'implémentation repose sur une combinaison de trois packages complémentaires pour pallier aux limitations individuelles de chaque bibliothèque :

*   **`print_bluetooth_thermal`** : Utilisé comme moteur principal pour la communication (connexion, déconnexion, vérification du statut et envoi de bytes).
*   **`flutter_thermal_printer`** : Utilisé spécifiquement pour la phase de **découverte (scan)** car il offre une meilleure détection des périphériques BLE (Bluetooth Low Energy).
*   **`esc_pos_utils_plus`** : (Utilisé via le générateur) Pour construire la structure du ticket (texte, colonnes, codes QR, images) selon le protocole ESC/POS.
*   **`permission_handler`** : Indispensable pour gérer les permissions critiques sur Android.

## 2. Gestion des Permissions (Critique pour Android)

Sur Android (particulièrement les versions 12+), le scan Bluetooth échoue souvent sans un kit précis de permissions. L'application demande systématiquement :
*   `Permission.bluetoothConnect`
*   `Permission.bluetoothScan`
*   `Permission.locationWhenInUse` (Requis pour le scan Bluetooth sur plusieurs versions d'Android).

## 3. Stratégie de Découverte des Imprimantes

La difficulté de trouver des imprimantes est souvent liée à un état instable de la pile Bluetooth lors de l'initialisation.

### Logique de Scan Robuste :
Le contrôleur `PrintListPageVctl` implémente une boucle de tentative pour gérer l'erreur native `CBManagerStateUnknown` (fréquente sur iOS au démarrage) :

```dart
int retries = 0;
while (retries < 3) {
  try {
    await bluetoothInstance.getPrinters(
      connectionTypes: [ConnectionType.BLE],
    );
    break;
  } on PlatformException catch (e) {
    if (e.message?.contains("CBManagerStateUnknown") == true) {
      retries++;
      await Future.delayed(Duration(milliseconds: 600));
    } else {
      // Gérer les autres erreurs
    }
  }
}
```

## 4. Workflow de Connexion et Persistance

### Connexion :
La connexion s'effectue via l'adresse MAC (ou identifiant unique) :
```dart
final bool connected = await PrintBluetoothThermal.connect(
  macPrinterAddress: printer.address,
);
```

### Persistance :
Une fois connectée avec succès, l'imprimante est enregistrée dans le cache local (`SharedPreferences`). Cela permet à l'application de tenter une reconnexion automatique ou de proposer l'imprimante dans une liste "Historique" sans avoir à relancer un scan complet.

## 5. Génération et Envoi des Données (Bytes)

L'impression ne se fait pas via du texte brut mais via une liste de bytes (`List<int>`) générée par un `Generator`.

### Étapes de génération :
1.  **Profil de capacité** : Chargement de `CapabilityProfile.load()`.
2.  **Initialisation** : `generator.reset()` et réglage de la table de caractères (`setGlobalCodeTable("CP1252")` pour les accents français).
3.  **Mise en page** : Utilisation de `generator.row([...])` pour aligner prix et quantités sur une grille de 12 colonnes.
4.  **Graphiques** : Conversion des logos en noir et blanc (`decodeImage` + `copyResize`) avant envoi.
5.  **Finalisation** : Ajout de lignes vides en fin de ticket pour permettre la découpe manuelle.

### Envoi sécurisé :
Avant chaque envoi, le statut de connexion est vérifié :
```dart
final bool isConnected = await PrintBluetoothThermal.connectionStatus;
if (isConnected) {
  await PrintBluetoothThermal.writeBytes(generatedBytes);
}
```

## 6. Conseils pour l'autre projet (Dépannage)

Si votre autre application a du mal à trouver des imprimantes :
1.  **Vérifiez la permission Localisation** : Sans elle, le scan Bluetooth renvoie souvent une liste vide sur Android.
2.  **Utilisez le BLE explicitement** : Les imprimantes modernes préfèrent le protocole BLE.
3.  **Délai d'initialisation** : Attendez environ 500ms après l'allumage du Bluetooth avant de lancer `getPrinters()`.
4.  **Filtrage** : Assurez-vous que vous ne filtrez pas trop agressivement par nom de périphérique (certaines imprimantes s'identifient simplement comme "MTP-2" ou "TP-3").
