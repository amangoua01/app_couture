# API Endpoints

Base URL: `https://backend.ateliya.com/api`

## Auth

| Méthode | Endpoint |
|---------|----------|
| POST | `/login` |
| POST | `/user/create` |
| POST | `/logout` |
| POST | `/auth/reset-password` |
| POST | `/reset-password/request` |
| POST | `/reset-password/verify-token-expired` |
| POST | `/reset-password/reset` |
| POST | `/user/update/profil/{id}` |
| POST | `/device-token` |
| DELETE | `/user/delete/{userId}` |

## Boutique

| Méthode | Endpoint |
|---------|----------|
| GET | `/boutique/` |
| POST | `/boutique/create` |
| PUT | `/boutique/update/{id}` |
| DELETE | `/boutique/delete/{id}` |
| POST | `/boutique/delete/all/items` |
| GET | `/modeleBoutique/modele/by/boutique/{id}` |
| POST | `/paiement/boutique/multiple/{boutiqueId}` |
| POST | `/vente/boutique/{id}` |
| DELETE | `/paiement/delete-boutique/{id}` |

## Modèle

| Méthode | Endpoint |
|---------|----------|
| GET | `/modele/` |
| GET | `/modele/{id}` |
| POST | `/modele/create` |
| PUT | `/modele/update/{id}` |
| DELETE | `/modele/delete/{id}` |
| POST | `/modele/delete/all/items` |

## Modèle Boutique

| Méthode | Endpoint |
|---------|----------|
| GET | `/modeleBoutique/` |
| GET | `/modeleBoutique/details/{modeleId}` |
| GET | `/stock/{boutiqueId}` (avec params page, limit) |
| POST | `/modeleBoutique/create` |
| PUT | `/modeleBoutique/update/{id}` |
| DELETE | `/modeleBoutique/delete/{id}` |
| POST | `/modeleBoutique/delete/all/items` |

## Stock

| Méthode | Endpoint |
|---------|----------|
| POST | `/stock/entree` |
| PUT | `/stock/confirmer/{stockId}` |
| PUT | `/stock/rejeter/{stockId}` |
| POST | `/stock/transfert` |
| POST | `/stock/sortie-directe` |

## Client

| Méthode | Endpoint |
|---------|----------|
| GET | `/client/` |
| GET | `/client/{id}` |
| POST | `/client/create` |
| PUT | `/client/update/{id}` |
| DELETE | `/client/delete/{id}` |
| POST | `/client/delete/all/items` |

## Facture

| Méthode | Endpoint |
|---------|----------|
| GET | `/facture/` |
| GET | `/facture/{id}` |
| POST | `/facture/create` |
| PUT | `/facture/update/{id}` |
| DELETE | `/facture/delete/{id}` |
| POST | `/facture/delete/all/items` |
| POST | `/paiement/facture/{mesureId}` |
| POST | `/facture/{id}/update-details` |
| POST | `/facture/advanced/{succursaleId}` |
| GET | `/paiement/facture/{factureId}/boutique/{boutiqueId}` |

## Mesure

| Méthode | Endpoint |
|---------|----------|
| POST | `/facture/create` |
| POST | `/mesure/etat/{ligneMesureId}` |
| POST | `/mesure/facture/etat/{id}` |

## Réservation

| Méthode | Endpoint |
|---------|----------|
| GET | `/reservation/` |
| GET | `/reservation/{id}` |
| POST | `/reservation/create` |
| PUT | `/reservation/update/{id}` |
| DELETE | `/reservation/delete/{id}` |
| POST | `/reservation/delete/all/items` |

## Dépense

| Méthode | Endpoint |
|---------|----------|
| GET | `/depense/` |
| GET | `/depense/{id}` |
| POST | `/depense/create` |
| PUT | `/depense/update/{id}` |
| DELETE | `/depense/delete/{id}` |
| POST | `/depense/delete/all/items` |

## Famille Dépense

| Méthode | Endpoint |
|---------|----------|
| GET | `/famille-depense/?page={page}` |

## Caisse

