# Mise à jour des modèles pour correspondre au JSON de réponse

## Résumé des modifications

Tous les modèles ont été mis à jour pour correspondre exactement à la structure JSON retournée par le serveur lors de la création d'une mesure.

## Nouveaux modèles créés

### 1. PaiementFacture (`lib/data/models/paiement_facture.dart`)
- **Champs** : `id`, `montant`, `reference`, `type`, `createdAt`, `isActive`
- **Utilisation** : Représente les paiements associés à une facture/mesure

## Modèles mis à jour

### 2. CategorieMesure (`lib/data/models/categorie_mesure.dart`)
- **Nouveaux champs** : `entreprise`, `createdAt`, `isActive`
- **Modification** : Ajout de la relation avec l'entreprise et des métadonnées

### 3. Mensuration (`lib/data/models/mensuration.dart`)
- **Nouveaux champs** : `createdAt`, `isActive`
- **Modification** : Ajout des métadonnées de création et d'état

### 4. TypeMesure (`lib/data/models/type_mesure.dart`)
- **Nouveaux champs** : `createdAt`, `isActive`
- **Modification** : Ajout des métadonnées et correction de la sérialisation de l'entreprise

### 5. LigneMesure (`lib/data/models/ligne_mesure.dart`)
- **Nouveaux champs** : `createdAt`, `isActive`
- **Modification** : Ajout des métadonnées de création et d'état

### 6. Mesure (`lib/data/models/mesure.dart`)
- **Nouveaux champs** : `paiementFactures`
- **Modification** : 
  - Ajout de la liste des paiements associés
  - Support des noms de champs alternatifs (`MontantTotal`/`montantTotal`, `ResteArgent`/`resteArgent`, `remise`/`remiseGlobale`)
  - Parsing complet de la liste `mesures` et `paiementFactures`

### 7. EntiteEntreprise (`lib/data/models/abstract/entite_entreprise.dart`)
- **Nouveaux champs** : `createdAt`, `isActive`
- **Modification** : Ajout des métadonnées de base pour toutes les entités (Boutique, Succursale)

### 8. Client (`lib/data/models/client.dart`)
- **Nouveaux champs** : `createdAt`, `isActive`
- **Modification** : Ajout des métadonnées de création et d'état

## Structure JSON supportée

Le système supporte maintenant complètement la structure JSON suivante :

```json
{
  "id": 2,
  "dateRetrait": "2026-01-31T18:45:00+00:00",
  "dateDepot": "2026-01-30T19:37:22+01:00",
  "avance": "1000000",
  "MontantTotal": "1500000",
  "remise": "0",
  "ResteArgent": "500000",
  "client": { ... },
  "signature": null,
  "mesures": [
    {
      "id": 2,
      "nom": "",
      "montant": "1500000",
      "remise": "0",
      "etat": "En cours",
      "ligneMesures": [
        {
          "id": 4,
          "taille": "10",
          "categorieMesure": {
            "id": 29,
            "libelle": "Dos",
            "entreprise": { ... },
            "createdAt": "2025-03-02T13:00:09+01:00",
            "isActive": true
          },
          "createdAt": null,
          "isActive": true
        }
      ],
      "photoModele": null,
      "photoPagne": null,
      "typeMesure": { ... },
      "createdAt": "2026-01-30T19:37:22+01:00",
      "isActive": true
    }
  ],
  "paiementFactures": [
    {
      "id": 8,
      "montant": "1000000",
      "reference": "PMT260130193723008",
      "type": "paiementFacture",
      "createdAt": "2026-01-30T19:37:23+01:00",
      "isActive": true
    }
  ],
  "succursale": { ... },
  "createdAt": "2026-01-30T19:37:22+01:00",
  "isActive": true
}
```

## API mise à jour

### MesureApi (`lib/api/mesure_api.dart`)
- **Modification** : La méthode `create` retourne maintenant `Future<DataResponse<Mesure>>` au lieu de `Future<DataResponse<bool>>`
- **Avantage** : L'application reçoit directement l'objet Mesure complet créé par le serveur, avec tous les IDs et métadonnées

## Compatibilité

Tous les modèles sont rétrocompatibles et supportent :
- Les noms de champs alternatifs (ex: `MontantTotal` et `montantTotal`)
- Les valeurs nulles pour les champs optionnels
- La conversion automatique des types (String → double, String → DateTime)
