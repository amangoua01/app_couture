# Bugs Backend

## 🐛 API

| # | Méthode | URL | Code | Erreur |
|---|---------|-----|------|--------|
| 1 | POST | `/api/paiement/boutique/multiple/38` | 404 | No route found |
| 2 | GET | `/api/paiement/transactions/38/boutique?date=XXXX&month=XXXX` | 200 | Retourne toujours les mêmes données quelle que soit la date |
| 3 | POST | `/api/statistique/stock/38` | 500 | Attempted to call an undefined method named "getUser" of class "GetStatistiqueStockUseCase" |
| 4 | POST | `/api/stock/entree` | 500 | Call to a member function serialize() on null |
| 5 | GET | `/api/stock/38` | 404 | No route found |
