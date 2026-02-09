# PROMPT CSS FIX - Correction UI Rapide

## QUAND L'UTILISER
Quand tu vois un bug visuel (alignement, spacing, overflow, etc.) et tu veux que je corrige vite.

## COMMENT L'UTILISER
1. Copie-colle ce message + envoie ton screenshot:

```
Mode CSS FIX. Regarde le screenshot et corrige.
```

C'est tout. Pas besoin d'expliquer le problème.

---

## INSTRUCTIONS POUR CLAUDE (ne pas modifier)

### ETAPE 1: CHARGER LES REGLES
Lire automatiquement:
- `ux_resources/DESIGN_TREE.md` (valeurs de référence)

### ETAPE 2: ANALYSER LE SCREENSHOT
Checker pixel par pixel:
- [ ] Alignement horizontal (tous les éléments alignés?)
- [ ] Alignement vertical (même hauteur?)
- [ ] Spacing cohérent (multiples de 4px: 4, 8, 12, 16, 24, 32, 48)
- [ ] Overflow/clip (ombres, halos, bordures coupées?)
- [ ] Touch targets (min 44px)
- [ ] Padding symétrique (gauche = droite?)
- [ ] Gaps entre éléments (8px min entre groupes)

### ETAPE 3: REPONDRE FORMAT COURT
```
PROBLEMES DETECTES:
1. [element] - [problème] - [valeur actuelle vs attendue]
2. ...

CORRECTION: [oui/non pour confirmer]
```

### ETAPE 4: CORRIGER EN UNE SEULE FOIS
- Identifier le fichier
- Faire TOUTES les corrections d'un coup
- Relancer
- Screenshot de vérification si besoin

### VALEURS DE REFERENCE RAPIDES
| Element | Valeur |
|---------|--------|
| Spacing base | 4px |
| Gap elements | 8px |
| Padding card | 16px |
| Touch target | 44px min |
| Border radius | 8px |
| Outline focus | 2px solid |
| Shadow subtle | 0 4px 12px rgba(0,0,0,.2) |
| Halo glow | 10-15px max |

### REGLES D'OR
1. **PAS de clarification** - Je devine d'après le screenshot
2. **Résumé court** - Max 3-4 lignes de problèmes
3. **Une seule passe** - Tout corriger d'un coup
4. **Valeurs du design system** - Pas inventer, utiliser les standards
