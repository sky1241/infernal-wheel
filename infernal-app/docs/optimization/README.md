# Dossier Optimisation & Qualite

## Objectif

Ce dossier centralise toutes les regles, protocoles et references pour garantir :
- **Fiabilite** : comportement stable sur tous les devices
- **Performance** : fluidite meme sur telephones low-end
- **Compatibilite** : iOS + Android, toutes tailles d'ecran
- **Maintenabilite** : code structure, logs exploitables

## Structure

```
docs/optimization/
├── README.md              <- Ce fichier
├── INDEX.md               <- Table des matieres avec liens
├── 00_scope.md            <- Perimetre du projet
├── 01_device-compat/      <- Compatibilite multi-devices
│   ├── matrix.md          <- Matrice de compatibilite
│   ├── known-issues.md    <- Bugs connus
│   └── test-protocol.md   <- Protocoles de test
├── 02_performance/        <- Optimisation performance
│   ├── budget.md          <- Budgets perf (FPS, memoire, startup)
│   ├── profiling.md       <- Comment profiler
│   └── hotpaths.md        <- Chemins critiques
├── 03_stability/          <- Stabilite runtime
│   ├── crash-safety.md    <- Guards et protections
│   ├── logging.md         <- Format des logs
│   └── error-taxonomy.md  <- Categories d'erreurs
├── 04_ui-rules/           <- Regles UI/UX
│   ├── source-of-truth.md <- References PDFs
│   └── checklist.md       <- Checklist UI
└── 05_release-readiness/  <- Preparation release
    ├── build-checks.md    <- Verifications build
    └── configs.md         <- Configurations
```

## Utilisation

1. **Avant dev** : consulter `04_ui-rules/checklist.md`
2. **Pendant dev** : respecter `03_stability/crash-safety.md`
3. **Avant commit** : verifier `05_release-readiness/build-checks.md`
4. **Debug** : suivre `03_stability/logging.md`

## Contraintes

- **Aucune connexion externe requise** (pas de Firebase, analytics, etc.)
- **100% offline-first** : l'app fonctionne sans internet
- **Valeurs sourcees** : tout chiffre vient d'un PDF ou est marque "TBD"
