# MODE CSS FIX - Correction UI avec Confirmation Visuelle

## QUAND L'UTILISER
Bug visuel: alignement, spacing, overflow, "ce truc est pas droit", etc.

## COMMENT L'UTILISER
1. Envoie ton screenshot
2. Dis "CSS FIX" ou "aligne ça" ou "c'est pas droit"
3. Je te montre ce que j'ai compris → tu valides → je corrige

---

## INSTRUCTIONS POUR CLAUDE

### ETAPE 1: ANALYSER ET NOMMER
Quand tu reçois un screenshot:

1. **Identifier chaque zone/élément visible**
2. **Les nommer clairement:**
   ```
   [A] = Header / barre du haut
   [B] = Sidebar gauche
   [C] = Zone principale
   [D] = Card "Tabac"
   [E] = Bouton "+1 clope"
   [F] = Ligne de stats
   ...
   ```

3. **Lister les problèmes détectés avec références:**
   ```
   PROBLEMES:
   1. [D] Card Tabac - padding gauche 12px, droite 8px → asymétrique
   2. [E] Bouton - pas aligné verticalement avec [F]
   3. [F] Ligne stats - gap irrégulier (4px, 12px, 6px)
   ```

### ETAPE 2: DEMANDER CONFIRMATION
```
J'ai identifié 3 problèmes sur [D], [E], [F].

Tu veux que je corrige:
- [ ] Tout
- [ ] Seulement [D]
- [ ] Autre chose que j'ai pas vu?
```

**ATTENDRE LA REPONSE** - ne pas corriger avant validation.

### ETAPE 3: SI L'USER POINTE UN ELEMENT
Quand l'user dit "non c'est la ligne là" ou "le truc à droite":

1. **Redemander en montrant les options:**
   ```
   Tu parles de:
   - [E] le bouton?
   - [F] la ligne de stats?
   - [G] autre chose en bas?
   ```

2. **Ne JAMAIS deviner** - toujours confirmer avant de toucher au code

### ETAPE 4: CORRIGER
Une fois confirmé:
1. Identifier le fichier exact
2. Faire TOUTES les corrections validées d'un coup
3. Proposer de relancer le serveur

---

## VALEURS DE REFERENCE

| Element | Valeur |
|---------|--------|
| Spacing base | 4px |
| Gap entre éléments | 8px min |
| Padding cards | 16px |
| Touch target | 44px min |
| Border radius | 8px standard |
| Outline focus | 2px solid + 2px offset |

## VOCABULAIRE COMMUN

| User dit | = |
|----------|---|
| "ligne" | Rangée horizontale d'éléments |
| "colonne" | Groupe vertical |
| "le truc" | → demander précision avec [A][B][C] |
| "à gauche/droite" | Position relative dans la zone |
| "en haut/bas" | Position verticale |
| "le bouton là" | → identifier par couleur/texte visible |

## REGLE D'OR
**MONTRER CE QUE J'AI COMPRIS AVANT DE CODER**

Mieux vaut 1 question de clarification que 3 corrections ratées.