| Méthode | Endpoint |
|---------|----------|
| GET | `/depense/transactions/{boutiqueId}/boutique` |
| GET | `/mouvement-caisse/{boutiqueId}/boutique` |
| POST | `/mouvement-caisse/create` |

## Statistiques

| Méthode | Endpoint |
|---------|----------|
| POST | `/statistique/stock/{boutiqueId}` |
| POST | `/statistique/ateliya/{type}/{boutiqueId}` |
| POST | `/statistique/ateliya/dashboard` |

## Notification

| Méthode | Endpoint |
|---------|----------|
| GET | `/notification/` |
| POST | `/notification/{notificationId}/read` |
| GET | `/notification/count-unread` |
| DELETE | `/notification/{notificationId}` |
| POST | `/notification/delete/all/items` |

## Personnel

| Méthode | Endpoint |
|---------|----------|
| GET | `/user/` |
| GET | `/user/{id}` |
| POST | `/user/create` |
| PUT | `/user/update/{id}` |
| DELETE | `/user/delete/{id}` |
| POST | `/user/delete/all/items` |

## Succursale

| Méthode | Endpoint |
|---------|----------|
| GET | `/succursale/` |
| GET | `/succursale/{id}` |
| POST | `/succursale/create` |
| PUT | `/succursale/update/{id}` |
| DELETE | `/succursale/delete/{id}` |
| POST | `/succursale/delete/all/items` |

## Entreprise

| Méthode | Endpoint |
|---------|----------|
| GET | `/entreprise/` |
| GET | `/entreprise/{id}` |
| POST | `/entreprise/create` |
| PUT | `/entreprise/update/{id}` |
| GET | `/entreprise/surccursale/boutique` |
| GET | `/entreprise/info` |
| POST | `/entreprise/update` |

## Abonnement

| Méthode | Endpoint |
|---------|----------|
| GET | `/abonnement/entreprise` |
| GET | `/moduleAbonnement/` |
| POST | `/abonnement/abonnement/{forfaitId}` |

## Accueil

| Méthode | Endpoint |
|---------|----------|
| GET | `/accueil/` |

## Catégorie Mesure

| Méthode | Endpoint |
|---------|----------|
| GET | `/categorieMesure/` |
| GET | `/categorieMesure/{id}` |
| POST | `/categorieMesure/create` |
| PUT | `/categorieMesure/update/{id}` |
| DELETE | `/categorieMesure/delete/{id}` |
| POST | `/categorieMesure/delete/all/items` |

## Catégorie Type Mesure

| Méthode | Endpoint |
|---------|----------|
| GET | `/categorieTypeMesure/` |
| GET | `/categorieTypeMesure/{id}` |
| POST | `/categorieTypeMesure/create` |
| PUT | `/categorieTypeMesure/update/{id}` |
| DELETE | `/categorieTypeMesure/delete/{id}` |
| POST | `/categorieTypeMesure/delete/all/items` |
| POST | `/categorieTypeMesure/change-ordre-multiple` |

## Type Mesure

| Méthode | Endpoint |
|---------|----------|
| GET | `/typeMesure/` |
| GET | `/typeMesure/{id}` |
| POST | `/typeMesure/create` |
| PUT | `/typeMesure/update/{id}` |
| DELETE | `/typeMesure/delete/{id}` |
| POST | `/typeMesure/delete/all/items` |
| GET | `/typeMesure/entreprise` |

## Type User

| Méthode | Endpoint |
|---------|----------|
| GET | `/typeUser/` |
| GET | `/typeUser/{id}` |
| POST | `/typeUser/create` |
| PUT | `/typeUser/update/{id}` |
| DELETE | `/typeUser/delete/{id}` |
| POST | `/typeUser/delete/all/items` |

## Opérateur

| Méthode | Endpoint |
|---------|----------|
| GET | `/operateur/` |

## Pays

| Méthode | Endpoint |
|---------|----------|
| GET | `/pays/actif` |

## Images

| Pattern |
|---------|
| `https://backend.ateliya.com/uploads/{path}/{alt}` |
