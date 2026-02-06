# Budgets Performance

## Temps de demarrage

| Phase | Budget | Notes |
|-------|--------|-------|
| Cold start -> premier frame | < 2000ms | Mesure DevTools |
| Warm start | < 500ms | Apres background |
| Hot reload (dev) | < 1000ms | N/A en prod |

## Frame rate

| Contexte | Cible | Minimum acceptable |
|----------|-------|--------------------|
| Idle | 60 FPS | 60 FPS |
| Scroll simple | 60 FPS | 55 FPS |
| Animation | 60 FPS | 50 FPS |
| Transition page | 60 FPS | 45 FPS |

## Memoire

| Etat | Budget | Alerte si |
|------|--------|-----------|
| Idle (dashboard) | < 80 MB | > 100 MB |
| Navigation intensive | < 150 MB | > 200 MB |
| Pic maximum | < 200 MB | > 250 MB |

## Stockage

| Type | Budget |
|------|--------|
| App installee | < 30 MB |
| Donnees utilisateur (1 an) | < 10 MB |
| Cache | < 20 MB |
| **Total** | < 60 MB |

## I/O

| Operation | Budget |
|-----------|--------|
| Lecture jour courant | < 50ms |
| Sauvegarde jour | < 100ms |
| Chargement settings | < 30ms |
| Liste 30 jours | < 200ms |

## Batterie

| Contexte | Cible |
|----------|-------|
| Session 5 min | < 1% batterie |
| Background | 0% (pas d'activite) |
| Fetch Health (si autorise) | < 0.5% par fetch |

---

## Notes

- Tous les budgets sont pour **low-end devices** (voir `01_device-compat/matrix.md`)
- Les valeurs sans source PDF sont marquees comme estimations raisonnables
- A ajuster apres tests reels sur vrais devices
