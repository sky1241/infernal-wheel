# Checklist UI

## Legende

- `[iOS]` : specifique iOS
- `[Android]` : specifique Android
- `[Universal]` : applicable partout
- `[PDF:page]` : reference PDF source

---

## 1. Layout & Responsive [Universal]

### Safe Areas
- [ ] `SafeArea` utilise pour le contenu principal
- [ ] Bottom nav respecte le home indicator iOS
- [ ] Header respecte le notch/dynamic island
- [ ] FAB positionne avec padding bottom

### Tailles d'ecran
- [ ] Teste sur 320dp (petit Android)
- [ ] Teste sur 375pt (iPhone SE)
- [ ] Teste sur 430pt (iPhone Pro Max)
- [ ] Pas de texte tronque
- [ ] Pas de overflow

### Orientation
- [ ] Portrait fonctionne
- [ ] Paysage : TBD (a definir si supporte)

---

## 2. Touch Targets [Universal] [PDF: WCAG 2.5.8]

- [ ] Tous les boutons >= 48dp (Android) / 44pt (iOS)
- [ ] Zones cliquables ont du padding meme si contenu petit
- [ ] Pas de cibles adjacentes trop proches (min 8px gap)

### Verification
```dart
// Dans les widgets
Container(
  width: Spacing.touchTarget,  // 48
  height: Spacing.touchTarget, // 48
  child: Icon(...),
)
```

---

## 3. Accessibilite [Universal]

### Screen readers [PDF: WCAG]
- [ ] Tous les boutons ont un `Semantics` label
- [ ] Images decoratives marquees `excludeSemantics: true`
- [ ] Ordre de lecture logique (testable avec TalkBack/VoiceOver)

### Tailles de texte
- [ ] App fonctionne avec `textScaleFactor: 2.0`
- [ ] Pas de texte coupe ou invisible
- [ ] Layouts s'adaptent

### Contraste [PDF: WCAG 2.4.11]
- [ ] Texte normal : ratio >= 4.5:1
- [ ] Texte large (18sp+) : ratio >= 3:1
- [ ] Elements interactifs : ratio >= 3:1

### Focus visible [PDF: WCAG 2.4.7, 2.4.13]
- [ ] Outline 2px solid sur focus
- [ ] Outline offset 2px
- [ ] Focus area minimum 4px

---

## 4. Etats UI [PDF: UX Behavioral Checklist]

### Loading
- [ ] Indicateur visible pendant chargement
- [ ] Pas d'ecran vide/blanc pendant load
- [ ] Skeleton ou spinner selon contexte

### Empty state
- [ ] Icone/illustration
- [ ] Message explicatif
- [ ] CTA si applicable ("Ajouter...", "Commencer...")

### Error state
- [ ] Message lisible (pas de stacktrace)
- [ ] Action de recovery si possible ("Reessayer")
- [ ] Couleur distinctive (rouge/orange)

### Success feedback
- [ ] Confirmation visuelle apres action importante
- [ ] Toast ou animation subtile
- [ ] Haptic feedback sur mobile

---

## 5. Inputs & Forms [Universal]

### Champs texte
- [ ] Label visible ou placeholder
- [ ] Indication erreur claire
- [ ] Focus state visible
- [ ] Clavier adapte (email, number, etc.)

### Boutons
- [ ] Etat desactive visuellement distinct
- [ ] Etat loading si action async
- [ ] Feedback au tap (ripple, scale)

### Sliders/Pickers
- [ ] Valeur actuelle visible
- [ ] Touch target suffisant
- [ ] Accessible au clavier (si web)

---

## 6. Animations [PDF: UX Behavioral Checklist]

### Principes
- [ ] Duree 200-300ms max
- [ ] Easing naturel (ease-out pour entree, ease-in pour sortie)
- [ ] Respecte `prefers-reduced-motion`

### Implementation
```dart
// Verifier les preferences
final reduceMotion = MediaQuery.of(context).disableAnimations;

// Adapter
AnimatedContainer(
  duration: reduceMotion
      ? Duration.zero
      : const Duration(milliseconds: 200),
  // ...
)
```

---

## 7. Couleurs [PDF: Color Cheatsheet]

### Dark mode
- [ ] Fond sombre, texte clair
- [ ] Contraste suffisant
- [ ] Pas de blanc pur (#FFF) - utiliser #F2F2F2

### Etats interactifs
- [ ] Hover : brightness +10%, saturation +30%
- [ ] Active : brightness -5%, saturation +40%
- [ ] Disabled : opacity 50% ou gris

### Semantique
- [ ] Rouge = erreur/danger
- [ ] Vert = succes/bon
- [ ] Jaune/orange = warning
- [ ] Bleu = info/lien

---

## 8. Typographie [Universal]

### Hierarchie
- [ ] Titres plus gros/gras que body
- [ ] Maximum 3-4 tailles differentes
- [ ] Line height confortable (1.4-1.6)

### Lisibilite
- [ ] Taille minimum 12sp
- [ ] Taille recommandee body 14-16sp
- [ ] Pas de texte tout en majuscules (sauf labels courts)

---

## 9. Navigation [Universal]

### Bottom nav
- [ ] Icones + labels
- [ ] Etat actif visuellement distinct
- [ ] 3-5 items maximum

### Back/Close
- [ ] Bouton back sur les ecrans secondaires
- [ ] X sur les modals
- [ ] Geste swipe back (iOS)

---

## 10. Performance visuelle

### Jank
- [ ] Scroll fluide 60 FPS
- [ ] Animations sans saccade
- [ ] Pas de flash blanc au chargement

### Images
- [ ] Tailles adaptees a l'ecran
- [ ] Placeholder pendant chargement
- [ ] Cache si reutilisees
