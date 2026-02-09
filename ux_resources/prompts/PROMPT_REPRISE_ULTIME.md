# PROMPT REPRISE ULTIME - Mode Autonome

> Copie-colle ce prompt pour reprendre le travail. Claude decide, tu valides.

---

## MODE AUTONOME ACTIVE

Tu es en mode **"je te donne, tu decides"**. L'utilisateur est fatigue, il veut:
- Donner une screenshot ou une demande vague
- Que tu analyses et proposes
- Valider ou refuser, c'est tout

---

## WORKFLOW OBLIGATOIRE

### Etape 1: Lire l'Arbre
```
Lire: ux_resources/DESIGN_TREE.md
```
Identifier la PHASE concernee (0-7):
- Phase 0: Conception
- Phase 1: Tokens (spacing, colors, typo)
- Phase 2: Layout (responsive, nav)
- Phase 3: Composants (boutons, forms, cards)
- Phase 4: Feedback (motion, toasts)
- Phase 5: Conversion (checkout, trust)
- Phase 6: Accessibilite
- Phase 7: Validation

### Etape 2: Grep les Regles
```
Grep dans: ux_resources/WEB.md (~260 regles)
Grep dans: ux_resources/MOBILE.md (~320 regles)
```
Chercher par keyword selon le sujet.

### Etape 3: Lire le Code
```
Lire: hellwell/dashboard/Dashboard.Page.ps1
```
Section concernee uniquement.

### Etape 4: Proposer
Format de reponse:
```
## Analyse
[Ce que j'ai vu]

## Problemes
1. [Probleme] → [Regle violee] → [Solution]
2. ...

## Actions Proposees
- [ ] Action 1
- [ ] Action 2
- [ ] Action 3

Tu valides? (oui/non/modifie)
```

### Etape 5: Executer
Si validation:
1. Modifier le code
2. Relancer le serveur
3. Dire de faire Ctrl+F5
4. Attendre retour

### Etape 6: Sauver
Si ok:
```bash
git add . && git commit && git push
```

---

## RACCOURCIS UTILISATEUR

| Tu dis | Claude fait |
|--------|-------------|
| "screenshot" + image | Analyse complete + propositions |
| "c'est moche" | Mode holistique, redesign creatif |
| "optimise" | Audit complet vs regles UX |
| "ok" / "go" / "oui" | Execute les propositions |
| "non" / "stop" | Arrete et demande quoi changer |
| "push" | Commit + push GitHub |
| "relance" | Restart serveur |

---

## VALEURS CLES A RETENIR

| Quoi | Valeur |
|------|--------|
| Touch target | 44px minimum |
| Spacing base | 4px (8, 12, 16, 24, 32, 48) |
| Contraste texte | 4.5:1 |
| Contraste UI | 3:1 |
| Focus | 2px solid + offset 2px |
| Animation micro | 100-200ms |
| Animation standard | 250-350ms |
| Checkout fields | < 11.3 (moyenne) |
| Spring bounce | 0.15 subtil, 0.30 visible |

---

## ARBRE MENTAL

```
              DESIGN
                 |
     +-----------+-----------+
     |           |           |
  TOKENS      LAYOUT    COMPONENTS
     |           |           |
     +-----+-----+-----+-----+
           |           |
       FEEDBACK   ACCESSIBILITY
           |           |
           +-----+-----+
                 |
            CONVERSION
```

---

## COMMANDES SERVEUR

### Relancer (one-liner)
```powershell
taskkill /F /IM powershell.exe /T 2>nul & ping -n 2 127.0.0.1 >nul & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1' -WindowStyle Hidden"
```

### Verifier (attendre 4s)
```powershell
powershell.exe -NoProfile -Command "Start-Sleep -Seconds 4; Get-NetTCPConnection -LocalPort 8011 -State Listen"
```

---

## FICHIERS

```
c:\Users\ludov\.infernal_wheel\
  ux_resources/
    DESIGN_TREE.md    ← Arbre decision (LIRE EN PREMIER)
    WEB.md            ← 260 regles web
    MOBILE.md         ← 320 regles mobile
  hellwell/dashboard/
    Dashboard.Page.ps1 ← Code UI principal
```

---

## EXEMPLE SESSION

**User:** [envoie screenshot]

**Claude:**
```
## Analyse
Screenshot de la section calendrier.

## Problemes
1. Touch targets 32px → Regle: 44px min → Agrandir boutons
2. Contraste badge 2.8:1 → Regle: 3:1 UI → Foncer le texte
3. Pas de focus visible → Regle: outline 2px → Ajouter :focus-visible

## Actions Proposees
- [ ] Augmenter min-height boutons a 44px
- [ ] Passer badge text de #888 a #666
- [ ] Ajouter focus-visible sur tous les interactifs

Tu valides?
```

**User:** ok

**Claude:** [execute, relance, dit Ctrl+F5]

**User:** nickel

**Claude:** [commit + push]

---

*Mode autonome - Tu donnes, je decide, tu valides.*
