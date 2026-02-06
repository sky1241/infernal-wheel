# Bugs Connus

## Format

```
## [ID] Titre court
- **Plateforme** : iOS / Android / Universal
- **Severite** : Critical / High / Medium / Low
- **Status** : Open / In Progress / Fixed / Won't Fix
- **Description** : ...
- **Reproduction** : ...
- **Workaround** : ...
- **Fix** : ...
```

---

## [KI-001] Health Connect non installe sur certains Android
- **Plateforme** : Android
- **Severite** : Medium
- **Status** : Open (by design)
- **Description** : Health Connect n'est pas pre-installe sur tous les Android
- **Reproduction** : Lancer l'app sur un Android sans Health Connect
- **Workaround** : Fallback vers saisie manuelle
- **Fix** : Afficher un message avec lien Play Store pour installer

---

## [KI-002] HealthKit permission refusee silencieusement
- **Plateforme** : iOS
- **Severite** : Medium
- **Status** : Open (by design)
- **Description** : L'utilisateur peut refuser HealthKit dans Settings apres l'avoir accepte
- **Reproduction** : Accepter, puis aller dans Settings > Privacy > Health et revoquer
- **Workaround** : Verifier permission a chaque fetch
- **Fix** : Re-demander avec message explicatif si refuse

---

## [KI-003] Clavier cache les inputs en bas d'ecran
- **Plateforme** : Universal
- **Severite** : Low
- **Status** : Open
- **Description** : Sur petit ecran, le clavier peut cacher le champ journal
- **Reproduction** : Ouvrir clavier sur iPhone SE en mode journal
- **Workaround** : Scroller manuellement
- **Fix** : Utiliser `SingleChildScrollView` avec `resizeToAvoidBottomInset`

---

## Template pour nouveaux bugs

```markdown
## [KI-XXX] Titre
- **Plateforme** :
- **Severite** :
- **Status** : Open
- **Description** :
- **Reproduction** :
- **Workaround** :
- **Fix** :
```
