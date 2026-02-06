# Migration donnees PowerShell -> App

Scripts pour migrer les donnees du projet PowerShell actuel vers la nouvelle app.

## Fichiers a migrer

### Depuis ~/.infernal_wheel/

- `log.csv` → Historique actions (work, sleep, clope, etc)
- `drinks.csv` → Consommation alcool
- `notes/*.txt` → Notes quotidiennes
- `state.json` → Etat actuel (pas necessaire pour migration)
- `settings.json` → Configuration (partiellement)

## Format de sortie

Un fichier JSON par jour, compatible avec `DayEntry.fromJson()`:

```json
{
  "dayKey": "2024-02-06",
  "sleep": {
    "source": "manual",
    "wakeTime": "2024-02-06T10:30:00",
    "durationMinutes": 450,
    "quality": "good"
  },
  "addictions": [
    {"type": "tabac", "count": 5, "firstTime": "2024-02-06T11:15:00"},
    {"type": "biere", "count": 2, "firstTime": null}
  ],
  "journalText": "Contenu des notes...",
  "createdAt": "2024-02-06T10:30:00",
  "updatedAt": "2024-02-06T23:45:00"
}
```

## Script de migration

Voir `migrate.ps1` pour le script PowerShell.

## Utilisation

1. Lancer le script de migration sur PC
2. Transferer les fichiers JSON vers le telephone
3. Au premier lancement de l'app, importer les donnees

## Notes

- Les donnees de sommeil seront marquees comme "manual"
- Les heures de "premiere clope/biere" seront approximatives (basees sur le log)
- Le texte des notes sera nettoye (suppression des metriques inline)
