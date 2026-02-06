# UX Patterns pour Montres Connectees

## Principes de base

### 1. Zero-friction data
- Les donnees de la montre doivent etre importees AUTOMATIQUEMENT
- Pas de sync manuelle, pas de bouton "importer"
- L'app detecte les nouvelles donnees au lancement

### 2. Fallback gracieux
- Si pas de montre: UI simple de saisie manuelle
- Si montre mais pas de donnees: message explicatif
- Jamais d'ecran vide ou d'erreur bloquante

### 3. Transparence sur la source
- Toujours indiquer d'ou viennent les donnees
- Icone montre = auto, icone crayon = manuel
- Permet a l'utilisateur de faire confiance aux chiffres

## Patterns specifiques

### Onboarding Montre

```
Ecran 1: "Tu as une montre connectee?"
  [Oui, Apple Watch]
  [Oui, Android/Autre]
  [Non, saisie manuelle]

Ecran 2 (si oui): "Autoriser l'acces aux donnees sante"
  - Explication claire de ce qu'on lit (sommeil uniquement)
  - Bouton "Autoriser" -> demande permission systeme

Ecran 3: Confirmation
  "Parfait! Ton sommeil sera importe automatiquement."
  [Commencer]
```

### Etat sans donnees

```
+----------------------------------+
|         😴                       |
|                                  |
|   Pas de donnees sommeil         |
|                                  |
|   Ta montre n'a pas enregistre   |
|   de sommeil cette nuit.         |
|                                  |
|   [Saisir manuellement]          |
+----------------------------------+
```

### Saisie manuelle simplifiee

```
+----------------------------------+
|   Heure de reveil                |
|                                  |
|      [ 10 : 30 ]                |
|        ↑↓    ↑↓                  |
|                                  |
|   Tu as dormi combien?           |
|                                  |
|   [6h] [7h] [8h+]               |
|                                  |
|           [OK]                   |
+----------------------------------+
```

Note: Pas besoin de l'heure de coucher pour le use case.
Juste reveil + duree estimee suffit.

### Carte sommeil remplie

```
+----------------------------------+
| 😴 Sommeil              ⌚ auto  |
|                                  |
|  Reveil     Duree      Qualite  |
|  10:30      7h30       8/10     |
|                         🟢       |
+----------------------------------+
```

Legende:
- ⌚ = donnees auto de la montre
- ✏️ = donnees saisies manuellement
- 🟢🟡🔴 = indicateur visuel qualite

## Gestion des erreurs

### Permission refusee
```
"Pour importer ton sommeil, autorise l'acces dans
Reglages > Confidentialite > Sante > InfernalWheel"

[Ouvrir Reglages]  [Continuer sans]
```

### Montre non connectee (Android)
```
"Health Connect n'est pas installe.
Installe-le pour synchroniser ta montre."

[Installer Health Connect]  [Continuer sans]
```

### Pas de donnees recentes
```
"Aucune donnee de sommeil trouvee.
Assure-toi que ta montre etait chargee cette nuit."

[Saisir manuellement]
```

## Haptic feedback

- Increment addiction: vibration legere (light impact)
- Decrement addiction: vibration legere
- Sauvegarde auto: aucune vibration (silencieux)
- Export: vibration de succes

## Animations

### Compteur addiction
- Scale down on press (0.95)
- Scale up on release (1.0)
- Duration: 100ms

### Trend indicator
- Fade in au chargement
- Pulse si "good" (reduction vs hier)

### Sleep card
- Slide up au chargement
- Glow subtil sur le score si "great"

## Accessibilite

- VoiceOver/TalkBack pour tous les elements
- Labels explicites: "Bouton plus, 5 cigarettes, tendance en hausse"
- Touch targets 48x48 minimum
- Contraste suffisant (WCAG AA minimum)
