# CLAUDE.md — règles inviolables pour ce repo

> Ce fichier est chargé automatiquement par Claude Code au démarrage de
> chaque session. Les règles ci-dessous ne sont PAS optionnelles.

---

## RÈGLE 1 — Forge est l'outil de test officiel du projet

Le repo contient `forge.py` à la racine. C'est un harness de test custom de
2252 lignes (mutation testing, defect prediction, fault localization, flaky
detection, etc.). **Tu DOIS l'utiliser.**

### Au démarrage de toute session de coding

```bash
python forge.py            # Voir l'état des tests + diff vs baseline
cat BUGS.md                # Voir les bugs ouverts en cours
```

Si forge dit FAIL → tu corriges les failures avant de toucher à autre chose.

### Avant chaque commit

```bash
python forge.py            # Doit afficher PASS et 0 régression vs baseline
```

Si tu vois `Failed: X -> Y (+N)` avec N > 0 → tu n'as pas le droit de commit.

### Quand tu trouves un bug

```bash
python forge.py --add "description claire de la symptôme + cause"
# fix le bug
# écris un test qui reproduit le bug AVANT le fix et qui passe APRÈS
python forge.py            # Vérifie 0 régression
# édite BUGS.md à la main pour passer le statut OPEN -> FIXED + commit hash
```

### Quand tu écris des tests

- Format **pytest** obligatoire (`def test_xxx():` avec `assert`)
- PAS de `sys.exit()` au top level (forge utilise pytest qui crash dessus)
- PAS de fonction helper appelée `def test()` (pytest la confond avec un
  test et tente d'injecter `name` comme fixture). Utilise `_check()` ou
  `_assert()` à la place.
- Le fichier doit être trouvable par `python -c "from pathlib import Path; print(list(Path('.').glob('**/test_*.py')))"`

### Commandes forge à connaître

| Commande | Quand l'utiliser |
|----------|------------------|
| `python forge.py` | Au démarrage, après chaque modif, avant chaque commit |
| `python forge.py --baseline` | Une fois, après avoir verdé tous les tests |
| `python forge.py --diff` | Comparer l'état actuel vs baseline sauvée |
| `python forge.py --predict` | Trouver les fichiers à risque d'avoir des bugs (Kalman + git history) |
| `python forge.py --carmack` | Analyse avancée (Wavelet + Kaplan-Meier + coupling) |
| `python forge.py --mutate FILE` | Mutation testing sur un fichier — révèle les tests superficiels |
| `python forge.py --locate` | Fault localization Ochiai (sur les failing tests) |
| `python forge.py --flaky-dtw 3` | Détecter les tests flaky en 3 runs |
| `python forge.py --add "..."` | Logger un bug dans BUGS.md |
| `python forge.py --close BUG+NNN` | Marquer un bug FIXED (incomplet — édite BUGS.md à la main aussi) |

### Bugs déjà connus dans forge.py lui-même

- BUG+005 (FIXED) — `--add` assignait toujours BUG+001 (regex `BUG-` vs writer `BUG+`).
  Patché dans forge.py ligne 445.

---

## RÈGLE 2 — Audit manuel sans forge n'est PAS un audit

Si tu fais un "audit complet" en lisant les fichiers à l'œil et en
trouvant des bugs, tu n'as PAS audité. Tu as juste lu du code. Un audit
réel inclut :

1. `python forge.py --predict` pour identifier les fichiers à risque par
   git history (pas par intuition)
2. `python forge.py --carmack` pour les fichiers à fort coupling
3. `python forge.py --mutate FILE` pour vérifier que les tests existants
   tuent les mutations (sinon tes tests sont superficiels)
4. Pour chaque bug → `forge.py --add` puis fix puis test pytest puis
   `forge.py --diff` pour confirmer 0 régression

Sans ces 4 étapes, ce n'est pas un audit, c'est de l'illusion de travail.

---

## RÈGLE 3 — Tests sur la VRAIE montre via ADB

L'app cible une Galaxy Watch 7. Toutes les hypothèses sur le comportement
de la montre doivent être **vérifiées via logcat**, pas devinées.

```bash
"/c/Users/ludov/OneDrive/Bureau/platform-tools/adb.exe" devices
"/c/Users/ludov/OneDrive/Bureau/platform-tools/adb.exe" -s 192.168.1.122:PORT logcat -d -t 200 | grep DetectionService
```

Le port WiFi de la montre change à chaque session — toujours demander à
l'utilisateur le nouveau port via "Débogage Wi-Fi" sur la montre.

---

## RÈGLE 4 — Commits granulaires + push après chaque fix

Pas de "commit géant qui fix 10 bugs en un coup". Un bug = un commit avec
un message clair :

```
fix(module): brève description

## Bug
- Symptôme: ...
- Root cause: ...

## Fix
- Ce qui a été changé et pourquoi

## Test
- test_xxx.py::test_yyy verifies that ...

## Forge baseline
- avant: 58 passed, 0 failed
- après: 59 passed, 0 failed (+1)
```

---

## RÈGLE 5 — Si tu ne sais pas, lis le repo. Ne devine pas.

Avant d'écrire un nouveau script de test, vérifier si forge.py a déjà la
fonctionnalité (`--mutate`, `--locate`, `--flaky-dtw`, etc.).

Avant de réinventer un wrapper Kotlin, vérifier dans
`trilateration/wear-os-app/app/src/main/java/com/infernal/smokingdetector/`
si le pattern existe déjà (MessageSyncManager pour le sync, GorillaCompressor
pour la compression, etc.).

Avant de "fixer" un bug, lancer `python forge.py --predict` pour voir si
le fichier est dans la liste des fichiers à risque — souvent le bug que tu
veux fixer n'est pas le vrai problème.

---

## Historique des violations

- **2026-04-10** : Pendant 9 passes d'audit manuel, j'ai ignoré l'existence
  de forge.py malgré les rappels du user. 5 bugs critiques ont été trouvés
  par forge en 3 commandes après que le user m'ait engueulé. Les 9 passes
  d'audit manuel précédentes auraient dû passer par forge.py dès le départ.
  Cette violation a coûté plusieurs heures et a justifié l'ajout de ce
  fichier CLAUDE.md.
