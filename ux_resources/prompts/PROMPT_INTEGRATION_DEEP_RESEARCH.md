# PROMPT INTÉGRATION DEEP RESEARCH

## CONTEXTE
Tu vas recevoir les résultats d'une Deep Research ChatGPT (~100 pages) couvrant:
- Gamification & Engagement
- Tables & Data Grids
- Settings & Preferences
- Search UX
- Loading & Performance
- Dark Mode
- Modals & Overlays
- Animations & Micro-interactions
- Onboarding

## TA MISSION

### 1. DÉTECTER LES DOUBLONS
Avant d'intégrer quoi que ce soit:

1. **Lire les fichiers existants:**
   ```
   ux_resources/WEB.md
   ux_resources/MOBILE.md
   ```

2. **Pour CHAQUE règle de la Deep Research, vérifier:**
   - Existe-t-elle déjà? (grep le concept clé)
   - Si oui: la nouvelle version est-elle MEILLEURE (plus précise, sourcée)?
   - Si doublon identique: IGNORER
   - Si doublon amélioré: REMPLACER
   - Si nouveau: AJOUTER

3. **Signaler les doublons trouvés:**
   ```
   DOUBLONS DÉTECTÉS:
   - [Concept X] existe ligne Y de WEB.md → nouvelle version meilleure? OUI/NON
   - [Concept Z] existe ligne W de MOBILE.md → IDENTIQUE, ignoré
   ```

### 2. RECHERCHER LES COMPLÉMENTS MANQUANTS
Utiliser WebSearch pour vérifier si la Deep Research a oublié des patterns importants:

**Recherches suggérées:**
- "UX patterns 2025 2026" (nouveautés récentes)
- "[Concept spécifique] best practices" (si un concept semble incomplet)
- "Apple HIG [feature] 2025" (mises à jour iOS)
- "Material Design 3 [feature] 2025" (mises à jour Android)

**Objectif:** Ne pas juste copier la Deep Research, mais la compléter si nécessaire.

### 3. INTÉGRER PROPREMENT

**Structure d'intégration dans WEB.md:**
```markdown
## N. [Nouvelle Section]

### XX. [Sous-section]

| Aspect | Web | iOS | Android | Source |
|--------|-----|-----|---------|--------|
| [Métrique] | [valeur] | [valeur] | [valeur] | [source] |

**Exemples d'apps:** App1, App2, App3

**Checklist:**
- [ ] Point 1
- [ ] Point 2
```

**Règles de formatage:**
- Tableaux avec colonnes Web/iOS/Android quand applicable
- Sources avec liens si disponibles
- Checklist actionable à chaque section
- Exemples d'apps réelles

### 4. CRÉER LES NOUVELLES SECTIONS

**Dans WEB.md, ajouter après Section M:**
- Section N: Gamification & Engagement
- Section O: Tables & Data Grids
- Section P: Settings & Preferences
- Section Q: Search UX
- Section R: Loading & Performance
- Section S: Dark Mode
- Section T: Modals & Overlays
- Section U: Animations
- Section V: Onboarding

**Dans MOBILE.md, ajouter/enrichir:**
- Sections correspondantes avec spécificités iOS/Android
- Valeurs natives (pt, dp) prioritaires

### 5. METTRE À JOUR LES FICHIERS ANNEXES

Après intégration:

1. **COMMANDES.txt** - Mettre à jour les compteurs:
   ```
   - WEB.md = ~XXX regles web (YY sections)
     - Sections A-M: [existant]
     - Sections N-V: [nouvelles]
   ```

2. **MEMORY.md** - Ajouter les nouvelles sections

3. **DESIGN_TREE.md** - Si l'arbre de décision doit évoluer

### 6. VALIDATION FINALE

Checklist avant de terminer:
- [ ] Aucun doublon (grep vérifié)
- [ ] Toutes les valeurs ont des unités (px, pt, dp, ms)
- [ ] Toutes les sections ont une checklist
- [ ] Sources présentes (même si "Deep Research 2026")
- [ ] Format cohérent avec sections existantes
- [ ] Compteurs mis à jour dans COMMANDES.txt

---

## WORKFLOW RÉSUMÉ

```
1. USER: Colle les résultats Deep Research
2. CLAUDE:
   a) Lit WEB.md + MOBILE.md existants
   b) Détecte doublons → liste
   c) WebSearch compléments si besoin
   d) Intègre section par section
   e) Met à jour fichiers annexes
   f) Valide checklist finale
3. USER: Valide ou ajuste
```

---

## RACCOURCIS

| Commande | Action |
|----------|--------|
| "intègre tout" | Lancer le workflow complet |
| "vérifie doublons" | Juste l'étape 1 |
| "complète [section]" | WebSearch + intégration pour 1 section |
| "push" | Commit les changements |

---

## ANTI-PATTERNS À ÉVITER

- ❌ Copier-coller sans vérifier les doublons
- ❌ Perdre le format existant (tableaux, checklists)
- ❌ Oublier de mettre à jour les compteurs
- ❌ Ajouter des règles sans valeurs concrètes
- ❌ Mélanger Web et Mobile dans le même tableau sans distinction
- ❌ Ignorer les sources
