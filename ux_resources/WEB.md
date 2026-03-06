# UX Web Complet - Patterns Consolidés

> Consolidation des patterns UX pour applications WEB
> Sources: PDFs dans `ux_resources/`

---

## A. États & Feedback

### 1. Loading States

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Choisir spinner/skeleton/progress | Spinner = attente courte indéterminée; Progress bar = estimation possible; Skeleton = contenu dense | Spinner plein écran pour action locale; Progress bar sans estimation fiable | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| Seuils d'affichage | Ne pas afficher d'indicateur pour réponses quasi instantanées; Feedback avant que l'utilisateur doute | UI figée sans changement; "Flicker" (loader trop tôt) | [NN/g Website Response Times](https://www.nngroup.com/articles/website-response-times/) |
| Skeleton efficace | Refléter structure réelle; Préserver dimensions finales (pas de layout shift); Animation subtile | Skeleton générique; Shimmer agressif; Layout qui saute | [Material Design Progress](https://material.io/components/progress-indicators) |
| Optimistic UI | Mise à jour immédiate si action rapide et annulable; Stratégie rollback explicite | Optimistic sur actions irréversibles (paiement); Absence de rollback | [Material Snackbars](https://material.io/components/snackbars) |
| Lazy loading | Infinite scroll = exploration; "Load more"/pagination = repérage précis | Infinite scroll sans sauvegarde position; Footer inaccessible | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |

**Checklist:**
- [ ] Feedback visible dès l'action (bouton/zone) sans bloquer toute la page
- [ ] Aucun "flicker" : loader seulement si latence dépasse seuil
- [ ] Skeletons reflètent le layout final
- [ ] Optimistic UI uniquement pour actions réversibles avec rollback/undo
- [ ] Pattern de chargement correspond au besoin de repérage

---

### 2. Empty States

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Structure standard | Illustration + titre + explication + CTA primaire (+ secondaire) | "Rien ici" sans action; Illustration qui cache le CTA | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Tonalité | First-use = encourageant; No-results = factuel + suggestions | Ton culpabilisant; Absence de piste de récupération | [Baymard No Results](https://baymard.com/blog/no-results-page) |
| Permission-gated | Expliquer pourquoi + action pour activer + alternative | Écran vide sans explication; Bloquer toute fonctionnalité | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |
| Zéro données vs zéro résultats | Distinguer "rien créé" de "recherche vide"; Recommandations adaptées | Même copie pour tous les vides | [NN/g Heuristic #9](https://media.nngroup.com/media/reports/free/Heuristic_9_help_users_recognize_diagnose_recover_from_errors.pdf) |
| Onboarding checklist | Mini-checklist (2-4 étapes) vers le "moment aha" | Tour imposé non skippable; Checklist trop longue | [Laws of UX Zeigarnik](https://lawsofux.com/zeigarnik-effect/) |

**Templates Empty State Copy:**
| Type | Titre | Body | CTA |
|------|-------|------|-----|
| First-Use | "Welcome to [App]" | "Let's set up your first project." | "Create Project" |
| No-Results | "No results found" | "We couldn't find anything matching your filters." | "Clear filters" |
| Data-Absent | "You have no [items]" | "Your [items] will appear here." | "Add [item]" |
| Error/Offline | "Something went wrong" | "Check your connection and retry." | "Retry" |

**Checklist:**
- [ ] Le vide explique la cause et propose une action primaire
- [ ] Ton adapté (first-use vs no-results vs permission vs offline)
- [ ] Actions permettent vraie récupération (reset filtres, suggestions)
- [ ] Illustration ne vole pas l'attention au CTA
- [ ] Progression vers "moment aha" (checklist courte)
- [ ] 1 CTA principal max (2 si vraiment nécessaire)

---

### 3. Error States

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Canal selon impact | Inline = erreur locale; Snackbar = statut non bloquant; Modal = bloquant/risque élevé | Modal pour validation de champ; Toast pour erreur précise | [Material Snackbars](https://material.io/components/snackbars) |
| Message d'erreur | "Quoi + pourquoi + comment corriger"; Langage neutre | Messages hostiles; Codes techniques; Pas d'action | [NN/g Hostile Error Messages](https://media.nngroup.com/media/reports/free/Hostile_Error_Messages.pdf) |
| Timing validation | Valider au bon moment (onBlur/after pause); Pas d'erreur avant que l'utilisateur ait fini | Erreur rouge dès 1er caractère; Toutes erreurs à la fin | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |
| Retry + offline | Action "Réessayer"; État offline explicite; Préserver saisie | Perdre données; Retry silencieux; Erreur réseau = erreur métier | [Apple HIG Loading](https://developer.apple.com/design/human-interface-guidelines/loading) |
| Prévention | Guider avant saisie (mask, exemple, contraintes); État attendu visible | Deviner le format; Règles masquées jusqu'à l'échec | [Smashing Magazine Forms](https://www.smashingmagazine.com/2018/08/best-practices-for-mobile-form-design/) |

**Formule message d'erreur:** "What happened" + "Why" + "How to fix"
- Exemple: "Unable to save your photo because you have no internet connection. Please check your connection and try again."

**Ton des erreurs:**
- Utiliser "We couldn't..." au lieu de "You did..." (ne pas blâmer)
- Langage neutre, empathique
- Pas d'humour ni sarcasme dans les erreurs
- Max ~80 caractères (1-2 phrases courtes)

**Checklist:**
- [ ] Canal d'erreur correspond à l'impact
- [ ] Chaque message indique quoi, pourquoi, comment corriger
- [ ] Validation inline non prématurée
- [ ] Récupération possible (retry, offline state, conservation)
- [ ] Prévention en amont (formats, exemples, contraintes)
- [ ] Ton neutre "We couldn't" (pas "You failed")
- [ ] Message ≤80 caractères

---

### 4. Success Feedback

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Toast/snackbar | Feedback transitoire quand état non évident ou undo utile | Toast pour action critique; Snackbars empilés | [Material Snackbars](https://material.io/components/snackbars) |
| Inline confirmation | Pour flux continus (formulaire, wizard) où l'utilisateur poursuit | Redirection brutale; Popup qui interrompt | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| Micro-celebration | Uniquement pour milestones rares; Respecter "reduce motion" | Confetti à chaque clic; Animations longues | [Laws of UX Peak-End](https://lawsofux.com/peak-end-rule/) |
| Ne pas confirmer | Actions évidentes et instantanées (toggle, tri) = pas de confirmation | "Réglage appliqué" à chaque toggle | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Undo vs confirm | Undo pour actions fréquentes et réversibles plutôt que confirm avant | Double confirmation pour chaque petite action | [Material Snackbars](https://material.io/components/snackbars) |

**Checklist:**
- [ ] Snackbars/toasts si état non évident ou Undo utile
- [ ] Succès inline pour flux continus
- [ ] Micro-celebrations réservées aux jalons
- [ ] Pas de confirmations pour actions évidentes
- [ ] Undo privilégié pour actions réversibles

---

### 5. Disabled States

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Désactiver vs cacher | Disabled = indisponible temporaire; Hide = jamais pertinent | Cacher élément temporairement indisponible | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |
| Expliquer déblocage | Raison + comment activer (inline helper, tooltip, texte) | Bouton grisé sans explication; Tooltip hover-only | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |
| Progressive disclosure | Remplacer disabled par étape intermédiaire quand possible | Submit grisé sans guidance | [Laws of UX Zeigarnik](https://lawsofux.com/zeigarnik-effect/) |
| Accessibilité | Contraste suffisant; État vocalisable; Pas uniquement couleur | Disabled trop pâle; Focus perdu; Info via couleur seulement | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |
| Action alternative | Proposer brouillon, contact, docs si indisponible | État bloqué sans alternative | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |

**Checklist:**
- [ ] Disabled = temporaire; Hide = non pertinent permanent
- [ ] Raison de désactivation toujours visible
- [ ] Transformer disabled en étape de setup si possible
- [ ] Contraste et accessibilité corrects
- [ ] Alternative proposée pour éviter l'impasse

---

## B. Flux utilisateur

### 6. Navigation Patterns

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Position nav principale | Web desktop: top/side selon profondeur; Sidebar persistante + regroupement | 8+ items bottom nav; Mélanger nav et actions | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |
| Hiérarchie | Nav = changer section; Actions = modifier état; Paramètres = secondaires | Actions dans nav principale; Paramètres même niveau que tâche | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Breadcrumbs (WEB) | Pour hiérarchies profondes et navigation multi-niveaux | Breadcrumbs pour nav plate (3 niveaux max); Non cliquables | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |
| Back behavior | Retour = état précédent (scroll, filtres, onglet); Préserver contexte | Back qui renvoie en haut; Réinitialise filtres | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |
| Deep linking + URLs stables | Vues importantes = partageables; Inclure état minimal (filtre clé) | États non partageables; Deep links cassés | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |

**Checklist:**
- [ ] Navigation conforme aux conventions (mobile vs desktop)
- [ ] Actions et navigation séparées
- [ ] Breadcrumbs uniquement si hiérarchie le justifie
- [ ] Back restaure scroll/filtre/onglet
- [ ] Deep links / URLs stables pour vues importantes

---

### 7. Onboarding

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Onboarding proportionné | Si UI auto-explicative = exploration libre + aides contextuelles | Tour complet obligatoire; Écrans marketing qui retardent | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Progressive (just-in-time) | Info juste avant qu'elle soit utile | 10 coach marks en cascade; Aide générique hors contexte | [Laws of UX Zeigarnik](https://lawsofux.com/zeigarnik-effect/) |
| Coach marks | Courts (1-2 phrases), actionnables, skippables | Sans sortie; Bloquent l'UI | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |
| Permission priming | Expliquer valeur avant dialogue système; Donner contrôle | Permission au launch sans contexte; Nagger plusieurs fois | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |
| Skip + reprise | Offrir "Passer"; Permettre de retrouver l'onboarding plus tard | Non skippable; Fonctionnalité masquée si non terminé | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |

**Checklist:**
- [ ] Onboarding proportionné à la complexité
- [ ] Progressif (just-in-time) plutôt que tour complet
- [ ] Coach marks courts, actionnables, skippables
- [ ] Permission priming avant prompt système
- [ ] Skip + possibilité de reprendre plus tard

---

### 8. Progressive Disclosure

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Defaults + avancé | Choix probables en premier; Avancé derrière "Options avancées" | 20 options même niveau; Options critiques trop cachées | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Accordéons | Pour sections indépendantes scannables; Info clé visible sans interaction | Champs obligatoires dans accordéon fermé; Accordéons imbriqués | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |
| "Voir plus" avec teaser | Aperçu partiel + décision d'étendre ("2 lignes + Voir plus") | "Voir plus" sans volume; Expansion qui fait perdre position | [Laws of UX Zeigarnik](https://lawsofux.com/zeigarnik-effect/) |
| Hiérarchie info | Titres explicites, résumés courts, densité adaptée (compact/comfortable) | Tout en texte continu; Densité fixe | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |
| Chunking + reconnaissance | Découper en blocs; Choix visibles > mémorisation | Forcer à mémoriser règles/valeurs sans aide | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |

**Checklist:**
- [ ] Essentiel visible, avancé regroupé
- [ ] Accordéons pour sections scannables, pas pour cacher l'obligatoire
- [ ] "Voir plus" avec aperçu et indication de volume
- [ ] Hiérarchie explicite (titres, résumés, densité)
- [ ] Chunking et reconnaissance privilégiés

---

### 9. Wizard / Multi-step

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Indicateur progression | Steps nommés si comprendre étapes important; Progress bar si seul progrès global compte | Wizard sans indication longueur; Progress bar indéterminée | [Laws of UX Zeigarnik](https://lawsofux.com/zeigarnik-effect/) |
| Auto-save + reprise | Sauvegarde entre étapes; Possibilité reprendre (brouillon) | Perte données au back/fermeture; Autosave sans feedback | [Apple HIG Loading](https://developer.apple.com/design/human-interface-guidelines/loading) |
| Back/forward sans punition | Revenir sans effacer; Conserver choix; Prévenir si invalidation | Back qui reset tout; Empêcher back sans raison | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Review step | Avant action irréversible: résumé avec liens "Modifier" par section | Revenir manuellement pour vérifier; Résumé sans édition | [Baymard Checkout Security](https://baymard.com/blog/perceived-security-of-payment-form) |
| Erreurs par étape | Au niveau du champ + résumé en haut si nécessaire; Focus première erreur | Erreurs sans lien; Erreur après navigation suivante | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |

**Checklist:**
- [ ] Progress visible (steps nommés ou bar)
- [ ] Auto-save/brouillon + reprise
- [ ] Back/forward conserve données et avertit si invalidation
- [ ] Review step avant actions irréversibles
- [ ] Erreurs localisées, priorisées, focusable

---

### 10. Search & Filter

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Autocomplete | Aider à formuler (terminologie, catégories); Rester modifiable | Suggestions non éditables; Sans hiérarchie | [Baymard Copy Suggestion](https://baymard.com/blog/copy-search-suggestion-to-search-field) |
| Tolérance fautes | Supporter fautes/variantes; Proposer corrections | Suggestions effacées sur faute; "0 résultat" sans aide | [Baymard Misspellings](https://baymard.com/blog/offer-autocomplete-suggestions-for-misspellings) |
| Filtres | Afficher accessibles (drawer, sidebar); État visible via chips; "Réinitialiser" clair | Filtres cachés sans signal; Reset efface recherche | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Tri | Default cohérent (pertinence, récence); Tri courant visible | Tri surprenant par défaut; Tri appliqué sans indication | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| No results: 5 stratégies | Suggestions catégories, requêtes alternatives, recommandations, contact, reset | Impasse avec juste "tips" génériques | [Baymard No Results](https://baymard.com/blog/no-results-page) |

**Checklist:**
- [ ] Autocomplete améliore formulation et reste éditable
- [ ] Tolérance fautes + suggestions
- [ ] Filtres: état visible (chips) + reset clair
- [ ] Tri par défaut cohérent + état visible
- [ ] No-results propose chemins concrets

---

## C. Interactions

### 11. Forms

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Labels persistants | Labels visibles pendant saisie; Placeholders = exemples (format) | Inline labels qui disparaissent; Placeholder comme seule indication | [Baymard Inline Labels](https://baymard.com/blog/mobile-forms-avoid-inline-labels) |
| Required vs optional | Convention unique cohérente; Expliquer logique ("* requis") | Mélanger * et "optionnel"; Laisser deviner | [Smashing Magazine Forms](https://www.smashingmagazine.com/2018/08/best-practices-for-mobile-form-design/) |
| Validation inline | Au bon moment (pause/onBlur); Retirer erreur quand corrigé; Validation positive discrète | Erreur rouge dès 1ère frappe; Garder erreur après correction | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |
| Auto-focus & clavier | Auto-focus si action principale claire; Tab order logique | Auto-focus sur champ secondaire; Tab order incohérent | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |
| Prévenir abandon | Minimiser champs; Autofill; Pré-remplir; Chunker formulaires longs | Infos non nécessaires; Formulaire long une page sans repères | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |

**Labels vs Placeholders vs Helper Text:**
| Élément | Rôle | Persistence | Valeur |
|---------|------|-------------|--------|
| Label | Identifier le champ | Toujours visible | Au-dessus ou à gauche du champ |
| Placeholder | Exemple/hint | Disparaît au focus | <15 caractères, jamais seul identifiant |
| Helper Text | Format, restrictions, tips | Toujours visible | En-dessous du champ, 1 phrase |

**Checklist:**
- [ ] Labels persistants, placeholders = exemples
- [ ] Convention required/optional cohérente et explicitée
- [ ] Validation inline non prématurée + disparition quand corrigé
- [ ] Auto-focus et tab order respectent l'intention
- [ ] Formulaires minimisés, pré-remplis, chunkés
- [ ] Placeholder <15 caractères, jamais comme seul label
- [ ] Helper text si format complexe (ex: "8-16 caractères")

---

### 12. Actions & Confirmations

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Actions destructives | Confirmer avant si irréversible/haut risque; Sinon Undo après | Confirmation pour micro-action; Suppression définitive sans confirm/undo | [Material Snackbars](https://material.io/components/snackbars) |
| Undo | Fenêtre de récupération courte et claire; Action évidente et accessible | Undo caché/trop bref; Undo qui n'annule pas vraiment | [Material Snackbars](https://material.io/components/snackbars) |
| Libellés boutons | Verbes spécifiques ("Supprimer", "Enregistrer"); Bouton primaire = effet final | "OK / Oui / Non" sans contexte; Ordre incohérent | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Bulk actions | Afficher count sélectionné; Permettre annuler sélection; Résumer impact | Action masse sans feedback; Pas de "deselect all" | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |
| Disabled submit | Indiquer raison précise (champs manquants); Guider correction | Submit grisé silencieux; Erreur après tentatives répétées | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |

**Ordre boutons dans dialogs:**
| Plateforme | Bouton primaire | Cancel |
|------------|-----------------|--------|
| Desktop/Android | À droite | À gauche |
| iOS (non-destructif) | À droite | À gauche |
| iOS (destructif) | À gauche | À droite |

**Règles dialogs de confirmation:**
- Uniquement pour actions irréversibles/haut risque
- Si Undo possible → snackbar avec Undo plutôt que dialog
- Titre ≤7 mots ("Delete file?")
- Body ≤80 caractères (conséquences en 1-2 phrases)
- Bouton destructif style distinct (ex: rouge)

**Checklist:**
- [ ] Confirmation si irréversible/haut risque; sinon Undo
- [ ] Undo visible, fiable, fenêtre claire
- [ ] Boutons libellés avec verbes spécifiques
- [ ] Bulk actions: count + annuler sélection + impact clair
- [ ] Disabled submit explique quoi corriger
- [ ] Ordre boutons: primaire à droite (sauf iOS destructif)
- [ ] Dialog: titre ≤7 mots, body ≤80 chars

---

### 13. Selections

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Single vs multi | Radio = choix exclusif; Checkbox = multi; Patterns visuels distincts | Checkbox pour choix unique; Mélanger sans logique | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Select all / deselect all | Offrir quand liste dépasse quelques éléments | Sélection item par item; "select all" ambigu | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |
| Range selection (WEB) | Support shift+click pour sélectionner plage | Uniquement checkboxes; Sélection plage qui surprend | [Laws of UX Fitts's](https://lawsofux.com/fittss-law/) |
| Persistance sélection | Préserver sélection lors navigation ou expliquer portée; Compteur persisté | Perte silencieuse sélection; Action masse sans clarifier périmètre | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |
| Indicateur sélection | Toujours montrer count + offrir "Annuler sélection" | Sélection active sans indication | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |

**Checklist:**
- [ ] Contrôles adaptés (radio vs checkbox)
- [ ] Select all/deselect all + portée claire
- [ ] Range selection sur web (shift+click) pour tableaux
- [ ] Sélection persistée ou portée explicitée
- [ ] Count visible + action "annuler sélection"

---

### 14. Drag & Drop

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Affordance | Poignées, icônes, curseur, instruction contextuelle | Élément draggable sans indice | [Laws of UX Fitts's](https://lawsofux.com/fittss-law/) |
| Feedback pendant drag | Aperçu objet + zones drop valides + interdits indiqués | Aucun feedback; Drop accepté puis erreur | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |
| Annulation | Permettre Esc, undo; Actions destructives = confirmation/undo | Drop destructif immédiat sans récupération | [Material Snackbars](https://material.io/components/snackbars) |
| Alternative accessible | Toujours offrir alternative au drag (boutons ↑↓, menu) | Interaction impossible au clavier/lecteur d'écran | [Apple HIG Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) |

**Checklist:**
- [ ] Draggable évident (handle/cursor/instructions)
- [ ] Preview + zones valides visibles pendant drag
- [ ] Annulation/undo disponible; actions destructives protégées
- [ ] Alternative clavier/accessibilité (↑/↓, menu)

---

## D. Information

### 16. Data Display

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Table vs cards vs list | Tables = comparaison multi-attributs; Cards = exploration visuelle; Lists = scan rapide | Cards pour data dense; Table mobile sans adaptation | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |
| Pagination/infinite/load more | Pagination = repérage précis; Infinite = exploration; Load more = contrôle sans pagination | Infinite sans sauvegarde position; Pagination cachée | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| Tri/filtre visibles | Afficher état tri et filtres actifs; Retirer facilement | Tri appliqué sans indication; Filtres invisibles | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |
| Densité (WEB) | Offrir compact/confortable selon contexte; Mémoriser choix | Densité unique qui force scroll ou rend lecture difficile | [Android Layout Patterns](https://developer.android.com/design/ui/mobile/guides/layout-and-content/layout-and-nav-patterns) |
| Tables responsives (WEB) | Mobile: table→cards, colonnes prioritaires, scroll horizontal + headers sticky | Table non lisible mobile; Colonnes coupées; Tri impossible | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |

**Checklist:**
- [ ] Structure selon tâche (comparaison vs exploration vs scan)
- [ ] Pattern chargement adapté + restauration
- [ ] Tri/filtre actifs visibles et manipulables
- [ ] Densité ajustable, préférence mémorisée
- [ ] Tables mobiles adaptées (reflow/priority/scroll)

---

### 17. Notifications

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Typologie | Transactionnel = prioritaire; Marketing = opt-in; Système = sécurité/compte | Mélanger promo et sécurité; Push pour tout | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |
| Canal | In-app = feedback contextuel; Push = urgence; Email = récap/trace | Push pour confirmations non urgentes; Email pour micro-feedback | [NN/g Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| Fréquence | Regrouper non urgentes (batch); Offrir digests | Notifier chaque micro-événement | [Laws of UX Peak-End](https://lawsofux.com/peak-end-rule/) |
| Centre notifications | Historique + actions rapides (marquer lu, paramètres) | Notifications éphémères sans trace; Pas de gestion | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |
| DND + préférences | Couper temporairement; Choisir types, canaux, horaires | Toggle global unique; Nagger après opt-out | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |

**Checklist:**
- [ ] Types de notifications distingués
- [ ] Canal selon urgence et contexte
- [ ] Batching/digest pour éviter spam
- [ ] Historique accessible + actions de gestion
- [ ] DND + préférences granulaires, pas de nagging

---

### 18. Help & Support

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Aide contextuelle | Près de la décision; Explications courtes et actionnables | Aide dans FAQ difficile à trouver; Tooltips trop longs | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Help center | Searchable, structuré par tâches, articles courts | Articles trop longs, jargon, pas de recherche | [Baymard Copy Suggestion](https://baymard.com/blog/copy-search-suggestion-to-search-field) |
| Hiérarchie contact | Self-serve → chat/assistant → humain | Cacher contact; Chat bloque support humain | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |
| Chatbot | Annoncer ce qu'il sait faire; Peu de questions; Escalade humaine | Chatbot qui boucle; Pas d'escalade | [NN/g Hostile Error Messages](https://media.nngroup.com/media/reports/free/Hostile_Error_Messages.pdf) |
| Aide proactive | Sur signaux forts (erreurs répétées, abandon); Non intrusif | Popups agressifs sans signal; Interruption du flux | [Laws of UX Peak-End](https://lawsofux.com/peak-end-rule/) |

**Checklist:**
- [ ] Aide proche du contexte (tooltip/microcopy)
- [ ] Help center searchable, articles orientés tâches
- [ ] Hiérarchie contact claire + accès support humain
- [ ] Chatbot transparent + escalade quand bloqué
- [ ] Aide proactive sur signaux, non intrusive

---

## E. Confiance & Sécurité

### 19. Trust Patterns

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Social proof | Spécifique au contexte (produit, région); Vérifiable | Témoignages vagues; Chiffres énormes sans source | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Perceived security (WEB) | Encadrer champs paiement; Microcopy rassurante; Badges proches | Badges sécurité en footer; Champs sensibles identiques au reste | [Baymard Security Perception](https://baymard.com/blog/perceived-security-of-payment-form) |
| Transparence prix | Prix total tôt; Préciser frais et conditions; Éviter surprises | Frais cachés jusqu'au dernier écran; Conditions difficiles | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Company info (WEB) | Identité, contact, infos légales faciles à trouver | Site sans contact clair; Infos cachées | [NN/g Company Info](https://media.nngroup.com/media/reports/free/Presenting_Company_Information_on_Corporate_Websites_3rd_Edition.pdf) |
| Garanties/politiques | Mettre en avant au moment où l'utilisateur hésite (checkout, pricing) | Politiques dans PDF caché; Garanties trompeuses | [Laws of UX Peak-End](https://lawsofux.com/peak-end-rule/) |

**Checklist:**
- [ ] Social proof spécifique, vérifiable et contextualisé
- [ ] Champs sensibles visuellement renforcés
- [ ] Prix total et frais visibles avant engagement
- [ ] Company info et contact faciles à trouver
- [ ] Garanties/retours explicités au moment clé

---

### 20. Privacy & Consent

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Consentement | Choix équilibrés (accepter/refuser); Compréhensibles | Cookie wall; Refus caché; Consentement pré-coché | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Timing (permission priming) | Demander quand valeur claire, pas au lancement systématique | Prompt au démarrage sans contexte | [NN/g Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) |
| Transparence données | Langage simple: quoi collecté, pourquoi, comment supprimer/exporter | Texte légal opaque; Absence de contrôle utilisateur | [NN/g Company Info](https://media.nngroup.com/media/reports/free/Presenting_Company_Information_on_Corporate_Websites_3rd_Edition.pdf) |
| Granularité réglages | Activer/désactiver par catégorie; Revenir sur décision | Toggle global unique; Impossible retirer consentement | [Apple UI Design Tips](https://developer.apple.com/design/tips/) |
| Anti-dark patterns | Éviter couleurs asymétriques, wording trompeur, friction au refus | "Refuser" en gris pâle; Message culpabilisant; Multiples écrans | [Laws of UX Hick's](https://lawsofux.com/hicks-law/) |

**Checklist:**
- [ ] Choix symétriques (accepter/refuser) + personnalisation
- [ ] Demande au moment de valeur
- [ ] Transparence: quoi/pourquoi/combien de temps + suppression/export
- [ ] Réglages granulaires, réversibles, facilement accessibles
- [ ] Aucun dark pattern (couleur, wording, friction, shaming)

---

## Sources

- [Nielsen Norman Group - Response Times](https://www.nngroup.com/articles/response-times-3-important-limits/)
- [Nielsen Norman Group - Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/)
- [Nielsen Norman Group - Heuristic #9](https://media.nngroup.com/media/reports/free/Heuristic_9_help_users_recognize_diagnose_recover_from_errors.pdf)
- [Baymard Institute - Various Articles](https://baymard.com/)
- [Laws of UX](https://lawsofux.com/)
- [Material Design](https://material.io/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Smashing Magazine](https://www.smashingmagazine.com/)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [WAI-ARIA APG](https://www.w3.org/WAI/ARIA/apg/patterns/)

---

*Consolidé depuis: UX_Behavioral_Patterns_2024-2025_Checklist_FULL_v3.pdf (PDF 1/6)*

---

## F. Accessibilité WCAG 2.2 (Niveau AA)

> Source: `universal_ui_rulebook_v1_audit_matrice_v3.pdf` (PDF 2/6)

### 21. Touch Targets (WCAG 2.5.8)

| Pattern | Règle d'or | Valeur | Exceptions | Source |
|---------|------------|--------|------------|--------|
| Taille minimale cibles | Cibles interactives ≥ 24×24 CSS px | 24px | Spacing, Equivalent, Inline, User agent, Essential | [WCAG 2.5.8](https://www.w3.org/TR/WCAG22/#target-size-minimum) |
| Taille recommandée | 44×44 px pour une meilleure accessibilité tactile | 44px | - | Best practice |
| Exception Spacing | Si cercle 24px autour de la target ne chevauche pas d'autre cible | - | Valide si espacement suffisant | [Understanding 2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html) |
| Exception Inline | Liens dans du texte (paragraphes) | - | Acceptable pour liens en ligne | [Understanding 2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html) |

**Checklist:**
- [ ] Toutes les cibles interactives font au moins 24×24 CSS px
- [ ] Les boutons principaux font au moins 44×44 px
- [ ] Si target < 24px, vérifier qu'une exception WCAG s'applique
- [ ] Tester l'espacement entre cibles adjacentes

---

### 22. Contraste (WCAG 1.4.3, 1.4.11)

| Pattern | Règle d'or | Valeur | Test | Source |
|---------|------------|--------|------|--------|
| Texte normal | Contraste texte/fond ≥ 4.5:1 | 4.5:1 | Mesurer luminance relative | [WCAG 1.4.3](https://www.w3.org/TR/WCAG22/#contrast-minimum) |
| Texte large | Contraste ≥ 3:1 pour texte ≥ 18pt (ou 14pt bold) | 3:1 | Classifier par taille puis vérifier | [WCAG 1.4.3](https://www.w3.org/TR/WCAG22/#contrast-minimum) |
| Définition "large text" | ≥ 18pt OU ≥ 14pt en gras | 18pt / 14pt bold | Auditer styles typographiques | [Understanding 1.4.3](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) |
| Composants UI non-texte | Contraste ≥ 3:1 pour bordures, icônes, états | 3:1 | Tous états: default/hover/active/disabled/focus | [WCAG 1.4.11](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html) |
| Couleur pas seul indicateur | Ne jamais utiliser uniquement la couleur pour transmettre une info | - | Simuler daltonisme/grayscale | [WCAG 1.4.1](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html) |

**Checklist:**
- [ ] Contraste texte normal ≥ 4.5:1 vérifié
- [ ] Contraste texte large ≥ 3:1 vérifié
- [ ] Contraste composants UI (bordures, icônes) ≥ 3:1
- [ ] Information transmise par autre moyen que la couleur seule

---

### 23. Focus Clavier (WCAG 2.4.7, 2.4.11, 2.4.13)

| Pattern | Règle d'or | Implémentation | Test | Source |
|---------|------------|----------------|------|--------|
| Focus visible (2.4.7) | Indicateur de focus toujours visible | `outline: 2px solid` | Tab/Shift+Tab sur tout le site | [WCAG 2.4.7](https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html) |
| Focus pas masqué (2.4.11) | Élément focusé jamais entièrement caché | Attention sticky headers, overlays | Tester overlays, cookie banners | [WCAG 2.4.11](https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum.html) |
| Focus appearance (2.4.13) | Aire minimale = périmètre 2px; Contraste ≥ 3:1 | `outline: 2px solid; outline-offset: 2px` | Vérifier sur thèmes clair/sombre | [WCAG 2.4.13](https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html) |
| Outline offset | Décalage pour visibilité | `outline-offset: 2px` | Ne pas masquer le contenu | Best practice |

**CSS recommandé:**
```css
:focus-visible {
  outline: 2px solid var(--focus-color);
  outline-offset: 2px;
  box-shadow: 0 0 0 4px rgba(var(--focus-rgb), 0.3);
}
```

**Checklist:**
- [ ] Indicateur de focus visible sur TOUS les éléments interactifs
- [ ] Focus jamais masqué par sticky headers ou overlays
- [ ] Contraste indicateur de focus ≥ 3:1 vs couleurs adjacentes
- [ ] Test navigation Tab/Shift+Tab complet

---

### 24. Navigation Clavier (WCAG 2.1.1, 2.1.2, 2.1.4)

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Tout au clavier (2.1.1) | Toute fonctionnalité accessible sans souris | Actions uniquement au survol | [WCAG 2.1.1](https://www.w3.org/WAI/WCAG22/Understanding/keyboard) |
| Pas de piège clavier (2.1.2) | Utilisateur peut sortir de tout composant | Focus piégé dans modale sans Esc | [WCAG 2.1.2](https://www.w3.org/WAI/WCAG22/Understanding/no-keyboard-trap) |
| Raccourcis caractère seul (2.1.4) | Si raccourcis single-key: permettre désactiver/remapper | "a" déclenche action globale | [WCAG 2.1.4](https://www.w3.org/WAI/WCAG22/Understanding/character-key-shortcuts) |
| Ordre de focus (2.4.3) | Focus suit l'ordre logique de lecture | Tab saute aléatoirement | [WCAG 2.4.3](https://www.w3.org/WAI/WCAG22/Understanding/focus-order.html) |

**Checklist:**
- [ ] Parcours complet sans souris possible
- [ ] Sortie de modales/menus/widgets au clavier (Tab, Shift+Tab, Esc)
- [ ] Raccourcis single-key désactivables ou scope limité
- [ ] Ordre de focus = ordre de lecture logique

---

### 25. Pointeur & Gestes (WCAG 2.5.1, 2.5.2, 2.5.7)

| Pattern | Règle d'or | Alternative requise | Source |
|---------|------------|---------------------|--------|
| Gestes multipoints (2.5.1) | Alternative mono-pointeur pour pinch/rotate | Boutons +/- pour zoom | [WCAG 2.5.1](https://www.w3.org/WAI/WCAG22/Understanding/pointer-gestures.html) |
| Annulation pointeur (2.5.2) | Pas d'action irréversible au down-event | Action au click/up, possibilité d'annuler | [WCAG 2.5.2](https://www.w3.org/WAI/WCAG22/Understanding/pointer-cancellation) |
| Alternative au drag (2.5.7) | Toute action drag a alternative sans drag | Boutons ↑↓, champs numériques | [WCAG 2.5.7](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html) |
| Motion actuation (2.5.4) | Si shake/tilt déclenche action: alternative UI + toggle | Bouton "annuler" en plus de shake | [WCAG 2.5.4](https://www.w3.org/WAI/WCAG22/Understanding/motion-actuation) |

**Checklist:**
- [ ] Gestes multipoints ont une alternative simple (tap, boutons)
- [ ] Actions déclenchées au up-event, pas au down-event
- [ ] Drag & drop a une alternative clavier (boutons ↑↓)
- [ ] Motion gestures désactivables

---

### 26. Texte & Reflow (WCAG 1.4.4, 1.4.10, 1.4.12)

| Pattern | Règle d'or | Valeur | Test | Source |
|---------|------------|--------|------|--------|
| Resize text (1.4.4) | Texte redimensionnable jusqu'à 200% sans perte | 200% | Zoom navigateur 200% | [WCAG 1.4.4](https://www.w3.org/WAI/WCAG21/Understanding/resize-text.html) |
| Reflow (1.4.10) | Pas de scroll 2D à 320px (vertical) ou 256px (horizontal) | 320 CSS px / 256 CSS px | Viewport 320px + zoom 400% | [WCAG 1.4.10](https://www.w3.org/WAI/WCAG22/Understanding/reflow) |
| Text spacing override (1.4.12) | Aucune perte si user force les espacements | line-height 1.5×, paragraph 2×, letter 0.12×, word 0.16× | Appliquer stylesheet override | [WCAG 1.4.12](https://www.w3.org/WAI/WCAG22/Understanding/text-spacing.html) |
| Orientation (1.3.4) | Ne pas verrouiller portrait/paysage | - | Tester rotation | [WCAG 1.3.4](https://www.w3.org/WAI/WCAG22/Understanding/orientation.html) |

**Checklist:**
- [ ] Zoom 200% = pas de chevauchement, pas de contenu coupé
- [ ] À 320px viewport = pas de scroll horizontal
- [ ] Override spacing = pas de texte tronqué
- [ ] App fonctionne en portrait ET paysage

---

### 27. Mouvement & Animation (WCAG 2.2.2, 2.3.1)

| Pattern | Règle d'or | Valeur | Test | Source |
|---------|------------|--------|------|--------|
| Pause/Stop/Hide (2.2.2) | Si mouvement > 5s: contrôle utilisateur | 5 secondes | Inventorier animations, vérifier pause | [WCAG 2.2.2](https://www.w3.org/WAI/WCAG21/Understanding/pause-stop-hide.html) |
| Pas de flash (2.3.1) | Max 3 flashes par seconde | 3 flashes/sec | Analyser animations/vidéos | [WCAG 2.3.1](https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html) |
| Reduced motion (préf.) | Respecter `prefers-reduced-motion: reduce` | - | Activer dans OS, vérifier réduction | [MDN prefers-reduced-motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion) |

**CSS recommandé:**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Checklist:**
- [ ] Animations > 5s ont bouton pause/stop
- [ ] Aucun élément ne flashe > 3 fois/seconde
- [ ] `prefers-reduced-motion` respecté

---

### 28. Changements de Contexte (WCAG 3.2.1-3.2.4)

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| On Focus (3.2.1) | Pas de changement de contexte au focus | Navigation auto au focus | [WCAG 3.2.1](https://www.w3.org/WAI/WCAG22/Understanding/on-focus) |
| On Input (3.2.2) | Pas de changement de contexte sur input sans prévenir | Select qui redirige sans avertissement | [WCAG 3.2.2](https://www.w3.org/WAI/WCAG22/Understanding/on-input.html) |
| Navigation cohérente (3.2.3) | Même ordre relatif sur toutes les pages | Menu qui change d'ordre | [WCAG 3.2.3](https://www.w3.org/WAI/WCAG22/Understanding/consistent-navigation.html) |
| Identification cohérente (3.2.4) | Mêmes fonctions = mêmes labels | Bouton "Envoyer" puis "Soumettre" | [WCAG 3.2.4](https://www.w3.org/WAI/WCAG22/Understanding/consistent-identification) |

**Checklist:**
- [ ] Tab ne déclenche pas de navigation automatique
- [ ] Select/radio ne redirigent pas sans bouton explicite
- [ ] Navigation identique sur toutes les pages
- [ ] Labels cohérents pour fonctions identiques

---

### 29. Structure de Page (WCAG 2.4.1, 2.4.2, 2.4.4, 2.4.6)

| Pattern | Règle d'or | Implémentation | Source |
|---------|------------|----------------|--------|
| Bypass blocks (2.4.1) | Skip link "Aller au contenu" | Premier élément focusable | [WCAG 2.4.1](https://www.w3.org/WAI/WCAG21/Understanding/bypass-blocks.html) |
| Page titled (2.4.2) | Chaque page a un titre descriptif unique | `<title>Page - Site</title>` | [WCAG 2.4.2](https://www.w3.org/WAI/WCAG22/Understanding/page-titled.html) |
| Link purpose (2.4.4) | But du lien compréhensible hors contexte | Éviter "cliquez ici" | [WCAG 2.4.4](https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html) |
| Headings descriptifs (2.4.6) | Headings et labels décrivent le contenu | Titres uniques et précis | [WCAG 2.4.6](https://www.w3.org/WAI/WCAG22/Understanding/headings-and-labels.html) |
| Label in name (2.5.3) | Accessible name contient le texte visible | `aria-label` inclut le texte du bouton | [WCAG 2.5.3](https://www.w3.org/WAI/WCAG22/Understanding/label-in-name.html) |

**Checklist:**
- [ ] Skip link présent et fonctionnel
- [ ] `<title>` unique et descriptif sur chaque page
- [ ] Liens explicites (pas "cliquez ici")
- [ ] Headings hiérarchiques (h1 > h2 > h3)
- [ ] `aria-label` contient le texte visible

---

### 30. Formulaires Accessibles (WCAG 1.3.5, 3.3.x)

| Pattern | Règle d'or | Implémentation | Source |
|---------|------------|----------------|--------|
| Input purpose (1.3.5) | Identifier la finalité des champs standards | `autocomplete="email"` | [WCAG 1.3.5](https://www.w3.org/WAI/WCAG22/Understanding/identify-input-purpose.html) |
| Error identification (3.3.1) | Identifier champ en erreur + description texte | Message près du champ, pas couleur seule | [WCAG 3.3.1](https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html) |
| Error suggestion (3.3.3) | Proposer correction si connue | "Format attendu: JJ/MM/AAAA" | [WCAG 3.3.3](https://www.w3.org/WAI/WCAG21/Understanding/error-suggestion.html) |
| Error prevention (3.3.4) | Transactions: review/confirm/undo avant commit | Récapitulatif avant paiement | [WCAG 3.3.4](https://www.w3.org/WAI/WCAG21/Understanding/error-prevention-legal-financial-data.html) |
| Auth accessible (3.3.8) | Pas de test cognitif obligatoire pour login | Alternative à puzzle/CAPTCHA | [WCAG 3.3.8](https://www.w3.org/WAI/WCAG22/Understanding/accessible-authentication-minimum.html) |

**Attributs autocomplete recommandés:**
```html
<input type="text" autocomplete="name">
<input type="email" autocomplete="email">
<input type="tel" autocomplete="tel">
<input type="text" autocomplete="street-address">
```

**Checklist:**
- [ ] Champs standards ont `autocomplete` approprié
- [ ] Erreurs identifiées par texte (pas couleur seule)
- [ ] Suggestions de correction fournies
- [ ] Transactions réversibles ou avec confirmation
- [ ] Pas de CAPTCHA bloquant sans alternative

---

### 31. ARIA & Sémantique (WCAG 4.1.2, 4.1.3)

| Pattern | Règle d'or | Test | Source |
|---------|------------|------|--------|
| Name/Role/Value (4.1.2) | Composants custom exposent name/role/state/value | Tests NVDA/VoiceOver/JAWS | [WCAG 4.1.2](https://www.w3.org/WAI/WCAG21/Understanding/name-role-value.html) |
| Status messages (4.1.3) | Messages de statut annoncés sans prendre le focus | `role="status"` ou `aria-live="polite"` | [WCAG 4.1.3](https://www.w3.org/WAI/WCAG22/Understanding/status-messages) |

**Implémentation:**
```html
<!-- Status message (toast) -->
<div role="status" aria-live="polite">
  Sauvegarde réussie
</div>

<!-- Alert message (urgent) -->
<div role="alert">
  Erreur de connexion
</div>
```

**Checklist:**
- [ ] Composants custom ont les attributs ARIA corrects
- [ ] Toasts/notifications ont `role="status"` ou `aria-live`
- [ ] Alertes urgentes ont `role="alert"`
- [ ] Tests avec lecteur d'écran effectués

---

## Récapitulatif WCAG 2.2 - Hard Rules (MUST)

| SC | Titre | Valeur clé | Priorité |
|----|-------|------------|----------|
| 2.5.8 | Target Size (Minimum) | ≥ 24×24 CSS px | MUST |
| 1.4.3 | Contrast (Minimum) | 4.5:1 normal, 3:1 large | MUST |
| 1.4.11 | Non-text Contrast | ≥ 3:1 | MUST |
| 1.4.1 | Use of Color | Pas couleur seule | MUST |
| 2.4.7 | Focus Visible | Toujours visible | MUST |
| 2.4.11 | Focus Not Obscured | Jamais masqué | MUST |
| 2.4.13 | Focus Appearance | Aire 2px + contraste 3:1 | MUST |
| 2.1.1 | Keyboard | Tout accessible | MUST |
| 2.1.2 | No Keyboard Trap | Sortie possible | MUST |
| 2.5.1 | Pointer Gestures | Alternative simple | MUST |
| 2.5.2 | Pointer Cancellation | Action au up-event | MUST |
| 2.5.7 | Dragging Movements | Alternative sans drag | MUST |
| 1.4.4 | Resize Text | Jusqu'à 200% | MUST |
| 1.4.10 | Reflow | 320px sans scroll 2D | MUST |
| 1.4.12 | Text Spacing | Override sans perte | MUST |
| 3.2.1 | On Focus | Pas de changement contexte | MUST |
| 3.2.2 | On Input | Prévisible | MUST |
| 3.3.1 | Error Identification | Champ + texte | MUST |
| 3.3.2 | Labels or Instructions | Sur tous inputs | MUST |
| 4.1.2 | Name, Role, Value | Exposés aux AT | MUST |
| 4.1.3 | Status Messages | Annoncés sans focus | MUST |

---

*Ajouté depuis: universal_ui_rulebook_v1_audit_matrice_v3.pdf (PDF 2/6)*

---

## G. Système de Couleurs HSB

> Source: `Color Cheatsheet.pdf` (PDF 3/6)

### 32. Travailler en HSB

Le système **Hue-Saturation-Brightness** est plus intuitif que RGB pour créer des variations de couleurs.

| Composante | Description | Valeurs extrêmes |
|------------|-------------|------------------|
| **Hue** (Teinte) | La couleur elle-même | 0°-360° (cercle chromatique) |
| **Saturation** | Richesse de la couleur | 0% = gris plat, 100% = couleur riche |
| **Brightness** | Intensité lumineuse | 0% = noir, 100% = couleur vive ou blanc |

---

### 33. Créer des Variations de Couleurs

La compétence clé en UI design est de créer des **variations cohérentes** d'une couleur de base.

#### Variations Plus Claires (Lighter)

| Action | Direction |
|--------|-----------|
| Brightness | ↑ Augmenter |
| Saturation | ↓ Diminuer |
| Hue | Vers **cyan**, **magenta** ou **jaune** (le plus proche) |

**Usages:**
- Background pour contrôles surélevés (raised)
- États disabled
- Hover sur fond sombre

#### Variations Plus Sombres (Darker)

| Action | Direction |
|--------|-----------|
| Brightness | ↓ Diminuer |
| Saturation | ↑ Augmenter |
| Hue | Vers **rouge**, **vert** ou **bleu** (le plus proche) |

**Usages:**
- Background pour contrôles en retrait (inset)
- États hovered/pressed
- Dark mode backgrounds

---

### 34. Échelle de Variations pour Boutons

| État | Variation | Transformation CSS approximative |
|------|-----------|----------------------------------|
| **Disabled** | Lighter | `filter: brightness(1.1) saturate(0.7)` |
| **Normal** | Base | Couleur de base |
| **Hovered** | Darker | `filter: brightness(1.1) saturate(1.3)` |
| **Pressed/Active** | Darker encore | `filter: brightness(0.95) saturate(1.4)` |

---

### 35. Décalage de Teinte (Hue Shift)

Les différentes teintes ont des **luminosités perçues différentes**, ce qui les rend naturellement adaptées comme variations plus claires ou plus sombres.

| Direction | Shift vers | Perception |
|-----------|------------|------------|
| Lighter | Cyan, Magenta, Jaune | Plus lumineux naturellement |
| Darker | Rouge, Vert, Bleu | Plus sombres naturellement |

**Exemple pratique:**
- Couleur de base: Bleu `hsl(220, 80%, 50%)`
- Variation claire: Shift vers Cyan `hsl(200, 60%, 70%)`
- Variation sombre: Rester Bleu, baisser brightness `hsl(220, 90%, 35%)`

---

*Ajouté depuis: Color Cheatsheet.pdf (PDF 3/6)*

---

## H. Système d'Espacement & Métriques Web

> Source: `1. SYSTÈME D'ESPACEMENT (Spacing).pdf` (PDF 4/6)

### 36. Échelle de Spacing (Base 4px)

Toutes les plateformes utilisent une grille de **4 unités** (4px, 4dp, 4pt) comme incrément de base.

| Token | Valeur | Usage typique |
|-------|--------|---------------|
| `--sp-1` | 4px | Micro-espacement, icône-texte |
| `--sp-2` | 8px | Gap entre éléments liés |
| `--sp-3` | 12px | Padding compact |
| `--sp-4` | 16px | Padding standard, gap listes |
| `--sp-5` | 20px | Padding confortable |
| `--sp-6` | 24px | Séparation groupes |
| `--sp-8` | 32px | Marge tablette |
| `--sp-10` | 40px | Espace section |
| `--sp-12` | 48px | Espace section majeure |
| `--sp-16` | 64px | Séparation sections desktop |
| `--sp-20` | 80px | Marge desktop |
| `--sp-24` | 96px | Séparation page |

---

### 37. Marges de Page Responsives

| Breakpoint | Marge latérale | Max-width contenu |
|------------|----------------|-------------------|
| Mobile (< 480px) | 12-16px | 100% |
| Tablette (768px) | 32px | 100% |
| Desktop (1024px+) | 80px | ~1120px |

**CSS:**
```css
.container {
  max-width: 1120px;
  margin-inline: auto;
  padding-inline: clamp(1rem, 5vw, 5rem);
}
```

---

### 38. Échelle Typographique Web (Tailwind)

| Classe | Taille | Line-height | Usage |
|--------|--------|-------------|-------|
| `text-xs` | 12px | 1rem | Captions, labels |
| `text-sm` | 14px | 1.25rem | Texte secondaire |
| `text-base` | 16px | 1.5rem | Corps de texte |
| `text-lg` | 18px | 1.75rem | Lead paragraphs |
| `text-xl` | 20px | 1.75rem | Titre section |
| `text-2xl` | 24px | 2rem | Titre H3 |
| `text-3xl` | 30px | 2.25rem | Titre H2 |
| `text-4xl` | 36px | 2.5rem | Titre H1 |
| `text-5xl` | 48px | 1 | Hero title |
| `text-6xl` | 60px | 1 | Display |
| `text-7xl` | 72px | 1 | Display large |

**Poids recommandés:**
- Regular (400): Corps de texte
- Medium (500): Labels, emphasis
- Semibold (600): Sous-titres
- Bold (700): Titres, CTA

---

### 39. Dimensions Composants Web

#### Boutons

| Propriété | Valeur | Notes |
|-----------|--------|-------|
| Hauteur min | 32-40px | 40px pour style Material |
| Largeur min | 64px | - |
| Padding | 8px 16px | Vertical / Horizontal |
| Border-radius | 4-8px | 4px Material, 8px moderne |
| Touch target | 48×48px | Zone cliquable minimale |

#### Champs de saisie

| Propriété | Valeur |
|-----------|--------|
| Hauteur | ~40px |
| Bordure | 1px #ccc |
| Padding interne | 8px |
| Border-radius | 4px |

#### Cards

| Propriété | Valeur |
|-----------|--------|
| Padding interne | 16px |
| Border-radius | 8px |
| Box-shadow | `0 1px 3px rgba(0,0,0,0.1)` |

#### Navigation

| Élément | Dimension |
|---------|-----------|
| Header mobile | 56px |
| Header desktop | 64px |
| Tabs height | 48px |
| Sidebar width | 240px |
| Nav links | min 48×48px |

#### Modals

| Propriété | Valeur |
|-----------|--------|
| Taille min | 300×200px |
| Taille max | 90% écran |
| Padding | 24px |
| Border-radius | 8px |
| Backdrop | `rgba(0,0,0,0.5)` |

#### Chips/Tags

| Propriété | Valeur |
|-----------|--------|
| Hauteur | 24px |
| Padding | 12px horizontal |
| Border-radius | 12px (ou fully round) |

#### Toggles/Switches

| Propriété | Valeur |
|-----------|--------|
| Touch target | 44px |
| Switch size | ~50×30px |
| Toggle circle | ~24px |
| Checkbox | ~20px |

---

### 40. Grille Responsive 12 Colonnes

| Breakpoint | Largeur | Colonnes | Gutter |
|------------|---------|----------|--------|
| sm | 480px | 4 | 16px |
| md | 768px | 6 | 16px |
| lg | 1024px | 12 | 24px |
| xl | 1280px | 12 | 24px |
| 2xl | 1536px | 12 | 24px |

**Safe areas (mobile):**
```css
padding-top: env(safe-area-inset-top);
padding-bottom: env(safe-area-inset-bottom);
```

---

### 41. Motion & Animation Web

| Type | Durée | Usage |
|------|-------|-------|
| Rapide | 100-150ms | Hover, micro-interactions |
| Moyen | 200-300ms | Transitions d'état, navigation |
| Long | >400ms | Entrée/sortie page |

**Easing recommandé:**
```css
/* Material standard easing */
transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

/* Decelerate (entrée) */
transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

/* Accelerate (sortie) */
transition-timing-function: cubic-bezier(0.4, 0, 1, 1);
```

---

### 42. Iconographie Web

| Propriété | Valeur recommandée |
|-----------|-------------------|
| Taille inline | 24px ou 32px |
| Taille petite | 16px |
| Stroke width | 2px (ou 0.125em) |
| Touch target | 44px (zone cliquable) |

**Styles:**
- Outline: pour actions secondaires
- Filled: pour actions principales
- Adaptatif: même icône en outline/filled selon l'état

---

*Ajouté depuis: 1. SYSTÈME D'ESPACEMENT (Spacing).pdf (PDF 4/6)*

---

## I. Checklist "Mario" - Tutoriel Invisible

> Source: `Codes avant-gardistes du design UI_UX encore standards en 2026-1.pdf` (PDF 5/6)

### 43. Principe du Tutoriel Invisible

Un bon design "enseigne" par les contraintes, le feedback et la progression, pas par un mode d'emploi. Comme World 1-1 de Super Mario Bros : chaque mécanique est introduite progressivement par le design lui-même.

---

### 44. Checklist Mario (10 Points Mesurables)

| # | Critère | Métrique | Seuil |
|---|---------|----------|-------|
| 1 | **Succès initial rapide** | Temps médian à la première action réussie | < 1 minute sans lire doc |
| 2 | **Une action dominante** | Ratio proéminence CTA principal / secondaires | CTA principal clairement distinct |
| 3 | **Affordance explicite** | Audit visuel éléments interactifs | Boutons ressemblent à boutons |
| 4 | **Feedback immédiat** | Latence retour après action | < 100-200ms perception |
| 5 | **Récupération d'erreurs** | Présence undo/back/état | Undo ou Back disponible |
| 6 | **Progression graduelle** | Complexité révélée progressivement | Progressive disclosure |
| 7 | **Navigation sans pièges** | Back button fiable, swipe-back OS | Back ne casse jamais |
| 8 | **Lisibilité tactile** | Audit tailles cibles | 44pt iOS / 48dp Android / 24px web |
| 9 | **Accessibilité structurelle** | Focus overlays, ARIA corrects | dialog/combobox/accordion OK |
| 10 | **Attente "utilisable"** | UI pendant chargement | Skeleton, pas spinner infini |

---

### 45. Anti-patterns à Éviter

| Anti-pattern | Pourquoi c'est mal | Alternative |
|--------------|-------------------|-------------|
| 3+ CTA équivalents | Paralysie du choix | 1 CTA dominant |
| Gestes cachés sans indices | Découvrabilité nulle | Hint visuel ou onboarding |
| Spinner infini | Perception lente | Skeleton screens |
| Back cassé | Anxiété utilisateur | Back = retour exact |
| Tout montrer d'emblée | Charge cognitive | Progressive disclosure |
| Navigation cachée sans nécessité | -20% à -50% découvrabilité | Nav visible si place |

---

### 46. Application par Type de Produit

#### E-commerce
- Recherche + filtres visibles
- "Load more" plutôt qu'infinite scroll (comparaison)
- Retour fiable au bon endroit dans la liste

#### App utilitaire (to-do, notes, suivi)
- Action principale claire (FAB ou CTA)
- Feedback non intrusif (snackbar)
- Récupération d'erreur (Undo)

#### App créative (montage, dessin, musique)
- Gestes puissants MAIS alternative visible
- Ne pas introduire 10 gestes cachés sans indices
- Contrôles standards + évidence immédiate

---

### 47. Microcopy Minimale (Quand Nécessaire)

| Situation | Pattern | Exemple |
|-----------|---------|---------|
| Geste nouveau | Hint initial, disparaît après adoption | "Tirez pour actualiser" |
| Action destructrice | Alert dialog, focus sur Annuler | "Supprimer ? [Annuler] [Supprimer]" |
| Action réversible | Snackbar avec Undo | "Archivé — Annuler" |

---

### 48. Patterns Universels 2026 - Récapitulatif

Ces 20 patterns sont devenus des standards attendus. Les casser produit confusion et friction.

| # | Pattern | Plateforme | Règle d'or |
|---|---------|------------|------------|
| 1 | Hyperliens explicites | WEB | Texte = destination, compréhensible hors contexte |
| 2 | Back = filet de sécurité | WEB | JAMAIS casser le bouton Back |
| 3 | Navigation visible > cachée | WEB+MOBILE | Préférer nav visible si place disponible |
| 4 | Icône hamburger | WEB+MOBILE | Gain de place mais perte découvrabilité |
| 5 | Breadcrumbs | WEB | = hiérarchie du site (PAS l'historique) |
| 6 | Tabs / Bottom nav | MOBILE | Sections principales, peu d'items |
| 7 | Navigation drawer | MOBILE | Pour beaucoup de destinations |
| 8 | Recherche + suggestions | WEB+MOBILE | Temps réel, sans voler la saisie |
| 9 | Autocomplete accessible | WEB | Clavier + screen reader fonctionnels |
| 10 | Load more > pagination | WEB+MOBILE | Meilleur compromis que infinite scroll |
| 11 | Ajax | WEB | Ne pas casser back/accessibilité/état |
| 12 | Responsive design | WEB | Grilles fluides + media queries |
| 13 | Progressive enhancement | WEB | Base fonctionnelle d'abord |
| 14 | Design systems | WEB+MOBILE | Composants + comportements |
| 15 | Cards | WEB+MOBILE | 1 sujet, hiérarchie claire |
| 16 | Feed/timeline | WEB+MOBILE | Repères, état, mécanismes retour |
| 17 | Pull-to-refresh | MOBILE | Seuil clair + feedback immédiat |
| 18 | Snackbar + Undo | WEB+MOBILE | Non bloquant, 1 action max |
| 19 | Bottom sheets | MOBILE | Standard vs modal selon contexte |
| 20 | Touch targets | WEB+MOBILE | 44pt iOS / 48dp Android / 24px web min |

---

*Ajouté depuis: Codes avant-gardistes du design UI_UX encore standards en 2026-1.pdf (PDF 5/6)*

---

## Note: PDF 6

Le fichier `UNIVERSAL UI RULEBOOK V1 — Audit & Matrice V3 (Web + iOS + Android).pdf` est un **doublon** de `universal_ui_rulebook_v1_audit_matrice_v3.pdf` (PDF 2). Contenu déjà intégré ci-dessus.

---

## Consolidation Terminée

**Sources consolidées:**
1. `UX_Behavioral_Patterns_2024-2025_Checklist_FULL_v3.pdf` - États, Flux, Interactions, Information, Confiance
2. `universal_ui_rulebook_v1_audit_matrice_v3.pdf` - WCAG 2.2 (48 règles AA)
3. `Color Cheatsheet.pdf` - Système couleurs HSB
4. `1. SYSTÈME D'ESPACEMENT (Spacing).pdf` - Métriques, typo, composants, grille
5. `Codes avant-gardistes du design UI_UX encore standards en 2026-1.pdf` - Checklist Mario, 20 patterns
6. *(Doublon de #2)*

**Total: 48 sections, ~200 règles WEB**

---

*Document généré le 2026-02-09*
*Mis à jour avec: Linear 2024, Vercel Geist, Stripe Elements, Baymard 2024-2026*

---

## J. Ajouts 2024-2026 (Sources Premium)

### 49. Définition de la Densité (Linear 2024)

> "Density is not smaller spacing. Density is more information per pixel without increasing visual entropy."

| Composante | Description | Anti-pattern |
|------------|-------------|--------------|
| Alignment | Grille 4px stricte | Éléments mal alignés |
| Baselines | Line-height consistant | Heights variables |
| Typographic roles | Label vs Copy distinction | Tout en Body |
| Contrast ramps | Max 3-4 niveaux | 10 nuances de gris |

**Checklist Densité:**
- [ ] Grille 4px respectée partout
- [ ] Line-heights consistants par rôle
- [ ] Labels (single-line) vs Copy (multi-line) distingués
- [ ] Maximum 4 niveaux de contraste texte

---

### 50. Distinction Label vs Copy (Vercel Geist)

| Rôle | Usage | Line-height | Poids |
|------|-------|-------------|-------|
| **Label** | Single-line, boutons, nav, chips | 1.2 | Medium (500) |
| **Copy** | Multi-line, paragraphes, descriptions | 1.5 | Regular (400) |

**Pourquoi c'est important:**
- Labels avec line-height 1.5 = menus qui paraissent cramped
- Copy avec line-height 1.2 = paragraphes illisibles

```css
/* Labels (single-line) */
.label, .btn, .nav-item, .chip {
  line-height: 1.2;
  font-weight: 500;
}

/* Copy (multi-line) */
.body, .description, .paragraph {
  line-height: 1.5;
  font-weight: 400;
}
```

---

### 51. Typography Fluide (Clamp Pattern)

```css
:root {
  /* Body text - scales 15px → 18px */
  --text-body: clamp(15px, 0.95rem + 0.2vw, 18px);

  /* Headings - scales with viewport */
  --text-h1: clamp(28px, 1.5rem + 2vw, 48px);
  --text-h2: clamp(22px, 1.2rem + 1.2vw, 36px);
  --text-h3: clamp(18px, 1rem + 0.8vw, 24px);

  /* Line heights robustes WCAG 1.4.12 */
  --lh-body: 1.5;  /* Tolère override 1.5x */
}

body {
  font-size: var(--text-body);
  line-height: var(--lh-body);
}
```

**Règle premium:** Choisir des defaults déjà robustes sous le stress-test WCAG text-spacing.

---

### 52. Tokens de Couleur Accessibles (Stripe Pattern)

```css
:root {
  /* Base colors */
  --color-primary: #35d99a;
  --color-background: #1a1a2e;
  --color-text: #ffffff;
  --color-danger: #ff4d4d;

  /* Accessible ON-colors (garantit contraste 4.5:1) */
  --accessible-on-primary: #000000;
  --accessible-on-danger: #ffffff;
  --accessible-on-background: #ffffff;
}

/* Usage */
.btn-primary {
  background: var(--color-primary);
  color: var(--accessible-on-primary); /* Toujours lisible */
}
```

**Anti-pattern:** Choisir une couleur "jolie" sans vérifier le contraste du texte dessus.

---

### 53. LCH pour Dark Mode (Linear Pattern)

| Espace | Avantage | Usage |
|--------|----------|-------|
| **HSB** | Intuitif | Variations simples |
| **LCH** | Perceptuellement uniforme | Thèmes, rampes |

**Dark mode = hiérarchie de surfaces, pas juste #000 + #fff:**

```css
:root[data-theme="dark"] {
  --surface-0: hsl(240 10% 8%);   /* Background */
  --surface-1: hsl(240 10% 12%);  /* Cards */
  --surface-2: hsl(240 10% 16%);  /* Elevated */
  --surface-3: hsl(240 10% 20%);  /* Dialogs */
}
```

**Règle:** Générer les surfaces en LCH pour des "steps égaux" perceptuellement.

---

### 54. Command Palettes (Pattern 2024)

| Principe | Description |
|----------|-------------|
| Disponible partout | Cmd+K / Ctrl+K sur toute l'app |
| Shortcut prévisible | Toujours la même touche |
| Scoped | Résultats filtrés par contexte |
| Ranked | Triés par pertinence/fréquence |

**Implémentation:**
```html
<dialog id="command-palette" role="dialog" aria-modal="true">
  <input type="search" placeholder="Rechercher..." aria-label="Commande">
  <ul role="listbox" aria-label="Résultats">
    <!-- Résultats dynamiques -->
  </ul>
</dialog>
```

**Pourquoi c'est premium:** Permet UI calm + toutes features accessibles.

---

### 55. Benchmarks Checkout (Baymard 2024-2026)

| Métrique | Valeur | Source |
|----------|--------|--------|
| Steps moyen | 5.1 | Baymard 2024 |
| Champs moyen | 11.3 | Baymard 2024 |
| Abandon cause complexité | 18% | Baymard 2024 |
| Cart abandonment global | 70.22% | Baymard 2025 (50 études) |

**Règle critique:**
> "Your checkout doesn't win by being one page; it wins by lowering field management cost."

**Field burden > step count:**
- Réduire les CHAMPS importe plus que réduire les étapes
- Minimiser typing + verifying + fixing errors

---

### 56. Guest Checkout Prominent

| Stat | Valeur |
|------|--------|
| Sites qui cachent guest checkout | 62% |
| Impact | Users cherchent, certains abandonnent |

**Pattern correct:**
```
[ ] Créer un compte (optionnel)
[●] Continuer en tant qu'invité  ← DEFAULT, PREMIER

[Continuer →]
```

**Delayed account creation:** Proposer création compte APRÈS paiement confirmé.

---

### 57. Two-Stage Validation (Credit Card)

| Stage | Quoi | Pourquoi |
|-------|------|----------|
| 1. Front-end | Format, expiry, CVV length | Évite re-saisie si erreur serveur |
| 2. Serveur | Carte réelle | Validation finale |

```javascript
// Stage 1: Front-end (non-sensitive)
function validateCardFormat(card) {
  const cleanNumber = card.replace(/\s/g, '');
  if (!/^\d{13,19}$/.test(cleanNumber)) return false;
  return luhnCheck(cleanNumber);
}

// Stage 2: Serveur
// Si échec, NE PAS effacer les champs
// Message: "Carte refusée. Vérifiez les informations ou essayez une autre carte."
```

---

### 58. Density Variants (Stripe Elements)

| Variant | spacingUnit | Labels | Usage |
|---------|-------------|--------|-------|
| **Spaced** | 16px | Above inputs | Formulaires simples |
| **Condensed** | 12px | Floating | Checkouts, dashboards |

```css
/* Spaced (default) */
[data-density="spaced"] {
  --input-spacing: 16px;
  --label-position: above;
}

/* Condensed */
[data-density="condensed"] {
  --input-spacing: 12px;
  --label-position: floating;
}
```

---

### 59. iOS Spring Animation Values

| Bounce | Effet | Usage |
|--------|-------|-------|
| ~0.15 | Subtil | Plupart des interactions |
| ~0.30 | Noticeable | Feedback important |
| ~0.40+ | Caution | Peut être excessif |

```swift
// SwiftUI preset
.animation(.snappy) // duration: 0.5s, default bounce

// Custom subtle
.animation(.spring(bounce: 0.15))

// Noticeable feedback
.animation(.spring(bounce: 0.30))
```

---

### 60. DOM Measurement (Sites Production)

Pour mesurer les marges/containers de sites de référence:

```javascript
// Exécuter dans DevTools sur le site cible
(() => {
  const el = document.querySelector("main") || document.body;
  const r = el.getBoundingClientRect();
  return {
    viewport: { w: window.innerWidth, h: window.innerHeight },
    mainRect: { x: r.x, y: r.y, w: r.width, h: r.height },
    leftMargin: Math.round(r.x),
    rightMargin: Math.round(window.innerWidth - (r.x + r.width)),
  };
})();

// Répéter à: 375, 768, 1024, 1440, 1920px
// Puis encoder dans vos tokens
```

---

## Récapitulatif Quick Table

| Domaine | Rail Premium | Source |
|---------|--------------|--------|
| iOS springs | bounce 0.15/0.30/0.40 | Apple WWDC |
| SwiftUI snappy | 0.5s default | Apple docs |
| Stripe spacing | 0,2,4,8,16,24,32,48px | Stripe Apps |
| Stripe density | spacingUnit base | Stripe Elements |
| Vercel type | Headings 72→14, Copy 24→13 | Geist docs |
| Text spacing | line-height 1.5×, letter 0.12× | WCAG 1.4.12 |
| Touch targets | 24×24 min, 44×44 enhanced | WCAG 2.5.8 |
| Android slider | 48dp thumb touch | Material |
| Checkout avg | 5.1 steps, 11.3 fields | Baymard 2024 |
| Cart abandon | 70.22% | Baymard 2025 |
| INP (Core Vital) | Remplace FID depuis 2024-03-12 | web.dev |

---

## PREMIUM FEEL - Règles Evidence-Backed (2024-2026)

*Source: ChatGPT Deep Research - Premium-Feeling Product UI*

### 60. 10 Erreurs qui font "meh"

| Erreur | Pourquoi c'est meh |
|--------|-------------------|
| Over-bouncy springs partout | Navigation devient "jouet" |
| Animation sans cause | Perçu comme délai/décoration |
| Pas de density rails | Chaque surface invente son padding |
| Thèmes en espaces non-uniformes | Custom themes look "off" |
| Tokens sans on-color pairs | Régressions contraste constantes |
| Tiny touch targets | Précision UI = cheap sur tactile |
| Validation prématurée | Punit l'utilisateur mid-entry |
| Guest checkout caché | Users assume forced registration |
| Perf qui ignore responsiveness | Fast load, sluggish interactions |
| Onboarding tutorial-heavy | Interrompt, vite oublié |

### 61. Checklist Premium Feel

**Motion & Feedback:**
- [ ] 3 motion tokens (crisp/subtle/playful) - ban one-offs
- [ ] Motion = cause visible (jamais ambient)
- [ ] Haptics only at decision points
- [ ] Respect prefers-reduced-motion

**Density & Typography:**
- [ ] Spacing unit + small scale (0,2,4,8,16,24,32,48)
- [ ] Label vs Copy line-height séparés
- [ ] Stress-test WCAG text-spacing (1.5× line-height, 0.12× letter)

**Color & Accessibility:**
- [ ] Semantic tokens + on-color accessible pairs
- [ ] High contrast = paramètre first-class
- [ ] Thèmes générés en LCH

**Forms:**
- [ ] Field burden > step count
- [ ] Guest checkout prominent
- [ ] Inline validation: no premature, remove on fix, positive feedback

---

## K. Data Visualization

### 62. Choix de Type de Graphique

| Type | Quand utiliser | Valeur / Note | Source |
|------|----------------|---------------|--------|
| Bar Chart | Comparaison catégories discrètes | Meilleur que pie pour comparaisons | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Line Chart | Tendances temporelles, données continues | Séries temporelles, métriques continues | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Scatter Plot | Relation/corrélation entre 2 variables | Corrélations X vs Y | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Pie Chart | Parts d'un tout (peu de slices) | ≤5 catégories max; difficile à comparer | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Area Chart | Volume sous une courbe de tendance | Éviter trop de stacks; peut tromper si overlap | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Stacked Bar | Composition dans catégories (2-3 stacks) | Utiliser sparingly; taux d'erreur élevé | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |
| Horizontal Bar | Labels longs ou nombreux | Meilleure lisibilité | [NN/g Chart Types](https://www.nngroup.com/articles/choosing-chart-types/) |

**Checklist:**
- [ ] Chart type correspond aux données: tendances→line, comparaisons→bar, corrélation→scatter
- [ ] Pie charts ≤5 slices; sinon bar chart
- [ ] Horizontal bars si labels longs
- [ ] Éviter stacking >2 séries sans légende claire

---

### 63. Palettes de Couleurs Data

| Palette | Quand utiliser | Valeur / Guidance | Source |
|---------|----------------|-------------------|--------|
| Sequential | Données ordonnées/numériques (intensité) | Gradient mono-teinte (clair→foncé) | [Atlassian Data Viz](https://www.atlassian.com/data/charts/how-to-choose-colors-data-visualization) |
| Diverging | Données avec point médian significatif | 2 teintes contrastées + neutre au milieu | [Atlassian Data Viz](https://www.atlassian.com/data/charts/how-to-choose-colors-data-visualization) |
| Categorical | Groupes/catégories distinctes | ≤8-10 couleurs distinguables; <8 pour colorblind | [Atlassian Data Viz](https://www.atlassian.com/data/charts/how-to-choose-colors-data-visualization) |

**Règles d'accessibilité couleurs:**
- Palettes colorblind-friendly (ColorBrewer)
- Contraste ≥6:1 entre texte et fond
- Ne jamais se fier uniquement au rouge/vert
- Ajouter patterns (rayures, points) si couleur seule insuffisante
- Tester avec simulateur daltonisme

**Checklist:**
- [ ] Sequential: 1 teinte, variation de luminosité (ex: #eef → #114)
- [ ] Diverging: 2 teintes distinctes (ex: bleu↔blanc↔rouge)
- [ ] Categorical: ≤8 couleurs hautement distinguables
- [ ] Palette testée avec simulateur colorblind

---

### 64. Accessibilité des Graphiques

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Pattern Fills | En plus de la couleur, textures/formes | Rayures, points pour différencier séries | [Plaid Design A11y](https://medium.com/plaid-design/visually-accessible-data-visualization-ff884121479b) |
| Taille Labels | Texte lisible (axes, légendes) | ≥12pt (~16px) pour charts écran | [RSS DataVis Guide](https://royal-statistical-society.github.io/datavisguide/docs/styling.html) |
| Contraste Texte | Labels et légendes | ≥4.5:1 contre fond | [WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum) |
| Contraste Non-texte | Lignes, barres | ≥3:1 contre fond | [WCAG 1.4.11](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast) |
| Screen Reader SVG | Wrapper et descriptions | `<figure>` + `<figcaption>` ou `aria-label` | [USWDS Data Viz](https://designsystem.digital.gov/components/data-visualizations/) |
| Alt Text | Info clé dans description | Titre, axes, ce que le chart montre | [USWDS Data Viz](https://designsystem.digital.gov/components/data-visualizations/) |

**Code SVG accessible:**
```html
<figure>
  <svg role="img" aria-labelledby="chartTitle" aria-describedby="chartDesc">
    <!-- chart drawing -->
  </svg>
  <figcaption id="chartDesc">Bar chart des ventes trimestrielles...</figcaption>
</figure>
```

**Checklist:**
- [ ] Labels externes (pas placeholders) pour données
- [ ] Taille texte ≥16px, contraste ≥4.5:1
- [ ] Charts complexes: résumé texte ou table pour screen readers
- [ ] Tester avec screen reader: titre et données annoncés

---

### 65. Layout Dashboard

| Aspect | Quand utiliser | Valeur / Guidance | Source |
|--------|----------------|-------------------|--------|
| Hiérarchie Info | Design dashboard | KPIs importants en haut-gauche (F-pattern) | [Quanthub Dashboard](https://www.quanthub.com/how-do-you-design-the-layout-for-your-dashboard/) |
| Ratio Cards | Cards avec média (images/charts) | 16:9 ou 1:1 pour cohérence | [Material Cards](https://m1.material.io/components/cards.html) |
| Auto-Refresh | Dashboards live/opérationnels | Afficher "Dernière MAJ: [heure]" + spinner pendant refresh | [Julius AI Dashboard](https://julius.ai/articles/business-intelligence-dashboard-design-best-practices) |
| Fréquence Refresh | Données temps réel | Opérationnel: 1-5s; Analytique: <5min | [Julius AI Dashboard](https://julius.ai/articles/business-intelligence-dashboard-design-best-practices) |

**Placement contenu:**
- F-pattern: info critique (KPI principal) en haut-gauche
- Données secondaires vers droite/bas (tendances, comparaisons)
- Données critiques au-dessus du fold

**Checklist:**
- [ ] Top 3 KPIs positionnés en haut-gauche
- [ ] Ratio 16:9 pour média/cards images
- [ ] Timestamp "Dernière MAJ" visible sur dashboard live
- [ ] Loading indicator si fetch >300ms
- [ ] Données critiques visibles sans scroll

---

### 66. Sparklines

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Dimensions | Très petites, inline avec texte | Hauteur ~15-30px | [Evidence Sparkline](https://docs.evidence.dev/components/charts/sparkline) |
| Stroke Width | Ligne fine pour données | ~1px pour data, 1.5-2px pour baseline | [Evidence Sparkline](https://docs.evidence.dev/components/charts/sparkline) |
| Contraste | Ligne vs fond | ≥3:1 | [WCAG 1.4.11](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast) |
| Usage | Tendance simple (mini stock chart) | Pas d'axes ni labels | [Evidence Sparkline](https://docs.evidence.dev/components/charts/sparkline) |

**Checklist:**
- [ ] Hauteur ~15px, stroke ~1px
- [ ] Pas de labels d'axes (défait le gain de place)
- [ ] Gridlines subtiles si besoin (<30% opacité)
- [ ] Utiliser sparingly - uniquement si tendance immédiate ajoute clarté

---

### 67. Charts Responsives

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Breakpoints | Adapter charts aux écrans | 0-600px (mobile): 1 colonne; 600-900px: 2 cols; >900px: multi-col | [MUI Breakpoints](https://mui.com/material-ui/customization/breakpoints/) |
| Layout Mobile | Petits écrans (<400px) | Remplacer charts détaillés par résumés ou top 3; stack vertical | [Datafloq Responsive](https://datafloq.com/responsive-design-for-data-visualizations-ultimate-guide/) |
| Touch Targets | Éléments interactifs (points, légende) | ≥44×44px zone de tap | [WCAG 2.5.8](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum) |
| Tooltips Mobile | Remplacer hover | Tap-to-show au lieu de hover | [Datafloq Responsive](https://datafloq.com/responsive-design-for-data-visualizations-ultimate-guide/) |

**Checklist:**
- [ ] Breakpoints définis (600px, 900px) avec reflow layout
- [ ] Points/icônes interactifs ≥44px tap area
- [ ] Mobile: tooltips tap au lieu de hover
- [ ] Tester gestes touch (zoom, pan) sur devices

---

### 68. Animation des Charts

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Durée Transition | Transitions charts (nouvelles données) | 200-400ms (viser ~300ms ease-in-out) | [Chart.js Animations](https://www.chartjs.org/docs/latest/configuration/animations.html) |
| Micro-interaction | Highlight barre, point | ~150ms | [Chart.js Animations](https://www.chartjs.org/docs/latest/configuration/animations.html) |
| Easing | Courbe naturelle | ease-in-out: `cubic-bezier(0.42,0,0.58,1)` | [Chart.js Animations](https://www.chartjs.org/docs/latest/configuration/animations.html) |
| Stagger | Multiple éléments (barres, points) | Délai ~50-100ms entre items | [Chart.js Animations](https://www.chartjs.org/docs/latest/configuration/animations.html) |

**CSS exemple:**
```css
.bar {
  transition: height 300ms ease-in-out;
}
```

**Checklist:**
- [ ] Durée animation ~300ms (250-350ms) pour changements majeurs
- [ ] Easing linear ou ease-in-out (pas de start/stop abrupt)
- [ ] Stagger ~50ms par item pour effet cascade
- [ ] Pas d'animations en boucle auto-play (seulement load/data change)

---

### 69. Densité des Données

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Métrique par Chart | Une métrique principale par chart | Pas de métriques non liées dans même chart | [Standing Partnership](https://standingpartnership.com/bad-data-visualizations-and-how-to-avoid-them/) |
| Limite Points | Points visibles gérables | ≤50-100 points sans agrégation/zoom | [Standing Partnership](https://standingpartnership.com/bad-data-visualizations-and-how-to-avoid-them/) |
| Agrégation | Données denses | Binning, averaging (ex: daily→weekly) | [Standing Partnership](https://standingpartnership.com/bad-data-visualizations-and-how-to-avoid-them/) |
| Small Multiples | Données multivariées | Plusieurs petits charts plutôt qu'un surchargé | [Standing Partnership](https://standingpartnership.com/bad-data-visualizations-and-how-to-avoid-them/) |

**Checklist:**
- [ ] 1 série de données principale par chart (+contextuel comme goal line OK)
- [ ] Si >100 points: agréger ou permettre zoom
- [ ] Variables multiples: small multiples plutôt qu'un chart surchargé
- [ ] Échelles d'axes appropriées (pas de compression extrême)

---

## L. Microcopy & UX Writing

### 70. Labels de Boutons

| Aspect | Règle | Valeur | Source |
|--------|-------|--------|--------|
| Ordre des mots | Verbe en premier (action-focused) | "Save Document", "Add to Cart" | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) |
| Casse iOS | Title Case | "Save Changes" | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) |
| Casse Web/Android | Sentence case | "Save changes" | [Intuit Content Design](https://contentdesign.intuit.com/product-and-ui/actions/) |
| Longueur | Court et spécifique | ≤24 caractères (2-4 mots) | [UX StackExchange](https://ux.stackexchange.com/questions/147132/what-are-the-best-practices-to-decide-the-length-of-label-characters-on-the-butt) |
| ALL CAPS | Jamais | Considéré comme crier, mauvaise accessibilité | [Intuit Content Design](https://contentdesign.intuit.com/product-and-ui/actions/) |

**Exemples:**
```html
<button>Save Document</button>  <!-- iOS: Title Case -->
<button>Save document</button>  <!-- Web/Android: Sentence case -->
<button>Add to Cart</button>    <!-- Verbe + objet -->
```

**Checklist:**
- [ ] Commencer par verbe clair (Add, Save, Delete, etc.)
- [ ] ≤24 caractères, 2-4 mots
- [ ] Title Case sur iOS, Sentence case ailleurs
- [ ] Jamais ALL CAPS
- [ ] Tester largeur bouton sur petits écrans

---

### 71. Spectre de Tonalité

| Contexte | Ton | Exemple | Source |
|----------|-----|---------|--------|
| Finance, Santé, Legal | Formel | "Transfer completed successfully" | [NN/g Tone Dimensions](https://www.nngroup.com/articles/tone-of-voice-dimensions/) |
| Consumer, Entertainment | Casual | "All set – you're rockin' it!" | [NN/g Tone Dimensions](https://www.nngroup.com/articles/tone-of-voice-dimensions/) |
| B2B, Professional | Semi-formel | "Your report is ready to download" | [NN/g Tone Dimensions](https://www.nngroup.com/articles/tone-of-voice-dimensions/) |

**Règles:**
- Déterminer audience: B2B/pro → formel; B2C/entertainment → casual
- Rester cohérent une fois le ton choisi
- Éviter slang/jargon dans apps sérieuses
- Emojis sparingly dans contextes casual uniquement

**Checklist:**
- [ ] Ton défini selon audience (formel vs casual)
- [ ] Ton appliqué de manière cohérente partout
- [ ] Pas d'humour dans interfaces médicales/légales/financières
- [ ] Pas de langage trop rigide dans apps fun

---

## M. Internationalisation & Localisation

### 72. Expansion de Texte

| Langue | Expansion vs Anglais | Buffer CSS | Source |
|--------|---------------------|------------|--------|
| Allemand (DE) | +30-35% | min-width: 130% | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |
| Russe (RU) | +30-35% | min-width: 130% | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |
| Français (FR) | +20% | min-width: 120% | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |
| Espagnol (ES) | +20% | min-width: 120% | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |
| Chinois (ZH) | -30% caractères | Peut nécessiter plus de hauteur | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |
| Japonais (JA) | -30% caractères | Peut nécessiter plus de hauteur | [UX Collective i18n](https://uxdesign.cc/ignoring-character-limits-can-wreck-your-products-ux-3c2dc3b6b24a) |

**Règle pratique:** Designer containers 50% plus larges que texte anglais, ou permettre wrapping.

---

### 73. Support RTL (Arabe, Hébreu)

| Aspect | Action | Code/Valeur | Source |
|--------|--------|-------------|--------|
| Direction layout | Flip direction | `dir="rtl"` sur `<html>` | [UX Collective RTL](https://uxdesign.cc/mobile-app-design-for-right-to-left-languages-57c63f136749) |
| Navigation | Mirror UI flow | Droite-à-gauche | [UX Collective RTL](https://uxdesign.cc/mobile-app-design-for-right-to-left-languages-57c63f136749) |
| Icônes directionnelles | Flip | Flèches, progress bars, sliders | [UX Collective RTL](https://uxdesign.cc/mobile-app-design-for-right-to-left-languages-57c63f136749) |
| Icônes non-directionnelles | Ne pas flip | Logos, charts, check marks | [UX Collective RTL](https://uxdesign.cc/mobile-app-design-for-right-to-left-languages-57c63f136749) |
| Alignement texte | Labels alignés droite | `text-align: right` (auto avec RTL) | [UX Collective RTL](https://uxdesign.cc/mobile-app-design-for-right-to-left-languages-57c63f136749) |

**CSS RTL:**
```css
[dir="rtl"] {
  direction: rtl;
}
[dir="rtl"] .icon-arrow {
  transform: scaleX(-1); /* Flip horizontal */
}
```

---

### 74. Formats Localisés

| Donnée | Méthode | Exemple | Source |
|--------|---------|---------|--------|
| Dates | `Intl.DateTimeFormat` | US: MM/DD/YYYY; EU: DD/MM/YYYY; ISO: YYYY-MM-DD | [MDN Intl](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) |
| Nombres | `Intl.NumberFormat` | US: 1,234.56; FR: 1 234,56; DE: 1.234,56 | [MDN Intl](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) |
| Monnaie | `Intl.NumberFormat` + currency | $1,234 vs 1.234 € vs ¥1,234 | [MDN Intl](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) |

**Code JS:**
```javascript
// Date locale
new Intl.DateTimeFormat('fr-FR').format(date) // "09/02/2026"

// Nombre locale
new Intl.NumberFormat('de-DE').format(1234.56) // "1.234,56"

// Monnaie locale
new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(1234)
```

**Checklist Localisation:**
- [ ] UI elements expandent gracefully (+20-35% pour DE/RU)
- [ ] Layout flip pour langues RTL (`direction: rtl`)
- [ ] Dates/nombres formatés via API locale (`Intl`)
- [ ] Images/texte localisés (pas de hardcode anglais)
- [ ] Tests avec native speakers pour erreurs culturelles

---

## N. Gamification & Engagement

### 75. Streaks (Séries)

| Aspect | Valeur | Source |
|--------|--------|--------|
| Seuil clé | 7 jours consécutifs (+3.6× rétention) | [UX Magazine](https://uxmag.com/articles/the-psychology-of-hot-streak-game-design-how-to-keep-players-coming-back-every-day-without-shame) |
| Grace period | 1-2 jours (incident technique, voyage) | [Duolingo Blog](https://blog.duolingo.com/widget-feature/) |
| Streak Freeze | Mécanisme payant ou earned (1-3 freezes) | Duolingo, Snapchat |
| Affichage | Flamme, anneau, calendrier de contributions | GitHub, Wordle |

**Apps utilisant ce pattern:** Duolingo, Snapchat, Wordle, GitHub, Headspace

**Quand utiliser:** Engagement quotidien, formation d'habitudes (langues, fitness, santé)
**Quand éviter:** Contenu non quotidien, risque d'anxiété (streak perçu comme pénalité)

**Checklist:**
- [ ] Indicateur visuel clair (flamme, anneau, calendrier)
- [ ] Mécanisme de récupération (Streak Freeze, rattrapage)
- [ ] Grace period pour incidents (1-2 jours)
- [ ] Règles de maintien expliquées clairement
- [ ] Pas de notifications abusives (éviter la pression)

**Code CSS:**
```css
/* Anneau de progression pour streak */
.streak-ring {
  stroke-dasharray: 100;
  stroke-dashoffset: calc(100 - var(--progress));
  transition: stroke-dashoffset 0.5s ease-out;
}
```

---

### 76. Points, Badges & Leaderboards (PBL)

| Élément | Règle | Source |
|---------|-------|--------|
| Points | Earning rates définis, éviter l'inflation | [Yukai Chou](https://yukaichou.com/advanced-gamification/how-to-design-effective-leaderboards-boosting-motivation-and-engagement/) |
| Badges tiers | Common → Rare → Epic → Legendary | [IxDF](https://www.interaction-design.org/literature/topics/leaderboards) |
| Leaderboard default | Weekly ou Daily (pas All-time) | [UI Patterns](https://ui-patterns.com/patterns/leaderboard) |
| Leaderboard views | Global, Friends, Local | [Mockplus](https://www.mockplus.com/blog/post/gamification-ui-ux-design-guide) |

**Leaderboard Best Practices:**
- Afficher le rank de l'utilisateur + joueurs immédiatement au-dessus/en-dessous
- Proposer vues: Friends > Weekly > Global (Friends par défaut si disponible)
- Reset hebdomadaire/mensuel pour donner des "fresh starts"
- Éviter pour données sensibles (finance, santé personnelle)

**Checklist:**
- [ ] Points avec valeur claire (1 action = X points)
- [ ] Badges avec conditions de déblocage explicites
- [ ] Leaderboard friends-first si social disponible
- [ ] Vue weekly par défaut (pas all-time)
- [ ] Position de l'utilisateur toujours visible

---

### 77. Engagement Loops

| Modèle | Composants | Source |
|--------|------------|--------|
| Hook Model (Nir Eyal) | Trigger → Action → Variable Reward → Investment | [Hooked Book](https://www.nirandfar.com/hooked/) |
| Fogg Behavior | Motivation × Ability × Prompt | [BJ Fogg](https://behaviormodel.org/) |
| Impact | Apps gamifiées: +20-30% engagement | [Statista 2024](https://arounda.agency/blog/gamification-in-product-design-in-2024-ui-ux) |

**Variable Rewards Types:**
- Rewards of the Tribe (social validation)
- Rewards of the Hunt (resources, money)
- Rewards of the Self (mastery, completion)

**Checklist:**
- [ ] Core behavior identifié (que répéter? check-ins, achats, partages)
- [ ] Rewards court-terme (daily) + long-terme (30-day streaks)
- [ ] Variable rewards pour éviter la fatigue de prédictibilité
- [ ] Investment qui augmente la valeur (personnalisation, contenu)

---

## O. Tables & Data Grids

### 78. Anatomie des Tables

| Élément | Valeur | Source |
|---------|--------|--------|
| Row height compact | 32-36px | [Pencil & Paper](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-data-tables) |
| Row height default | 40-52px | [UX Shark](https://www.uxshark.com/designing-user-friendly-data-tables/) |
| Row height comfortable | 52-64px | Material Design |
| Header height | 56px | Material Design |
| Cell padding | 16-24px | [IBM Carbon](https://carbondesignsystem.com/components/data-table/style/) |

**Alignement:**
- Texte: aligné à gauche
- Nombres: alignés à droite
- Dates: centre ou gauche
- Actions: droite

**Checklist:**
- [ ] Headers sticky sur scroll vertical
- [ ] Zebra striping subtil OU dividers (pas les deux)
- [ ] Density toggle si beaucoup de données (compact/default/comfortable)
- [ ] Min-width sur colonnes pour éviter le wrapping excessif

---

### 79. Sorting & Filtering

| Pattern | Règle | Source |
|---------|-------|--------|
| Sort indicator | Chevron/flèche dans le header | [UX Booth](https://uxbooth.com/articles/designing-user-friendly-data-tables/) |
| Multi-column sort | Shift+click pour sort secondaire | Convention |
| Filter position | Proche des colonnes qu'ils contrôlent | [Pencil & Paper](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-data-tables) |
| Filter chips | Au-dessus de la table, avec X pour clear | Pattern standard |

**Client-side vs Server-side:**
- < 1000 rows: client-side (meilleure UX)
- > 1000 rows: server-side (performance)

**Checklist:**
- [ ] Sort indicator visible sur colonne active
- [ ] Direction de tri claire (A-Z, Z-A, 1-9, 9-1)
- [ ] Filters avec "Clear all" toujours accessible
- [ ] Saved views/filters pour power users

---

### 80. Pagination

| Pattern | Quand utiliser | Source |
|---------|----------------|--------|
| Pagination | Référence à pages spécifiques, comparaison | [Mann Howie](https://mannhowie.com/data-table-ux) |
| Infinite scroll | Feeds, timelines (pas analytical) | [UX Planet](https://uxplanet.org/best-practices-for-usable-and-efficient-data-table-in-applications-4a1d1fb29550) |
| Load more | Compromis entre les deux | Mobile-friendly |

**Page sizes recommandés:** 10, 25, 50, 100

**Pattern:** "Showing X-Y of Z items"

**Checklist:**
- [ ] Page size selector (10/25/50/100)
- [ ] "Showing X-Y of Z" toujours visible
- [ ] Navigation first/prev/next/last
- [ ] Loading state (skeleton rows ou spinner overlay)

---

### 81. Responsive Tables

| Pattern | Description | Source |
|---------|-------------|--------|
| Horizontal scroll | Sticky first column + scroll | [Tenscope](https://www.tenscope.com/post/table-ux-best-practices) |
| Column priority | Hide less important columns on mobile | [Denovers](https://www.denovers.com/blog/enterprise-table-ux-design) |
| Collapse to cards | Table → stack de cards sur mobile | [Justinmind](https://www.justinmind.com/ui-design/data-table) |
| Expandable rows | Click pour voir détails | Pattern standard |

**Checklist:**
- [ ] Colonnes prioritaires toujours visibles
- [ ] Geste horizontal évident (scroll hint)
- [ ] Touch-friendly row actions (swipe ou long press)
- [ ] Test sur 320px width minimum

---

### 82. Table Accessibility

| Aspect | Règle | Source |
|--------|-------|--------|
| Sémantique | `<table>`, `<thead>`, `<tbody>`, `<th>` | [WCAG](https://www.w3.org/WAI/tutorials/tables/) |
| Headers | `scope="col"` ou `scope="row"` | WCAG |
| Keyboard | Arrow keys pour navigation cellules | [IBM Carbon](https://carbondesignsystem.com/components/data-table/style/) |
| Annonces | Screen reader annonce sort/filter changes | ARIA live |

**Code HTML:**
```html
<table>
  <thead>
    <tr>
      <th scope="col">Nom</th>
      <th scope="col" class="numeric">Montant</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Exemple</td>
      <td class="numeric">€123,45</td>
    </tr>
  </tbody>
</table>
```

**Checklist:**
- [ ] Semantic HTML (`<table>` pas CSS grid pour data)
- [ ] `scope` sur tous les `<th>`
- [ ] Keyboard navigation (Tab, arrows)
- [ ] Focus visible sur cellule/row active

---

## P. Settings & Preferences

### 83. Architecture des Settings

| Aspect | Règle | Source |
|--------|-------|--------|
| Grouping | Par fonction, fréquence, ou workflow | [Toptal](https://www.toptal.com/designers/ux/settings-ux) |
| Hierarchy depth | Max 2-3 niveaux | [Netguru](https://www.netguru.com/blog/how-to-improve-app-settings-ux) |
| Search | Essential pour apps complexes | [SetProduct](https://www.setproduct.com/blog/settings-ui-design) |
| Two-level | Basic (default) + Advanced (opt-in) | [Toptal](https://www.toptal.com/designers/ux/settings-ux) |

**Checklist:**
- [ ] Settings groupés logiquement (Account, Notifications, Privacy, etc.)
- [ ] Max 2-3 niveaux de profondeur
- [ ] Search si > 20 settings
- [ ] Basic vs Advanced separation si complexe

---

### 84. Toggle vs Checkbox

| Control | Quand utiliser | Source |
|---------|----------------|--------|
| Toggle | Effet immédiat, binaire, mobile | [NN/g](https://www.nngroup.com/articles/toggle-switch-guidelines/) |
| Checkbox | Partie d'un form, save explicit, indeterminate possible | [Eleken](https://www.eleken.co/blog-posts/checkbox-ux) |

**Tailles recommandées:**
- iOS: 51×31pt
- Android: 52×32dp
- Web: 44×24px minimum

**Règle d'or:** Toggle = effet immédiat, pas de bouton Save

**Checklist:**
- [ ] Toggle pour on/off avec effet immédiat
- [ ] Checkbox dans forms avec bouton Save
- [ ] Labels clairs (pas de double négation)
- [ ] État actuel toujours évident (ON vs OFF visible)

---

### 85. Destructive Settings

| Pattern | Usage | Source |
|---------|-------|--------|
| Type to confirm | "Tapez DELETE pour confirmer" | GitHub pattern |
| Countdown | Bouton désactivé 5-10 secondes | Prevent accidental clicks |
| Checkbox confirm | "Je comprends que c'est irréversible" | GDPR standard |
| Data export | Proposer export avant deletion | GDPR requirement |

**Account deletion (GDPR):**
- DOIT être possible (pas caché)
- PEUT avoir friction raisonnable
- DOIT offrir export de données
- PEUT avoir cooling-off period (7-30 jours)

**Checklist:**
- [ ] Warning clair "This cannot be undone"
- [ ] Confirmation explicite (type, checkbox, countdown)
- [ ] Export de données proposé avant deletion
- [ ] Pas de dark patterns (bouton caché, friction excessive)

---

## Q. Search UX

### 86. Search Input

| Aspect | Valeur | Source |
|--------|--------|--------|
| Width desktop | 200-600px | [LogRocket](https://blog.logrocket.com/ux-design/design-search-bar-intuitive-autocomplete/) |
| Width mobile | Full-width | Convention |
| Placeholder | "Search..." ou contextuel "Search products..." | [Baymard](https://baymard.com/blog/autocomplete-design) |
| Icon position | Gauche (standard) | Convention |
| Shortcut | Cmd/Ctrl+K ou / | Spotlight pattern |

**Checklist:**
- [ ] Clear button (X) quand texte présent
- [ ] Keyboard shortcut visible (badge "⌘K")
- [ ] Focus auto-select all text ou cursor at end
- [ ] Voice search icon si supporté

---

### 87. Autocomplete & Suggestions

| Aspect | Valeur | Source |
|--------|--------|--------|
| Max suggestions | 5-10 items (8 sur mobile) | [Baymard](https://baymard.com/blog/autocomplete-design) |
| Debounce | 150-300ms | [Smart Interface Patterns](https://smart-interface-design-patterns.com/articles/autocomplete-ux/) |
| Show on focus | OUI (avant même de taper) | [Baymard](https://baymard.com/blog/autocomplete-design) |
| Sources | Recent, Popular, Personalized, Preview | [UX Patterns Dev](https://uxpatterns.dev/patterns/forms/autocomplete) |

**Seulement 19% des sites implémentent correctement l'autocomplete** - [Baymard](https://baymard.com/blog/autocomplete-design)

**Mixed suggestions:** Keywords + Categories + Products + Pages

**Checklist:**
- [ ] Suggestions dès le focus (pas seulement après frappe)
- [ ] Max 10 items desktop, 8 mobile
- [ ] Highlight matching text (bold query terms)
- [ ] Keyboard nav (arrows, Enter, Escape)
- [ ] Recent searches en premier si disponibles

---

### 88. No Results State

| Pattern | Description | Source |
|---------|-------------|--------|
| Message friendly | "No results for 'xyz'" | [Algolia](https://www.algolia.com/doc/guides/building-search-ui/ui-and-ux-patterns/query-suggestions/ios/) |
| Spell correction | "Did you mean: [corrected]?" | Google pattern |
| Suggestions | Vérifier orthographe, essayer autres mots | Standard |
| Alternatives | Popular items, related content | E-commerce pattern |

**Checklist:**
- [ ] Message clair sans blâmer l'utilisateur
- [ ] Spell correction si applicable
- [ ] Suggestions alternatives (popular, related)
- [ ] Clear search CTA pour recommencer
- [ ] Contact support si critique

---

### 89. Faceted Search / Filters

| Pattern | Desktop | Mobile | Source |
|---------|---------|--------|--------|
| Position | Sidebar gauche | Button → Sheet/Drawer | [Smashing](https://smashingconf.com/online-workshops/workshops/search-ux-vitaly-friedman) |
| Active filters | Chips au-dessus des résultats | Chips | Standard |
| Clear all | Toujours visible | Toujours visible | UX requirement |
| Counts | "(42)" à côté de chaque option | Optionnel sur mobile | [StackOverflow pattern](https://stackoverflow.com/) |

**Checklist:**
- [ ] Filters proches du contenu qu'ils filtrent
- [ ] Active filters visibles en permanence (chips)
- [ ] "Clear all" accessible facilement
- [ ] Counts pour montrer impact du filtre
- [ ] Collapsible sections pour filtres nombreux

---

## R. Loading & Performance

### 90. Response Time Thresholds

| Durée | Perception | Action UX | Source |
|-------|------------|-----------|--------|
| 0-100ms | Instant | Aucun feedback nécessaire | [Nielsen](https://www.nngroup.com/articles/response-times-3-important-limits/) |
| 100-300ms | Légère pause | Subtle indicator OK | Convention |
| 300ms-1s | Noticeable | Spinner ou skeleton | [LogRocket](https://blog.logrocket.com/ux-design/skeleton-loading-screen-design/) |
| 1-10s | Long | Progress + explanation | [Clay](https://clay.global/blog/skeleton-screen) |
| 10s+ | Très long | Background task + notification | Convention |

---

### 91. Skeleton Screens

| Aspect | Valeur | Source |
|--------|--------|--------|
| Perception | +20-30% plus rapide que spinner | [UI Deploy](https://ui-deploy.com/blog/skeleton-screens-vs-spinners-optimizing-perceived-performance) |
| Facebook finding | 300ms faster perceived load | [Medium](https://medium.com/@elenech/the-psychology-of-waiting-skeletons-ca3b309e12a2) |
| Animation | Shimmer left-to-right, 1.5-2s | [SitePoint](https://www.sitepoint.com/how-to-speed-up-your-ux-with-skeleton-screens/) |
| Colors | Light gray (#E0E0E0 light / #333 dark) | Material Design |

**Quand utiliser:**
- Layout connu à l'avance
- Load time < 3s
- Content-heavy pages

**Quand NE PAS utiliser:**
- Layout imprévisible
- Loads très rapides (< 300ms)
- Actions instantanées

**Checklist:**
- [ ] Shapes qui mimiquent le contenu réel
- [ ] Animation shimmer subtile
- [ ] Pas de skeleton pour < 300ms loads
- [ ] Transition smooth vers contenu réel

**Code CSS:**
```css
.skeleton {
  background: linear-gradient(
    90deg,
    #e0e0e0 25%,
    #f0f0f0 50%,
    #e0e0e0 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

### 92. Optimistic UI

| Pattern | Description | Source |
|---------|-------------|--------|
| Principe | Update UI immédiatement, sync en background | [Flowwies](https://flowwies.blog/psychology-of-loading-states-reduce-perceived-wait-c6da1afa2d28) |
| Use cases | Likes, saves, toggles, add to list | Social apps |
| Failure | Revert + error toast | Standard |
| Indicator | Opacity réduite ou pending icon | Subtle feedback |

**Checklist:**
- [ ] Actions simples et réversibles uniquement
- [ ] Feedback visuel de pending state (subtle)
- [ ] Rollback graceful si échec
- [ ] Error toast explicatif

---

### 93. Offline & Error States

| State | Pattern | Source |
|-------|---------|--------|
| Offline detected | Banner en haut "You're offline" | Convention |
| Cached content | Montrer + badge "Offline" | PWA standard |
| Queue actions | Sync quand online | IndexedDB pattern |
| Last updated | "Updated 5 min ago" | Trust indicator |

**Checklist:**
- [ ] Offline indicator visible mais non-intrusif
- [ ] Contenu cached accessible
- [ ] Actions queued pour sync
- [ ] "Retry" button pour actions failed

---

## S. Dark Mode

### 94. Surfaces & Elevation

| Elevation | Color (Material) | Usage | Source |
|-----------|------------------|-------|--------|
| 0dp | #121212 | Background | [Material Design](https://codelabs.developers.google.com/codelabs/design-material-darktheme) |
| 1dp | #1E1E1E | Cards, sheets | Material |
| 2dp | #222222 | Menus | Material |
| 4dp | #272727 | App bars | Material |
| 8dp | #2E2E2E | Dialogs | Material |
| 16dp | #363636 | Navigation drawer | Material |

**Règle:** Plus élevé = plus clair (inverse du light mode)

---

### 95. Text Colors Dark Mode

| Type | Opacity/Color | Source |
|------|---------------|--------|
| Primary | #FFF at 87% (ou #E0E0E0) | [Toptal](https://www.toptal.com/designers/ui/dark-ui-design) |
| Secondary | #FFF at 60% (ou #A0A0A0) | Material |
| Disabled | #FFF at 38% | Material |
| Contrast ratio | Min 15.8:1 white on dark | [403 Design](https://www.fourzerothree.in/p/scalable-accessible-dark-mode) |

**Règle:** Jamais pure white (#FFF) sur pure black (#000) - trop harsh

---

### 96. Dark Mode Implementation

| Aspect | Méthode | Source |
|--------|---------|--------|
| Detection | `prefers-color-scheme: dark` | [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme) |
| Toggle | Class `.dark-mode` + localStorage | Standard |
| Transition | 300ms pour éviter flash | [UI Deploy](https://ui-deploy.com/blog/complete-dark-mode-design-guide-ui-patterns-and-implementation-best-practices-2025) |
| Options | Light / Dark / System | User choice |

**Code CSS:**
```css
@media (prefers-color-scheme: dark) {
  :root {
    --surface: #121212;
    --text-primary: rgba(255,255,255,0.87);
    --text-secondary: rgba(255,255,255,0.60);
  }
}

/* Smooth transition */
:root {
  transition: background-color 0.3s ease, color 0.3s ease;
}
```

**Checklist:**
- [ ] System preference detection
- [ ] Manual toggle avec persistence
- [ ] Transition smooth (pas de flash)
- [ ] Images/illustrations adaptées
- [ ] Accent colors ajustées (moins saturées)

---

## T. Modals & Overlays

### 97. Types de Modals

| Type | Use Case | Dismissal | Source |
|------|----------|-----------|--------|
| Alert/Dialog | Info critique, confirmation | Buttons only | [NN/g](https://www.nngroup.com/articles/bottom-sheet/) |
| Modal | Forms, contenu complexe | X, outside click | Standard |
| Bottom Sheet | Actions, filters (mobile) | Swipe down, X | [LogRocket](https://blog.logrocket.com/ux-design/bottom-sheets-optimized-ux/) |
| Drawer | Navigation, panels | X, outside click | Material |
| Popover | Info contextuelle, menus | Outside click, Esc | Standard |

---

### 98. Modal Sizing

| Size | Max-width | Use Case | Source |
|------|-----------|----------|--------|
| Small | 400px | Alerts, confirmations | [Mobbin](https://mobbin.com/glossary/bottom-sheet) |
| Medium | 600px | Forms, simple content | Standard |
| Large | 800px | Complex content | Standard |
| Fullscreen | 100% | Mobile default, complex forms | Convention |
| Max-height | 90vh | Avec scroll interne | UX requirement |

---

### 99. Bottom Sheets

| Platform | Detents | Source |
|----------|---------|--------|
| iOS | Small (~25%), Medium (~50%), Large (~90%) | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/sheets) |
| Android | Standard (content), Modal (blocks), Expanding | [Material](https://m3.material.io/components/bottom-sheets) |
| Dismiss | Swipe down (threshold ~100px), X button | [NN/g](https://www.nngroup.com/articles/bottom-sheet/) |

**Touch target minimum:** 44×44px (48×48px recommandé web.dev)

**Checklist:**
- [ ] Close affordance visible (X ou drag indicator)
- [ ] Swipe to dismiss supporté
- [ ] Back button pour dismiss (Android/web)
- [ ] Safe area padding en bas
- [ ] Focus trap si modal

---

### 100. Modal Accessibility

| Aspect | Règle | Source |
|--------|-------|--------|
| Focus trap | Tab cycle dans le modal | [WAI-ARIA](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/) |
| Initial focus | First interactive ou close button | WCAG |
| Escape | Ferme le modal | Convention |
| Return focus | Retour au trigger on close | WCAG |
| ARIA | `role="dialog"` + `aria-modal="true"` | WAI-ARIA |

**Code HTML:**
```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Modal Title</h2>
  <button class="close" aria-label="Close">×</button>
  <!-- Content -->
</div>
```

**Checklist:**
- [ ] Focus trap implémenté
- [ ] Escape key handler
- [ ] Return focus on close
- [ ] ARIA attributes corrects
- [ ] Screen reader annonce le titre

---

## U. Animations & Micro-interactions

### 101. Timing Standards

| Catégorie | Durée | Use Case | Source |
|-----------|-------|----------|--------|
| Instant | 50-100ms | Button press, toggle | [DesignerUp](https://designerup.co/blog/complete-guide-to-ui-animations-micro-interactions-and-tools/) |
| Fast | 100-200ms | Hover, focus, small reveals | [Primotech](https://primotech.com/ui-ux-evolution-2026-why-micro-interactions-and-motion-matter-more-than-ever/) |
| Medium | 200-400ms | Page transitions, modals | Standard |
| Slow | 400-700ms | Complex reveals, celebrations | Sparingly |

**Most UI actions: 150-250ms**

---

### 102. Easing Functions

| Easing | Usage | Source |
|--------|-------|--------|
| ease-out | Entering elements, modals opening | [Ruixen](https://www.ruixen.com/blog/ux-micro-interactions-for-devs) |
| ease-in | Exiting elements, modals closing | Standard |
| ease-in-out | Elements moving on screen | Standard |
| linear | Progress bars, continuous motion | Never for UI elements |
| spring | iOS-style bouncy feel | [Josh Comeau](https://www.joshwcomeau.com/animation/linear-timing-function/) |

**Code CSS:**
```css
/* iOS-like spring */
.spring-animation {
  transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

/* Subtle bounce */
.bounce-animation {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Standard ease-out */
.ease-out {
  transition: all 0.2s ease-out;
}
```

---

### 103. Common Micro-interactions

| Interaction | Animation | Source |
|-------------|-----------|--------|
| Button press | scale(0.95-0.98) + darken | [Vev](https://www.vev.design/blog/micro-interaction-examples/) |
| Toggle | Slide + color change | Standard |
| Checkbox | Scale bounce + checkmark draw | [AT](https://www.at.ge/2024/11/16/mastering-microinteractions-deep-technical-strategies-to-optimize-mobile-user-experience/) |
| Like/heart | Scale pop + color + particles | Twitter/Instagram |
| Delete | Fade + collapse | Standard |
| Reorder | Drag shadow + insertion indicator | Standard |

**Checklist:**
- [ ] Feedback < 100ms pour actions utilisateur
- [ ] Easing approprié (ease-out pour entrée)
- [ ] Reduced motion respecté
- [ ] Animations non-bloquantes

---

### 104. Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
  }
}
```

**Règles:**
- Fade OK, motion NOT OK
- Simplifier, pas supprimer
- Essential animations: réduire durée
- Respecter préférence système

---

## V. Onboarding

### 105. Types d'Onboarding

| Type | Efficacité | Source |
|------|-----------|--------|
| Feature tour (carousel) | Faible - souvent skippé | [Toptal](https://www.toptal.com/designers/product-design/guide-to-onboarding-ux) |
| Progressive | Haute - learn as you go | [Appcues](https://www.appcues.com/blog/user-onboarding-ui-ux-patterns) |
| Empty state | Haute - first-use prompts | [Chameleon](https://www.chameleon.io/blog/mobile-user-onboarding) |
| Interactive tutorial | Moyenne-Haute - guided first task | [Adapty](https://adapty.io/blog/mobile-app-onboarding/) |

**72% des users veulent onboarding < 60 secondes** - [Clutch 2017](https://www.appcues.com/blog/essential-guide-mobile-user-onboarding-ui-ux)

---

### 106. Permission Requests

| Timing | Règle | Source |
|--------|-------|--------|
| Contextual | Demander quand la feature est utilisée | [UserOnboard](https://www.useronboard.com/onboarding-ux-patterns/permission-priming/) |
| Pre-permission | Expliquer POURQUOI avant le system dialog | [Appcues](https://www.appcues.com/blog/mobile-permission-priming) |
| Benefits | Montrer ce que l'user gagne | [Adapty](https://adapty.io/blog/mobile-app-onboarding/) |
| Denied recovery | Expliquer comment activer dans Settings | Standard |

**Permission Timing:**
| Permission | Quand demander |
|------------|----------------|
| Push notifs | Après premier "value moment" |
| Location | Quand feature location utilisée |
| Camera | Quand user tap photo |
| Contacts | Quand user veut inviter |

**Checklist:**
- [ ] Jamais demander toutes les permissions au launch
- [ ] Pre-permission screen avant system dialog
- [ ] Bénéfice clair expliqué
- [ ] Handle "denied" gracefully

---

### 107. Empty States as Onboarding

| Élément | Description | Source |
|---------|-------------|--------|
| Title | Ce que cette zone fait | [NN/g](https://www.nngroup.com/articles/empty-state-interface-design/) |
| Description | Pourquoi c'est utile | Standard |
| CTA | Action claire pour commencer | UX requirement |
| Illustration | Optionnel, ajoute personnalité | Design polish |

**Exemple:** "No projects yet. Create your first project to get started. [+ New Project]"

**Checklist:**
- [ ] Titre clair (pas "Empty" ou "No data")
- [ ] Description de la valeur
- [ ] CTA visible et actionable
- [ ] Pas de culpabilisation

---

### 108. Progressive Disclosure

| Pattern | Description | Source |
|---------|-------------|--------|
| Coach marks | Tooltips pointant vers UI elements | [Appcues](https://www.appcues.com/blog/user-onboarding-ui-ux-patterns) |
| Hotspots | Indicators pulsing sur nouvelles features | [UX Team](https://www.uxteam.com/the-5-best-onboarding-flows-weve-seen-so-far-in-2024/) |
| Just-in-time | Tips au moment où l'action est pertinente | Best practice |

**Règles:**
- Un tip à la fois
- Dismissible (ne pas forcer)
- Remember dismissed state
- Re-accessible via Help menu

**Checklist:**
- [ ] Un élément à la fois
- [ ] Peut être skip/dismiss
- [ ] State persisté (pas re-montrer)
- [ ] Help accessible pour revoir


---

## W. Web Performance & Core Web Vitals

### 109. Core Web Vitals Metrics

| Metric | Good | Needs Improvement | Poor | What it measures | Source |
|--------|------|-------------------|------|------------------|--------|
| LCP (Largest Contentful Paint) | <= 2.5s | 2.5s - 4.0s | > 4.0s | Perceived load speed | [web.dev LCP](https://web.dev/articles/lcp) |
| CLS (Cumulative Layout Shift) | <= 0.1 | 0.1 - 0.25 | > 0.25 | Visual stability | [web.dev CLS](https://web.dev/articles/cls) |
| INP (Interaction to Next Paint) | <= 200ms | 200ms - 500ms | > 500ms | Input responsiveness | [web.dev INP](https://web.dev/articles/inp) |
| TTFB (Time to First Byte) | <= 800ms | 800ms - 1800ms | > 1800ms | Server responsiveness | [web.dev TTFB](https://web.dev/articles/ttfb) |
| FCP (First Contentful Paint) | <= 1.8s | 1.8s - 3.0s | > 3.0s | First visual feedback | [web.dev FCP](https://web.dev/articles/fcp) |

**LCP Elements typiques:**
- `<img>` dans le hero
- `<video>` poster image
- Bloc texte (`<h1>`, `<p>`) avec grande police
- Background image via `url()` CSS

**CLS Causes principales:**
- Images/iframes sans dimensions explicites
- Fonts qui swappent (FOIT -> FOUT)
- Contenu injecte dynamiquement au-dessus du viewport
- Animations qui triggent layout (top/left vs transform)

**INP Causes principales:**
- Event handlers lourds (> 200ms)
- Main thread bloque par JS
- Absence de `requestAnimationFrame` pour visual updates
- Hydration frameworks lente

**Checklist:**
- [ ] LCP element identifie et optimise (preload, priority)
- [ ] Toutes les images ont width/height explicites
- [ ] Pas de contenu injecte au-dessus du fold apres chargement
- [ ] Event handlers < 200ms, yield au main thread si lourd
- [ ] Mesure en conditions reelles (CrUX, RUM) pas seulement lab

---

### 110. Critical Rendering Path

| Etape | Optimisation | Impact | Source |
|-------|-------------|--------|--------|
| HTML parsing | Minimiser HTML, eviter nested tables | TTFB, FCP | [MDN Critical Rendering Path](https://developer.mozilla.org/en-US/docs/Web/Performance/Critical_rendering_path) |
| CSS blocking | Inline critical CSS, defer non-critical | FCP, LCP | [web.dev Extract Critical CSS](https://web.dev/articles/extract-critical-css) |
| JS blocking | `defer` ou `async`, pas de `<script>` dans `<head>` sans attribut | FCP, INP | [web.dev Render Blocking JS](https://web.dev/articles/render-blocking-resources) |
| Render tree | Eviter `display:none` sur gros arbres, utiliser `content-visibility` | LCP | [web.dev content-visibility](https://web.dev/articles/content-visibility) |

**Critical CSS Strategy:**
```html
<!-- Inline critical CSS dans <head> -->
<style>
  /* Only above-the-fold styles here (~14KB max) */
  .hero { ... }
  .nav { ... }
</style>

<!-- Defer non-critical CSS -->
<link rel="preload" href="/styles/main.css" as="style"
      onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="/styles/main.css"></noscript>
```

**Script Loading:**
```html
<!-- Render-blocking (avoid) -->
<script src="app.js"></script>

<!-- Deferred (recommended for most scripts) -->
<script src="app.js" defer></script>

<!-- Async (for independent scripts: analytics, ads) -->
<script src="analytics.js" async></script>

<!-- Module (deferred by default) -->
<script type="module" src="app.mjs"></script>
```

**Checklist:**
- [ ] Critical CSS inline (< 14KB compressed)
- [ ] Non-critical CSS deferred
- [ ] Tous les scripts avec `defer` ou `async`
- [ ] `content-visibility: auto` sur sections below-the-fold
- [ ] Preconnect aux origins tierces critiques

---

### 111. Font Loading Strategy

| Strategy | Behavior | Pros | Cons | Source |
|----------|----------|------|------|--------|
| `font-display: swap` | FOUT: fallback immediatement, swap quand pret | Texte visible immediatement | Layout shift au swap | [web.dev font-display](https://web.dev/articles/font-display) |
| `font-display: optional` | Fallback si font pas dans cache | Zero layout shift | Premiere visite sans custom font | [web.dev font-best-practices](https://web.dev/articles/font-best-practices) |
| `font-display: fallback` | Court FOIT (100ms), puis fallback, swap si < 3s | Compromis | Peut FOIT puis FOUT | MDN |
| `font-display: block` | FOIT (3s max) | Pas de FOUT | Texte invisible 3s | Eviter en general |

**Recommandation 2025:**
```css
@font-face {
  font-family: 'Brand';
  src: url('/fonts/brand.woff2') format('woff2');
  font-display: swap; /* ou optional pour 0 CLS */
  font-weight: 400;
  unicode-range: U+0000-00FF; /* Latin basique */
}
```

**Preload des fonts critiques:**
```html
<link rel="preload" href="/fonts/brand-400.woff2"
      as="font" type="font/woff2" crossorigin>
```

**Size-adjust pour reduire CLS:**
```css
@font-face {
  font-family: 'Brand Fallback';
  src: local('Arial');
  size-adjust: 105%;
  ascent-override: 95%;
  descent-override: 22%;
  line-gap-override: 0%;
}

body {
  font-family: 'Brand', 'Brand Fallback', sans-serif;
}
```

**Budget fonts:** Max 2 familles, 4 fichiers total, < 100KB total

**Checklist:**
- [ ] `font-display: swap` ou `optional` sur toutes les @font-face
- [ ] Preload de 1-2 fonts critiques max
- [ ] Format WOFF2 uniquement (support 97%+)
- [ ] `unicode-range` pour subsetter
- [ ] Fallback font avec `size-adjust` pour reduire CLS
- [ ] Max 4 fichiers font total

---

### 112. Image Optimization

| Format | Usage | Compression | Support 2025 | Source |
|--------|-------|-------------|-------------|--------|
| WebP | Photos, illustrations | 25-35% plus petit que JPEG | 97%+ | [caniuse WebP](https://caniuse.com/webp) |
| AVIF | Photos haute qualite | 50% plus petit que JPEG | 92%+ | [caniuse AVIF](https://caniuse.com/avif) |
| SVG | Icones, logos, illustrations simples | Vectoriel, infiniment scalable | 99%+ | Standard |
| PNG | Transparence, screenshots | Lossless, gros fichier | 100% | Standard |
| JPEG | Fallback photos | Bonne compression lossy | 100% | Standard |

**Responsive images:**
```html
<!-- Art direction avec <picture> -->
<picture>
  <source media="(min-width: 800px)"
          srcset="hero-desktop.avif" type="image/avif">
  <source media="(min-width: 800px)"
          srcset="hero-desktop.webp" type="image/webp">
  <source srcset="hero-mobile.avif" type="image/avif">
  <source srcset="hero-mobile.webp" type="image/webp">
  <img src="hero-mobile.jpg" alt="Description"
       width="800" height="400"
       loading="lazy" decoding="async">
</picture>

<!-- Resolution switching avec srcset -->
<img src="photo-400.jpg"
     srcset="photo-400.jpg 400w,
             photo-800.jpg 800w,
             photo-1200.jpg 1200w"
     sizes="(max-width: 600px) 100vw,
            (max-width: 1200px) 50vw,
            33vw"
     alt="Description"
     width="1200" height="800"
     loading="lazy" decoding="async">
```

**Priority hints (LCP image):**
```html
<!-- Hero image: NO lazy loading, high priority -->
<img src="hero.webp" alt="Hero"
     width="1200" height="600"
     fetchpriority="high"
     decoding="async">

<!-- Below fold: lazy + low priority -->
<img src="card.webp" alt="Card"
     width="400" height="300"
     loading="lazy"
     fetchpriority="low"
     decoding="async">
```

**Budget images:**
| Type | Taille max recommandee |
|------|----------------------|
| Hero image | < 200KB |
| Card thumbnail | < 50KB |
| Icon/logo | < 10KB (SVG preferred) |
| Background texture | < 100KB |
| Total page images | < 1MB |

**Checklist:**
- [ ] Format AVIF avec fallback WebP puis JPEG
- [ ] `width` et `height` sur toutes les `<img>` (evite CLS)
- [ ] `loading="lazy"` sur tout sauf LCP image
- [ ] `fetchpriority="high"` sur LCP image
- [ ] `decoding="async"` sur toutes les images
- [ ] `srcset` + `sizes` pour resolution switching
- [ ] Budget: hero < 200KB, total page < 1MB

---

### 113. Code Splitting & Bundle

| Technique | Quand utiliser | Impact | Source |
|-----------|---------------|--------|--------|
| Route-based splitting | Chaque page = chunk separe | LCP, TTI | [web.dev Code Splitting](https://web.dev/articles/reduce-javascript-payloads-with-code-splitting) |
| Component-based lazy | Modals, tabs, drawers non visibles au load | TTI, INP | React.lazy / dynamic import |
| Vendor chunk | Libraries stables (React, lodash) = chunk separe avec long cache | Cache hit ratio | Webpack/Vite config |
| Tree shaking | Eliminer dead code | Bundle size | [MDN Tree Shaking](https://developer.mozilla.org/en-US/docs/Glossary/Tree_shaking) |

**Dynamic import pattern:**
```javascript
// Route-based (React)
const Dashboard = React.lazy(() => import('./Dashboard'));

// Event-based (any framework)
button.addEventListener('click', async () => {
  const { openModal } = await import('./heavy-modal.js');
  openModal();
});

// Intersection Observer based
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      import('./chart-component.js');
      observer.unobserve(entry.target);
    }
  });
});
```

**Performance budgets:**
| Metric | Budget | Source |
|--------|--------|--------|
| Total JS (compressed) | < 200KB | [web.dev Performance Budgets](https://web.dev/articles/performance-budgets-101) |
| Total CSS (compressed) | < 50KB | Best practice |
| Total page weight | < 1.5MB | HTTP Archive median |
| Main bundle | < 100KB | Best practice |
| Third-party JS | < 100KB | web.dev |

**Checklist:**
- [ ] Route-based code splitting actif
- [ ] Components lourds lazy-loaded (modals, charts, editors)
- [ ] Vendor chunk separe avec long cache (1 an)
- [ ] Tree shaking actif (ESM imports, sideEffects: false)
- [ ] Bundle analyzer en CI (webpack-bundle-analyzer, source-map-explorer)
- [ ] Budget JS < 200KB compressed

---

### 114. Service Workers & Caching

| Strategie | Pattern | Usage | Source |
|-----------|---------|-------|--------|
| Cache First | Cache -> Network (fallback) | Assets statiques (fonts, images, CSS) | [web.dev Offline Cookbook](https://web.dev/articles/offline-cookbook) |
| Network First | Network -> Cache (fallback) | API data, pages dynamiques | web.dev |
| Stale While Revalidate | Cache (immediate) + Network (update cache) | Contenu semi-dynamique | web.dev |
| Network Only | Network uniquement | Transactions, auth | web.dev |
| Cache Only | Cache uniquement | Assets versionnes, app shell | web.dev |

**Cache headers recommandes:**
| Resource | Cache-Control | Pourquoi |
|----------|--------------|----------|
| HTML | `no-cache` ou `max-age=0, must-revalidate` | Toujours frais |
| CSS/JS (hashed) | `max-age=31536000, immutable` | Nom change si contenu change |
| Fonts | `max-age=31536000, immutable` | Rarement change |
| Images | `max-age=86400` (1 jour) ou `31536000` si hashed | Depende du use case |
| API responses | `no-store` ou `max-age=60` | Donnees dynamiques |

**Checklist:**
- [ ] Service worker enregistre avec bon scope
- [ ] Strategie cache appropriee par type de ressource
- [ ] Versionning des caches (supprimer anciens dans `activate`)
- [ ] Cache headers serveur coherents avec SW strategy
- [ ] Fallback offline page pour navigation requests

---

### 115. Above-the-Fold & Performance Budget

**Regle des 14KB:**
- Le premier round-trip TCP envoie ~14KB (10 TCP packets)
- Le critical CSS + HTML inline doit tenir dans ces 14KB
- Tout ce qui est au-dessus du fold doit charger sans round-trip supplementaire

**Above-the-fold checklist:**
| Element | Requirement |
|---------|------------|
| Hero image | `fetchpriority="high"`, preload si background-image |
| Navigation | Inline CSS, pas de JS pour render initial |
| CTA principal | Visible sans JS |
| Custom font | Preload, `font-display: swap` |
| Third-party scripts | Jamais dans le critical path |

**Performance budget template:**
| Category | Budget | Measurement |
|----------|--------|-------------|
| LCP | < 2.5s | Field data (CrUX) |
| CLS | < 0.1 | Field data |
| INP | < 200ms | Field data |
| Total page weight | < 1.5MB | Lighthouse |
| JS execution time | < 2s | Lighthouse |
| Number of requests | < 50 | DevTools Network |
| Time to Interactive | < 3.8s | Lighthouse |

**Checklist:**
- [ ] Critical resources identified et preloaded
- [ ] Performance budget documente et en CI
- [ ] Lighthouse score > 90 sur toutes categories
- [ ] Real User Monitoring (RUM) en place
- [ ] Budget alerts si regression > 10%

---

## X. Progressive Web Apps (PWA)

### 116. Web App Manifest

```json
{
  "name": "Infernal Wheel - Cigarette Tracker",
  "short_name": "Infernal Wheel",
  "description": "Track and reduce your smoking habits",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "orientation": "portrait",
  "theme_color": "#1a1a2e",
  "background_color": "#1a1a2e",
  "icons": [
    { "src": "/icons/192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/icons/maskable-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ],
  "screenshots": [
    { "src": "/screenshots/home.png", "sizes": "1080x1920", "type": "image/png", "form_factor": "narrow" }
  ],
  "shortcuts": [
    { "name": "Log Cigarette", "url": "/log", "icons": [{ "src": "/icons/log-96.png", "sizes": "96x96" }] },
    { "name": "View Stats", "url": "/stats", "icons": [{ "src": "/icons/stats-96.png", "sizes": "96x96" }] }
  ],
  "categories": ["health", "lifestyle"]
}
```

| Propriete | Valeur | Notes | Source |
|-----------|--------|-------|--------|
| `display` | `standalone` | Pas de barre navigateur, comme app native | [MDN Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest) |
| `display` | `minimal-ui` | Barre minimale (back, reload) | MDN |
| `display` | `fullscreen` | Plein ecran (jeux) | MDN |
| `display` | `browser` | Tab navigateur normal | MDN |
| `theme_color` | Hex color | Barre status sur mobile, title bar desktop | MDN |
| `background_color` | Hex color | Splash screen avant CSS charge | MDN |
| Icons maskable | Safe zone = cercle central 80% | Padding interne pour adaptive icons Android | [web.dev Maskable Icons](https://web.dev/articles/maskable-icon) |

**Checklist:**
- [ ] `name` (< 45 chars) et `short_name` (< 12 chars) definis
- [ ] Icons: 192px + 512px + maskable version
- [ ] `display: standalone` pour experience app-like
- [ ] `theme_color` et `background_color` coherents avec branding
- [ ] `start_url` pointe vers la page d'accueil logique
- [ ] Screenshots pour richer install UI (Chrome 120+)

---

### 117. Service Worker Lifecycle

| Phase | Event | Action typique | Source |
|-------|-------|---------------|--------|
| Registration | `navigator.serviceWorker.register()` | Enregistrer le SW avec bon scope | [MDN Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) |
| Install | `install` event | Pre-cache app shell et assets critiques | web.dev |
| Wait | Waiting state | Nouveau SW attend que ancien soit release | web.dev |
| Activate | `activate` event | Nettoyer anciens caches | web.dev |
| Fetch | `fetch` event | Intercepter requetes, servir depuis cache | web.dev |
| Update | Browser check ~24h | Byte comparison du SW file | web.dev |

**Registration pattern:**
```javascript
// Register only after page load (don't compete with critical resources)
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then(reg => console.log('SW registered:', reg.scope))
      .catch(err => console.error('SW failed:', err));
  });
}
```

**Update UX pattern:**
```javascript
// Detect update and prompt user
navigator.serviceWorker.register('/sw.js').then(reg => {
  reg.addEventListener('updatefound', () => {
    const newSW = reg.installing;
    newSW.addEventListener('statechange', () => {
      if (newSW.state === 'activated') {
        // Show "New version available" banner
        showUpdateBanner(() => window.location.reload());
      }
    });
  });
});
```

**Checklist:**
- [ ] SW enregistre apres `window.load` (pas blocking)
- [ ] App shell pre-cached dans `install`
- [ ] Anciens caches nettoyes dans `activate`
- [ ] Update banner UX (pas de reload force)
- [ ] Scope correct (`/` pour whole-site PWA)

---

### 118. Install Prompt UX

**`beforeinstallprompt` pattern:**
```javascript
let deferredPrompt;

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault(); // Don't show browser default
  deferredPrompt = e;
  showInstallButton(); // Show custom UI
});

installButton.addEventListener('click', async () => {
  deferredPrompt.prompt();
  const { outcome } = await deferredPrompt.userChoice;
  console.log(outcome); // 'accepted' or 'dismissed'
  deferredPrompt = null;
  hideInstallButton();
});
```

| Regle | Detail | Source |
|-------|--------|--------|
| Ne pas montrer immediatement | Attendre engagement (2+ pages, 30s+, action significative) | [web.dev Install Criteria](https://web.dev/articles/install-criteria) |
| Custom UI > browser prompt | Expliquer la valeur avant de prompter | UX best practice |
| Respecter le dismiss | Ne pas re-prompter pendant 2+ semaines | [web.dev Promote Install](https://web.dev/articles/promote-install) |
| Post-install | Rediriger vers experience standalone, confirmer installation | web.dev |

**Install criteria Chrome 2025:**
- HTTPS (ou localhost)
- Web App Manifest valide (name, icons 192+512, start_url, display)
- Service Worker avec `fetch` event handler
- User engagement (visite multiple ou interaction)

**Checklist:**
- [ ] `beforeinstallprompt` intercepte et differe
- [ ] UI custom explique la valeur ("Access offline, faster loading")
- [ ] Prompter apres engagement, pas au premier load
- [ ] Respecter dismiss (cooldown 2+ semaines)
- [ ] Tracker outcome (accepted/dismissed) en analytics
- [ ] Post-install UX (welcome, standalone features)

---

### 119. Offline-First Patterns

| Pattern | Description | Usage | Source |
|---------|-------------|-------|--------|
| App Shell | HTML/CSS/JS shell cached, contenu dynamique via network | SPA, apps interactives | [web.dev App Shell](https://web.dev/articles/app-shell) |
| Offline page | Page fallback quand navigation echoue | Sites de contenu | web.dev |
| Offline queue | Actions mises en queue, sync quand online | Forms, tracking, CRUD | Background Sync API |
| Cache then network | Afficher cache, mettre a jour avec network en parallele | Feeds, dashboards | web.dev |

**Offline indicator UX:**
- Afficher banner subtil quand offline (pas modal bloquant)
- Indiquer quelles features sont disponibles offline
- Queue les actions et confirmer ("Will sync when online")
- Ne pas cacher les actions -- les desactiver avec explication

**Offline page minimale:**
```html
<!-- /offline.html - pre-cached in SW install -->
<h1>You're offline</h1>
<p>Check your connection. Your data is safe and will sync when you're back online.</p>
<button onclick="location.reload()">Try again</button>
```

**Checklist:**
- [ ] App shell ou offline page pre-cached
- [ ] Banner offline subtil (pas bloquant)
- [ ] Actions queued pour sync ulterieur
- [ ] Donnees locales preservees (IndexedDB/localStorage)
- [ ] Navigation events interceptes avec fallback offline

---

### 120. Push Notifications Web

| Aspect | Regle | Anti-pattern | Source |
|--------|-------|-------------|--------|
| Timing | Demander apres action pertinente (ex: apres premier log) | Permission au premier load | [web.dev Notifications](https://web.dev/articles/push-notifications-overview) |
| Explication | Expliquer la valeur avant le prompt natif | Prompt natif brut sans contexte | [NN/g Permission Requests](https://www.nngroup.com/articles/permission-requests/) |
| Frequence | Max 1-3/jour pour engagement, 1/semaine pour re-engagement | Spam quotidien | Best practice |
| Contenu | Actionable, personnalise, timely | Generique, promotionnel | web.dev |

**Double opt-in pattern (recommande):**
```javascript
// Step 1: Custom UI explaining value
showNotificationExplainer({
  title: "Stay on track",
  body: "Get reminders when it's time to check your progress",
  cta: "Enable notifications"
});

// Step 2: Only THEN trigger native permission
async function requestPermission() {
  const permission = await Notification.requestPermission();
  if (permission === 'granted') {
    const registration = await navigator.serviceWorker.ready;
    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY)
    });
    // Send subscription to server
    await fetch('/api/push/subscribe', {
      method: 'POST',
      body: JSON.stringify(subscription)
    });
  }
}
```

**Notification categories pour cessation app:**
| Type | Timing | Contenu |
|------|--------|---------|
| Progress | Quotidien 9h | "Day 5! You've saved X EUR and Y hours" |
| Craving support | On-demand trigger | "Craving? Try the 4-7-8 breathing exercise" |
| Milestone | Achievement events | "1 week smoke-free! Your lungs are recovering" |
| Re-engagement | 3 jours inactif | "We miss you. Check your progress" |

**Checklist:**
- [ ] Double opt-in (custom UI puis prompt natif)
- [ ] Timing: apres engagement, pas au premier load
- [ ] Contenu actionable et personnalise
- [ ] Frequence raisonnable (1-3/jour max)
- [ ] Easy opt-out dans settings
- [ ] VAPID keys configurees cote serveur

---

### 121. Web Share & Badges

**Web Share API:**
```javascript
async function shareProgress(stats) {
  if (navigator.share) {
    await navigator.share({
      title: 'My Smoke-Free Progress',
      text: `${stats.days} days smoke-free! Saved ${stats.money} EUR.`,
      url: 'https://infernal-wheel.app/share'
    });
  } else {
    // Fallback: copy link or show share buttons
    copyToClipboard('https://infernal-wheel.app/share');
  }
}
```

**App Badge API:**
```javascript
// Set badge (e.g., unread notifications count)
navigator.setAppBadge(3);

// Clear badge
navigator.clearAppBadge();
```

| API | Support 2025 | Fallback | Source |
|-----|-------------|----------|--------|
| Web Share | 95%+ mobile, 80% desktop | Custom share buttons | [MDN Web Share](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share) |
| Web Share (files) | 80%+ mobile | File download link | MDN |
| App Badge | 85%+ | Favicon with count overlay | [MDN setAppBadge](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/setAppBadge) |

**Checklist:**
- [ ] Feature detection avant utilisation (`if (navigator.share)`)
- [ ] Fallback fonctionnel (copy link, share buttons)
- [ ] Badge count reflete etat reel (reset apres lecture)
- [ ] Share content optimise (titre court, URL canonique)

---

## Y. Responsive Design Advanced

### 122. Container Queries

| Aspect | Syntaxe | Usage | Source |
|--------|---------|-------|--------|
| Container definition | `container-type: inline-size` | Definir element comme container | [MDN Container Queries](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_queries) |
| Container query | `@container (min-width: 400px)` | Adapter layout au container | MDN |
| Named container | `container-name: card` | Cibler container specifique | MDN |
| Support 2025 | 93%+ | Progressivement adoptable | [caniuse Container Queries](https://caniuse.com/css-container-queries) |

**Container queries vs Media queries:**
| Critere | Media Query | Container Query |
|---------|------------|----------------|
| Reference | Viewport | Parent container |
| Composabilite | Composant depend du contexte page | Composant autonome |
| Reusability | Faible (breakpoints globaux) | Haute (breakpoints locaux) |
| Use case | Page layout | Component layout |

```css
/* Define container */
.card-container {
  container-type: inline-size;
  container-name: card;
}

/* Component adapts to its container, not viewport */
@container card (min-width: 400px) {
  .card {
    display: grid;
    grid-template-columns: 200px 1fr;
    gap: 16px;
  }
}

@container card (max-width: 399px) {
  .card {
    display: flex;
    flex-direction: column;
  }
  .card img {
    aspect-ratio: 16/9;
    width: 100%;
  }
}
```

**Checklist:**
- [ ] Components reusables utilisent container queries
- [ ] Page layout utilise media queries
- [ ] `container-type: inline-size` (pas `size` sauf besoin height)
- [ ] Fallback media query pour navigateurs < 2023

---

### 123. CSS Grid Advanced

| Pattern | Code | Usage | Source |
|---------|------|-------|--------|
| Auto-fill responsive | `grid-template-columns: repeat(auto-fill, minmax(250px, 1fr))` | Card grids responsives sans media queries | [MDN CSS Grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout) |
| Auto-fit responsive | `repeat(auto-fit, minmax(250px, 1fr))` | Comme auto-fill mais colonnes s'etirent | MDN |
| Subgrid | `grid-template-rows: subgrid` | Aligner enfants sur grille parente | [MDN Subgrid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout/Subgrid) |
| Named areas | `grid-template-areas` | Layouts complexes lisibles | MDN |

**Auto-fill vs auto-fit:**
```css
/* auto-fill: keeps empty tracks (columns don't stretch) */
.grid-fill {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}

/* auto-fit: collapses empty tracks (columns stretch to fill) */
.grid-fit {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}
```

**Subgrid (support 93%+ en 2025):**
```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.card {
  display: grid;
  grid-template-rows: subgrid; /* Align card internals to parent grid */
  grid-row: span 3; /* header, body, footer */
}
```

**Named areas pour layout page:**
```css
.page {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar main"
    "footer footer";
  grid-template-columns: 280px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;
}

@media (max-width: 768px) {
  .page {
    grid-template-areas:
      "header"
      "main"
      "footer";
    grid-template-columns: 1fr;
  }
}
```

**Checklist:**
- [ ] `auto-fill` / `auto-fit` + `minmax()` pour grids responsives sans breakpoints
- [ ] Subgrid pour aligner contenu entre cards
- [ ] `gap` au lieu de margins pour espacement grille
- [ ] `min-height: 100dvh` pour full-height layouts (pas `vh`)

---

### 124. Fluid Typography

| Technique | Code | Source |
|-----------|------|--------|
| `clamp()` | `font-size: clamp(1rem, 0.5rem + 1.5vw, 2rem)` | [MDN clamp()](https://developer.mozilla.org/en-US/docs/Web/CSS/clamp) |
| Min readable | 16px minimum sur mobile | WCAG, Apple HIG |
| Scale ratio | 1.2 (minor third) mobile, 1.25 (major third) desktop | [Type Scale](https://typescale.com/) |

**Fluid type scale:**
```css
:root {
  /* Body text: 16px @ 320px -> 18px @ 1200px */
  --fs-body: clamp(1rem, 0.955rem + 0.227vw, 1.125rem);

  /* H3: 20px @ 320px -> 28px @ 1200px */
  --fs-h3: clamp(1.25rem, 1.023rem + 0.909vw, 1.75rem);

  /* H2: 24px @ 320px -> 36px @ 1200px */
  --fs-h2: clamp(1.5rem, 1.159rem + 1.364vw, 2.25rem);

  /* H1: 30px @ 320px -> 48px @ 1200px */
  --fs-h1: clamp(1.875rem, 1.364rem + 2.045vw, 3rem);

  /* Display: 36px @ 320px -> 64px @ 1200px */
  --fs-display: clamp(2.25rem, 1.455rem + 3.182vw, 4rem);
}
```

**Formule clamp:**
```
clamp(min, preferred, max)
preferred = min + (max - min) * (100vw - minViewport) / (maxViewport - minViewport)
```

**Fluid spacing (meme principe):**
```css
:root {
  --space-s: clamp(0.75rem, 0.614rem + 0.545vw, 1rem);
  --space-m: clamp(1rem, 0.773rem + 0.909vw, 1.5rem);
  --space-l: clamp(1.5rem, 1.091rem + 1.636vw, 2.5rem);
  --space-xl: clamp(2rem, 1.364rem + 2.545vw, 4rem);
}
```

**Checklist:**
- [ ] `clamp()` pour toutes les tailles de texte (pas de media queries pour font-size)
- [ ] Minimum 16px (1rem) pour body text
- [ ] Tester a 320px et 1440px+ pour verifier les extremes
- [ ] Spacing fluid pour coherence avec typography fluid
- [ ] `line-height` proportionnel (1.5 body, 1.1-1.2 headings)

---

### 125. Breakpoint Strategy

| Approche | Description | Quand utiliser | Source |
|----------|-------------|---------------|--------|
| Content-based | Breakpoints ou le contenu casse | Composants, sites contenu | [NN/g Responsive Design](https://www.nngroup.com/articles/responsive-web-design-definition/) |
| Device-based | Breakpoints fixes (320, 768, 1024, 1440) | E-commerce, apps business | Convention |

**Breakpoints recommandes 2025:**
| Token | Value | Cible |
|-------|-------|-------|
| `--bp-sm` | 480px | Petits mobiles -> grands mobiles |
| `--bp-md` | 768px | Mobile -> tablette |
| `--bp-lg` | 1024px | Tablette -> desktop |
| `--bp-xl` | 1280px | Desktop -> grand ecran |
| `--bp-2xl` | 1536px | Grand ecran -> ultra-wide |

**Mobile-first (recommande):**
```css
/* Base styles = mobile */
.grid { display: flex; flex-direction: column; }

/* Progressive enhancement */
@media (min-width: 768px) {
  .grid { flex-direction: row; }
}

@media (min-width: 1024px) {
  .grid { max-width: 1120px; margin-inline: auto; }
}
```

**Touch vs pointer detection:**
```css
/* Coarse pointer = touch (mobile, tablet) */
@media (pointer: coarse) {
  .button { min-height: 48px; padding: 12px 24px; }
  .link { padding: 8px; } /* Larger tap target */
}

/* Fine pointer = mouse */
@media (pointer: fine) {
  .button { min-height: 36px; padding: 8px 16px; }
}

/* Hover capability */
@media (hover: hover) {
  .card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
}

@media (hover: none) {
  /* No hover effects on touch devices */
  .card { box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
}
```

**Checklist:**
- [ ] Mobile-first (`min-width`) par defaut
- [ ] Breakpoints bases sur le contenu, pas les devices
- [ ] `pointer: coarse` pour agrandir tap targets sur touch
- [ ] `hover: hover` pour limiter hover effects au mouse
- [ ] Tester sur vrais devices (pas seulement DevTools resize)
- [ ] Max 4-5 breakpoints pour maintenabilite

---

### 126. Responsive Tables & Images

**Responsive tables:**
| Pattern | Quand utiliser | Technique |
|---------|---------------|-----------|
| Scroll horizontal | Tables larges, donnees tabulaires | `overflow-x: auto` wrapper |
| Stack cards | Tables simples, < 5 colonnes | `display: block` sur `<tr>` en mobile |
| Hide columns | Colonnes secondaires | `display: none` + "Show more" toggle |
| Fixed first column | Comparaison, spreadsheet-like | `position: sticky; left: 0` |

```css
/* Scroll wrapper */
.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

/* Stack pattern */
@media (max-width: 600px) {
  table, thead, tbody, tr, td, th {
    display: block;
  }
  thead { display: none; }
  td::before {
    content: attr(data-label);
    font-weight: 600;
    display: block;
    margin-bottom: 4px;
  }
}
```

**Responsive images (art direction):**
```html
<picture>
  <!-- Crop different for mobile vs desktop -->
  <source media="(max-width: 600px)"
          srcset="hero-portrait.avif 600w"
          type="image/avif">
  <source media="(min-width: 601px)"
          srcset="hero-landscape.avif 1200w"
          type="image/avif">
  <img src="hero-landscape.jpg" alt="Hero"
       width="1200" height="600">
</picture>
```

**Checklist:**
- [ ] Tables dans wrapper `overflow-x: auto`
- [ ] Tables complexes: stack ou hide columns sur mobile
- [ ] Images: `<picture>` pour art direction, `srcset` pour resolution
- [ ] `object-fit: cover` pour images dans containers fixes

---

## Z. Authentication & Security UX

### 127. Login Form UX

| Pattern | Regle | Anti-pattern | Source |
|---------|-------|-------------|--------|
| Email field | `type="email"`, `autocomplete="email"` | `type="text"` pour email | [web.dev Sign-in Form](https://web.dev/articles/sign-in-form-best-practices) |
| Password field | `autocomplete="current-password"`, show/hide toggle | Disable paste, no toggle | web.dev |
| Social login | OAuth buttons au-dessus du form (Google, Apple, Facebook) | Trop de providers (> 4), faux boutons | [NN/g Social Login](https://www.nngroup.com/articles/social-login/) |
| Magic link | Email a link, click to login, no password | Lent si email est lent | Best practice |
| Passkeys | WebAuthn, biometric, FIDO2 | Seule option sans fallback | [web.dev Passkeys](https://web.dev/articles/passkey-registration) |

**Login form optimal:**
```html
<form action="/login" method="POST">
  <label for="email">Email</label>
  <input id="email" type="email" name="email"
         autocomplete="email" required
         inputmode="email">

  <label for="password">Password</label>
  <div class="password-field">
    <input id="password" type="password" name="password"
           autocomplete="current-password" required
           minlength="8">
    <button type="button" aria-label="Show password"
            onclick="togglePassword()">Show</button>
  </div>

  <a href="/forgot-password">Forgot password?</a>
  <button type="submit">Sign in</button>
</form>

<!-- Social login -->
<div class="social-login" role="group" aria-label="Sign in with">
  <button class="google-signin">Continue with Google</button>
  <button class="apple-signin">Continue with Apple</button>
</div>
```

**Autocomplete values essentiels:**
| Field | `autocomplete` value |
|-------|---------------------|
| Email | `email` |
| Password (login) | `current-password` |
| Password (register) | `new-password` |
| Name | `name` |
| Phone | `tel` |
| OTP code | `one-time-code` |

**Checklist:**
- [ ] `autocomplete` correct sur chaque champ
- [ ] Password show/hide toggle
- [ ] Paste autorise dans les champs password
- [ ] "Forgot password?" visible sans scroll
- [ ] Social login en haut, email/password en bas
- [ ] Max 3-4 social providers
- [ ] Error message ne revele pas si le compte existe

---

### 128. Registration Flow

| Pattern | Regle | Source |
|---------|-------|--------|
| Progressive profiling | Minimum au signup (email + password), reste plus tard | [NN/g Streamlining](https://www.nngroup.com/articles/streamlining-sign-up-flow/) |
| Password requirements | Afficher en temps reel, pas apres submit | [Baymard Password](https://baymard.com/blog/password-requirements) |
| Email verification | Envoyer verification, permettre usage avant confirm | Best practice |
| Username | Verifier disponibilite en temps reel (debounce 300ms) | Convention |

**Password strength UI:**
```html
<div class="password-requirements" aria-live="polite">
  <p id="req-length" class="requirement">
    <span aria-hidden="true">x</span> At least 8 characters
  </p>
  <p id="req-upper" class="requirement">
    <span aria-hidden="true">x</span> One uppercase letter
  </p>
  <p id="req-number" class="requirement">
    <span aria-hidden="true">x</span> One number
  </p>
</div>

<!-- Strength meter -->
<meter min="0" max="4" value="2"
       aria-label="Password strength: medium">
  Medium
</meter>
```

**Recommended fields par etape:**
| Etape | Champs | Pourquoi |
|-------|--------|----------|
| Signup | Email + password (ou social) | Minimum friction |
| Post-signup | Nom, objectif (quitter, reduire) | Personnalisation |
| First use | Habitudes actuelles (cig/jour, marque) | Donnees essentielles |
| Later | Photo profil, preferences notifications | Engagement |

**Checklist:**
- [ ] 2-3 champs max au signup initial
- [ ] Password requirements visibles en temps reel
- [ ] Strength meter (pas juste pass/fail)
- [ ] `autocomplete="new-password"` pour signup
- [ ] Email verification non-bloquante
- [ ] Progressive profiling apres signup

---

### 129. 2FA / MFA UX

| Methode | Securite | UX Friction | Recommandation | Source |
|---------|----------|-------------|----------------|--------|
| SMS OTP | Moyenne (SIM swap) | Faible | Acceptable, pas ideal | [NIST 800-63B](https://pages.nist.gov/800-63-3/sp800-63b.html) |
| TOTP app (Google Auth) | Haute | Moyenne | Recommande | NIST |
| Security key (FIDO2) | Tres haute | Moyenne | Recommande pour high-value | NIST |
| Push notification | Haute | Faible | Bon compromis UX/security | Best practice |
| Passkey | Tres haute | Tres faible | Future default | [web.dev Passkeys](https://web.dev/articles/passkey-registration) |

**OTP input pattern:**
```html
<label for="otp">Enter the 6-digit code</label>
<input id="otp" type="text"
       inputmode="numeric"
       autocomplete="one-time-code"
       pattern="[0-9]{6}"
       maxlength="6"
       aria-describedby="otp-help">
<p id="otp-help">Code sent to j***@email.com. Expires in 10 minutes.</p>

<!-- Resend with cooldown -->
<button id="resend" disabled>Resend code (60s)</button>
```

| Element UX | Regle |
|-----------|-------|
| Auto-focus | Focus sur le premier champ OTP au load |
| Auto-submit | Soumettre automatiquement apres 6 digits |
| Resend cooldown | 60s avant de pouvoir renvoyer |
| Expiration | Afficher countdown (10 min typique) |
| Recovery | "Lost access? Use recovery code" visible |
| Remember device | "Trust this device for 30 days" option |

**Checklist:**
- [ ] `inputmode="numeric"` pour clavier numerique mobile
- [ ] `autocomplete="one-time-code"` pour autofill SMS
- [ ] Auto-submit apres saisie complete
- [ ] Resend avec cooldown (60s)
- [ ] Recovery codes fournis a l'activation 2FA
- [ ] "Trust this device" option

---

### 130. Session Management UX

| Pattern | Valeur | Source |
|---------|--------|--------|
| Session timeout warning | 2 minutes avant expiration, modal "Extend session?" | [WCAG 2.2.1 Timing Adjustable](https://www.w3.org/WAI/WCAG22/Understanding/timing-adjustable.html) |
| Session duration | 30 min inactive (sensible), 24h (standard), 30 jours (remember me) | Convention |
| Remember me | Token long-lived dans cookie HttpOnly Secure SameSite=Strict | Security best practice |
| Concurrent sessions | Montrer liste des sessions actives, permettre revocation | UX + Security |

**Timeout warning pattern:**
```javascript
const SESSION_TIMEOUT = 30 * 60 * 1000; // 30 min
const WARNING_BEFORE = 2 * 60 * 1000;   // 2 min before

let timeoutId = setTimeout(() => {
  showModal({
    title: "Session expiring",
    body: "Your session will expire in 2 minutes. Extend?",
    actions: [
      { label: "Stay signed in", action: extendSession },
      { label: "Sign out", action: logout }
    ]
  });
}, SESSION_TIMEOUT - WARNING_BEFORE);

// Reset on user activity
['click', 'keydown', 'scroll'].forEach(event => {
  document.addEventListener(event, () => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(showWarning, SESSION_TIMEOUT - WARNING_BEFORE);
  }, { passive: true });
});
```

**Checklist:**
- [ ] Warning modal 2 min avant expiration (WCAG requis)
- [ ] "Stay signed in" button reset le timer
- [ ] "Remember me" = 30 jours, cookie secure
- [ ] Sessions actives listees dans settings
- [ ] Logout revoke le token (pas juste delete cookie)

---

### 131. Passkeys & WebAuthn

| Aspect | Detail | Source |
|--------|--------|--------|
| Registration | `navigator.credentials.create()` avec PublicKeyCredentialCreationOptions | [web.dev Passkeys](https://web.dev/articles/passkey-registration) |
| Authentication | `navigator.credentials.get()` avec PublicKeyCredentialRequestOptions | web.dev |
| Support 2025 | 90%+ (Chrome, Safari, Firefox, Edge) | [passkeys.dev](https://passkeys.dev/device-support/) |
| UX avantage | Pas de mot de passe, biometrique ou PIN, resistant au phishing | FIDO Alliance |

**Passkey UX flow:**
1. User clicks "Create passkey" (post-login, settings, ou registration)
2. Browser/OS shows biometric prompt (fingerprint, face, PIN)
3. Passkey created and synced across devices (iCloud Keychain, Google Password Manager)
4. Next login: "Sign in with passkey" -> biometric -> done

**Recommandations:**
- Proposer passkey comme upgrade, pas remplacer password immediatement
- Montrer quels devices ont des passkeys dans settings
- Garder password comme fallback pendant transition
- Expliquer clairement ce qu'est un passkey ("Sign in with your fingerprint or face")

**Checklist:**
- [ ] Proposer creation passkey apres login reussi
- [ ] Fallback password toujours disponible
- [ ] Liste des passkeys dans account settings
- [ ] Revocation possible par device
- [ ] Copy claire ("Sign in with fingerprint" pas "WebAuthn")

---

## AA. E-commerce Patterns

### 132. Product Page Anatomy

| Element | Position | Regle | Source |
|---------|----------|-------|--------|
| Image gallery | Gauche (desktop), pleine largeur (mobile) | Min 4-5 images, zoom on hover, 1:1 ou 4:3 | [Baymard Product Page](https://baymard.com/blog/product-page-design) |
| Title + price | Droite (desktop), sous images (mobile) | Prix visible sans scroll | Baymard |
| Add to cart CTA | Sticky visible, couleur primaire | Toujours visible, meme au scroll | Baymard |
| Reviews summary | Pres du titre (stars + count) | "4.5 (238 reviews)" format | [NN/g Reviews](https://www.nngroup.com/articles/online-reviews/) |
| Variants | Pres du CTA (taille, couleur) | Swatches visuels, selection claire | Baymard |
| Description | Below fold, tabs ou accordion | Scannable, bullet points | Baymard |

**Prix display:**
| Pattern | Format | Quand |
|---------|--------|-------|
| Prix simple | 29.99 EUR | Standard |
| Prix barre | ~~39.99~~ 29.99 EUR (-25%) | Promotion |
| Prix /unite | 2.99 EUR/mois | Abonnement |
| Free | Gratuit / Free | Freemium |

**Checklist:**
- [ ] Images haute qualite, zoom, multiple angles
- [ ] Prix visible sans scroll
- [ ] CTA "Add to Cart" sticky en mobile
- [ ] Reviews score pres du titre
- [ ] Variants avec selection visuelle claire
- [ ] Stock status visible (si pertinent)

---

### 133. Cart UX

| Pattern | Usage | Avantage | Source |
|---------|-------|----------|--------|
| Mini-cart (dropdown) | Apres ajout, header hover | Pas de changement de page | [Baymard Cart](https://baymard.com/blog/cart-usability) |
| Sidebar cart | Slide-in depuis la droite | Voir cart sans quitter la page | E-commerce standard |
| Cart page | Page dediee | Vue complete, modifications | Baymard |
| Sticky cart bar | Barre en bas avec total + CTA | Rappel constant du panier | Mobile pattern |

**Cart best practices:**
| Element | Regle | Anti-pattern |
|---------|-------|-------------|
| Ajout feedback | Animation + mini-cart ouvert 3-5s | Redirect vers cart page |
| Quantite | +/- stepper, input editable | Dropdown select pour quantite |
| Supprimer | Icon X + confirmation (undo 5s) | Supprimer sans confirmation |
| Total | Sous-total visible, estimation shipping | Cacher frais jusqu'au checkout |
| Empty cart | CTA "Continue shopping", recommandations | Message vide sans action |

**Checklist:**
- [ ] Feedback visuel a l'ajout (animation, mini-cart)
- [ ] Modifier quantite sans recharger la page
- [ ] Undo sur suppression (pas confirm dialog)
- [ ] Sous-total toujours visible
- [ ] Estimation shipping avant checkout
- [ ] Cart persiste entre sessions (localStorage/server)

---

### 134. Checkout Funnel

| Etape | Champs essentiels | Optimisation | Source |
|-------|-------------------|-------------|--------|
| 1. Information | Email, nom, adresse | Autocomplete, address API | [Baymard Checkout](https://baymard.com/blog/checkout-usability) |
| 2. Shipping | Methode livraison | Default pre-selectionne, dates estimees | Baymard |
| 3. Payment | Card/PayPal/etc | One-click (Apple Pay, Google Pay) | Baymard |
| 4. Review | Recapitulatif | Editable, prix final clair | Baymard |

**Guest checkout (obligatoire):**
- 25% des abandons sont dus au forced account creation (Baymard)
- Pattern: checkout en guest, proposer creation compte APRES la commande
- "Save your info for next time? Create an account" avec password only

**Address autocomplete:**
```html
<input type="text" id="address"
       autocomplete="street-address"
       placeholder="Start typing your address...">
<!-- Use Google Places / Mapbox Autofill -->
```

**Payment form:**
```html
<input type="text" id="card-number"
       autocomplete="cc-number"
       inputmode="numeric"
       pattern="[0-9\s]{13,19}">
<input type="text" id="expiry"
       autocomplete="cc-exp"
       placeholder="MM/YY"
       inputmode="numeric">
<input type="text" id="cvc"
       autocomplete="cc-csc"
       inputmode="numeric"
       maxlength="4">
```

**Checkout conversion killers:**
| Cause | % abandon | Solution |
|-------|-----------|----------|
| Frais caches (shipping, taxes) | 48% | Afficher estimation tot |
| Forced account creation | 25% | Guest checkout |
| Processus trop long | 18% | Max 3-4 etapes |
| Trust (securite payment) | 17% | Badges SSL, logos payment |
| Erreurs formulaire | 12% | Validation inline temps reel |

**Checklist:**
- [ ] Guest checkout disponible
- [ ] Max 3-4 etapes
- [ ] Progress indicator visible
- [ ] Autocomplete sur tous les champs
- [ ] Frais totaux affiches avant paiement
- [ ] Apple Pay / Google Pay si possible
- [ ] Trust badges (SSL, payment logos)
- [ ] Order summary sticky en desktop

---

### 135. Pricing Page Design

| Element | Regle | Source |
|---------|-------|--------|
| Nombre de tiers | 3-4 max (Free, Pro, Enterprise) | [NN/g Pricing](https://www.nngroup.com/articles/pricing-page/) |
| Highlighted plan | Visuellement distinct (border, badge "Most Popular") | Convention |
| Comparison table | Features en lignes, plans en colonnes | Baymard |
| Toggle mensuel/annuel | Default annuel (afficher economie %) | SaaS standard |
| CTA hierarchy | Primary sur recommended, secondary sur others | Design best practice |

**Pricing table pattern:**
| Element | Free | Pro (recommended) | Enterprise |
|---------|------|-------------------|------------|
| Visual | Normal | Highlighted border + badge | Normal |
| CTA | "Get Started" (secondary) | "Start Free Trial" (primary) | "Contact Sales" (secondary) |
| Price | 0 EUR/mo | ~~19~~ 15 EUR/mo (billed annually) | Custom |

**Checklist:**
- [ ] 3-4 tiers max
- [ ] Plan recommande visuellement distinct
- [ ] Toggle mensuel/annuel avec % economie
- [ ] Features comparables dans un tableau
- [ ] CTA primaire sur plan recommande
- [ ] FAQ sous les prix

---

### 136. Order & Post-Purchase

| Phase | UX Element | Regle |
|-------|-----------|-------|
| Confirmation | Page + email | Numero commande, recapitulatif, ETA |
| Tracking | Status timeline | Etapes visuelles (ordered > shipped > delivered) |
| Returns | Self-service | Formulaire simple, label pre-paye |
| Wishlist | Save for later | Coeur/bookmark, accessible depuis profil |

**Order confirmation page:**
- Numero de commande prominent
- Recapitulatif articles + prix
- Adresse livraison
- Date estimee livraison
- CTA: "Track order" + "Continue shopping"
- Proposition creation compte (si guest)

**Checklist:**
- [ ] Email confirmation automatique
- [ ] Numero commande copie-able
- [ ] Tracking link dans email et account
- [ ] Retours en self-service
- [ ] Wishlist persistee (login) ou localStorage (guest)

---

## AB. Landing Pages & Marketing

### 137. Hero Section Patterns

| Type | Description | Quand utiliser | Source |
|------|-------------|---------------|--------|
| Headline + CTA + Image | Classique, efficace | SaaS, apps | [NN/g Above the Fold](https://www.nngroup.com/articles/scrolling-and-attention/) |
| Video background | Immersif, emotionnel | Branding, lifestyle | Use with caution |
| Split screen | Texte gauche, visuel droite | Product showcase | Convention |
| Full-screen hero | Impact maximal | Portfolio, luxury | Convention |
| Illustration | Friendly, approachable | Startups, tools | Convention |

**Hero anatomy:**
| Element | Regle | Anti-pattern |
|---------|-------|-------------|
| Headline | 6-12 mots, benefice clair | Feature-first, jargon |
| Subheadline | 1-2 phrases, clarifier headline | Repeter le headline |
| CTA primaire | Action verbe + benefice ("Start Free Trial") | "Submit", "Click Here" |
| CTA secondaire | "Learn more", "Watch demo" (optionnel) | Meme poids que primaire |
| Visual | Produit en contexte, hero image | Stock photo generique |

**Hero pour cessation app:**
```
Headline: "Break Free from Smoking, One Day at a Time"
Subheadline: "Track your progress, save money, and improve your health
              with smart insights and real-time support."
CTA Primary: "Start Your Journey - It's Free"
CTA Secondary: "See How It Works"
Visual: App screenshot showing progress dashboard
```

**Checklist:**
- [ ] Headline benefice-oriented (pas feature)
- [ ] CTA visible sans scroll (above fold)
- [ ] Un seul CTA primaire
- [ ] Visual pertinent (produit, pas stock)
- [ ] Load time hero < 2.5s (LCP)

---

### 138. Social Proof

| Type | Placement | Format | Source |
|------|-----------|--------|--------|
| Logos clients | Sous le hero | Grayscale, 4-6 logos | [NN/g Social Proof](https://www.nngroup.com/articles/social-proof-ux/) |
| Temoignages | Section dediee apres features | Photo + nom + role + quote | NN/g |
| Stats | Hero ou section separee | "50,000+ users", "4.8/5 rating" | Convention |
| Reviews | Pres du CTA ou product page | Stars + nombre | Convention |
| Case studies | Lien vers page dediee | Titre + resultat chiffre | B2B standard |

**Temoignage efficace:**
```html
<blockquote>
  <p>"I quit smoking after 15 years thanks to this app.
     The daily tracking kept me accountable."</p>
  <footer>
    <img src="avatar.jpg" alt="" width="48" height="48">
    <cite>Marie D., smoke-free since March 2025</cite>
  </footer>
</blockquote>
```

**Stats formatting:**
- "50,000+" pas "50000" (lisibilite)
- Arrondir (pas "49,873 users")
- Combiner avec temporalite ("50K users in 2024")

**Checklist:**
- [ ] Social proof visible sans scroll (logos) ou juste apres hero
- [ ] Temoignages avec photo, nom, contexte
- [ ] Stats arrondis et formats lisiblement
- [ ] Mix de proof types (logos + quotes + numbers)
- [ ] Temoignages pertinents au use case

---

### 139. CTA Hierarchy & Placement

| Level | Style | Usage | Example |
|-------|-------|-------|---------|
| Primary | Filled, couleur brand, large | Action principale par page | "Start Free Trial" |
| Secondary | Outlined ou ghost | Alternative, learn more | "Watch Demo" |
| Tertiary | Text link, underlined | Navigation, details | "Read case study" |

**Regles placement:**
| Regle | Detail | Source |
|-------|--------|--------|
| 1 primary par viewport | Pas 2 boutons primaires cote a cote | [NN/g CTA](https://www.nngroup.com/articles/call-to-action-buttons/) |
| Repeter le CTA | Hero + fin de page (+ sticky mobile) | Convention landing page |
| F-pattern | CTA en fin de section de contenu | Eye tracking NN/g |
| Sticky CTA mobile | Barre en bas avec CTA primaire | Mobile conversion |

**Checklist:**
- [ ] 1 CTA primaire par section/viewport
- [ ] CTA repete en fin de page
- [ ] Hierarchy visuelle claire (primary > secondary > tertiary)
- [ ] CTA label = verbe + benefice
- [ ] Mobile: CTA sticky en bas si longue page

---

### 140. Footer Patterns

| Element | Inclusion | Position |
|---------|-----------|----------|
| Navigation | Liens principaux organises par categorie | Colonnes |
| Legal | Privacy policy, Terms, Cookie settings | Derniere ligne |
| Social | Icones reseaux sociaux | Pres du legal ou section separee |
| Newsletter | Email + subscribe button | Section dediee |
| Contact | Email, phone, address | Colonne dediee |
| App store badges | iOS + Android links | Si apps natives |
| Copyright | "(c) 2025 Company Name" | Derniere ligne |

**Footer layout:**
```
[Logo]  [Product]     [Company]    [Support]     [Newsletter]
        Features      About        Help Center   [email input]
        Pricing       Blog         Contact       [Subscribe]
        Docs          Careers      Status
        Changelog     Press

---
(c) 2025 Infernal Wheel | Privacy | Terms | Cookie Settings | [social icons]
```

**Checklist:**
- [ ] Navigation organisee par categorie (3-4 colonnes)
- [ ] Liens legal accessibles (privacy, terms, cookies)
- [ ] Newsletter avec email validation
- [ ] Social links ouvrent dans nouvel onglet
- [ ] Stack en colonnes sur mobile
- [ ] "Back to top" link si page longue

---

## AC. Error Pages & System States

### 141. 404 Page Design

| Element | Requirement | Exemple |
|---------|------------|---------|
| Code + titre | Clair, humain | "Page not found" (pas "Error 404") |
| Explication | Pourquoi ca arrive | "The page may have been moved or deleted" |
| Search | Barre de recherche | Permettre de trouver le contenu |
| Links populaires | 3-5 liens utiles | Home, Features, Help, Blog |
| Brand voice | Ton coherent avec la marque | Peut etre leger (pas frustrant) |

**404 template:**
```html
<main class="error-page" role="main">
  <h1>Page not found</h1>
  <p>Sorry, we couldn't find the page you're looking for.
     It may have been moved or deleted.</p>

  <form action="/search" role="search">
    <label for="search-404">Search for something else</label>
    <input id="search-404" type="search" name="q"
           placeholder="Search...">
    <button type="submit">Search</button>
  </form>

  <nav aria-label="Helpful links">
    <h2>Try these instead</h2>
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/features">Features</a></li>
      <li><a href="/help">Help Center</a></li>
      <li><a href="/blog">Blog</a></li>
    </ul>
  </nav>
</main>
```

**Checklist:**
- [ ] Message humain (pas de code technique seul)
- [ ] Search disponible
- [ ] Liens populaires
- [ ] Navigation principale toujours presente
- [ ] Ton coherent avec la marque
- [ ] Tracking 404 pour identifier liens casses

---

### 142. Server Error Pages (500, 503, 429)

| Code | Page | Contenu essentiel | Source |
|------|------|-------------------|--------|
| 500 | Internal Server Error | "Something went wrong. We're on it." + retry + status page link | Best practice |
| 503 | Service Unavailable / Maintenance | Temps estime, status page, newsletter update | Best practice |
| 429 | Rate Limited | "Too many requests. Try again in X seconds." + countdown | Best practice |

**Maintenance page:**
```html
<main class="maintenance-page">
  <h1>We'll be back soon</h1>
  <p>We're performing scheduled maintenance.
     Expected completion: <time datetime="2025-03-06T14:00:00Z">2:00 PM UTC</time></p>
  <p>Follow <a href="https://status.infernal-wheel.app">our status page</a>
     for real-time updates.</p>
</main>
```

**Rate limiting UX:**
```javascript
// After 429 response
const retryAfter = response.headers.get('Retry-After'); // seconds
showMessage(`Too many requests. Please wait ${retryAfter} seconds.`);
// Show countdown timer
startCountdown(parseInt(retryAfter));
```

**Checklist:**
- [ ] 500: message rassurant + retry + status page
- [ ] 503: temps estime + status page + notification option
- [ ] 429: countdown + retry automatique
- [ ] Toutes pages d'erreur statiques (pas dependent du serveur qui a crash)
- [ ] Error pages servies depuis CDN ou statiquement

---

### 143. Browser & JS Fallbacks

| Situation | Solution | Source |
|-----------|----------|--------|
| JS disabled | `<noscript>` message + basic HTML fallback | Progressive enhancement |
| Old browser | Feature detection + polyfills ou banner | [MDN Feature Detection](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Feature_detection) |
| Print | `@media print` stylesheet | UX completeness |

**Noscript pattern:**
```html
<noscript>
  <div class="noscript-warning">
    <p>This app requires JavaScript for full functionality.
       Please enable JavaScript or use a modern browser.</p>
  </div>
</noscript>
```

**Print stylesheet essentials:**
```css
@media print {
  /* Hide non-essential elements */
  nav, footer, .sidebar, .no-print,
  button, .modal, .toast { display: none; }

  /* Ensure readability */
  body { font-size: 12pt; color: #000; background: #fff; }

  /* Show URLs for links */
  a[href]::after { content: " (" attr(href) ")"; font-size: 0.8em; }

  /* Avoid page breaks inside elements */
  h1, h2, h3, img, table { break-inside: avoid; }

  /* Force single column */
  .grid, .flex { display: block; }
}
```

**Checklist:**
- [ ] `<noscript>` avec message et alternatives
- [ ] Feature detection (pas UA sniffing)
- [ ] Print stylesheet pour pages de contenu
- [ ] Links avec URL visible en print
- [ ] Pas de break inside headings/images en print

---

## AD. File Upload & Media

### 144. Upload Zone Design

| Element | Regle | Anti-pattern | Source |
|---------|-------|-------------|--------|
| Drop zone | Border dashed, icone upload, label "Drag & drop or click to upload" | Zone trop petite, pas de label | [NN/g File Upload](https://www.nngroup.com/articles/upload-images/) |
| Visual feedback | Highlight border on dragover | Aucun feedback au drag | UX best practice |
| Validation | Type + taille avant upload | Upload puis erreur serveur | Performance |
| Restrictions | Afficher formats + taille max acceptes | Cacher les restrictions | UX transparency |

**Drop zone pattern:**
```html
<div class="upload-zone" role="button" tabindex="0"
     aria-label="Upload file. Drag and drop or click to browse."
     ondragover="handleDragOver(event)"
     ondrop="handleDrop(event)">
  <svg class="upload-icon"><!-- upload icon --></svg>
  <p class="upload-label">
    <strong>Drag & drop</strong> files here, or
    <span class="upload-browse">browse</span>
  </p>
  <p class="upload-restrictions">
    PNG, JPG, or WebP. Max 5MB.
  </p>
  <input type="file" hidden accept=".png,.jpg,.jpeg,.webp"
         multiple aria-hidden="true">
</div>
```

**Validation client-side:**
```javascript
function validateFile(file) {
  const maxSize = 5 * 1024 * 1024; // 5MB
  const allowedTypes = ['image/png', 'image/jpeg', 'image/webp'];

  if (!allowedTypes.includes(file.type)) {
    return { valid: false, error: `${file.name}: format not supported. Use PNG, JPG, or WebP.` };
  }
  if (file.size > maxSize) {
    return { valid: false, error: `${file.name}: too large (${(file.size/1024/1024).toFixed(1)}MB). Max 5MB.` };
  }
  return { valid: true };
}
```

**Checklist:**
- [ ] Drop zone large et visible
- [ ] Highlight visuel au dragover
- [ ] Formats et taille max affiches
- [ ] Validation client-side avant envoi
- [ ] Click alternative au drag (pour mobile, accessibilite)
- [ ] Keyboard accessible (Enter/Space pour browse)

---

### 145. Upload Progress

| Type | Pattern | UX |
|------|---------|-----|
| Single file | Progress bar horizontale + % + nom fichier | Feedback continu |
| Multiple files | Liste avec progress individuel + progress global | Vue d'ensemble |
| Batch | Progress global + nombre complete/total | Simplifie |

**Progress states:**
| State | Visual | Action |
|-------|--------|--------|
| Queued | Icone file, "Waiting..." | - |
| Uploading | Progress bar animated, "42%" | Cancel button |
| Processing | Spinner, "Processing..." | - |
| Complete | Check icon, thumbnail preview | Remove / Replace |
| Error | Error icon, message | Retry button |

**Upload progress UI:**
```html
<div class="upload-item" role="progressbar"
     aria-valuenow="42" aria-valuemin="0" aria-valuemax="100"
     aria-label="Uploading photo.jpg: 42%">
  <div class="upload-thumbnail">
    <img src="blob:..." alt="Preview">
  </div>
  <div class="upload-info">
    <span class="upload-name">photo.jpg</span>
    <span class="upload-size">2.1 MB</span>
    <div class="progress-bar">
      <div class="progress-fill" style="width: 42%"></div>
    </div>
  </div>
  <button class="upload-cancel" aria-label="Cancel upload">X</button>
</div>
```

**Checklist:**
- [ ] Progress bar avec pourcentage
- [ ] Cancel possible pendant upload
- [ ] Preview (thumbnail) pour images
- [ ] Retry sur erreur individuelle
- [ ] Resume upload si possible (tus protocol)
- [ ] `aria-valuenow` sur progress bar

---

### 146. Gallery & Media Players

**Image gallery patterns:**
| Pattern | Usage | Implementation |
|---------|-------|----------------|
| Grid | Vue d'ensemble, portfolio | CSS Grid auto-fill |
| Masonry | Pinterest-like, mixed aspect ratios | CSS columns ou JS layout |
| Carousel | Featured content, hero | Scroll snap + nav buttons |
| Lightbox | Detail view, zoom | Modal overlay + prev/next |

**Video player UX:**
| Element | Regle | Source |
|---------|-------|--------|
| Autoplay | Muted only (browser restriction), avec pause visible | [MDN Autoplay](https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide) |
| Controls | Custom ou native, toujours accessible keyboard | WCAG |
| Captions | Toujours disponibles, toggle on/off | WCAG 1.2.2 |
| PiP | Proposer Picture-in-Picture pour long content | UX enhancement |
| Preload | `preload="metadata"` (pas `auto` pour perf) | Performance |

**Carousel accessible:**
```html
<div class="carousel" role="region" aria-label="Featured images"
     aria-roledescription="carousel">
  <div class="carousel-track" aria-live="polite">
    <div role="group" aria-roledescription="slide"
         aria-label="1 of 5">
      <img src="..." alt="Description">
    </div>
  </div>
  <button aria-label="Previous slide">Prev</button>
  <button aria-label="Next slide">Next</button>
  <!-- Dots -->
  <div role="tablist" aria-label="Choose slide">
    <button role="tab" aria-selected="true" aria-label="Slide 1">1</button>
    <button role="tab" aria-selected="false" aria-label="Slide 2">2</button>
  </div>
</div>
```

**CSS Scroll Snap carousel:**
```css
.carousel-track {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scrollbar-width: none; /* Firefox */
}

.carousel-track::-webkit-scrollbar { display: none; }

.carousel-track > * {
  scroll-snap-align: start;
  flex: 0 0 100%;
}
```

**Checklist:**
- [ ] Gallery: keyboard navigable, alt text sur images
- [ ] Carousel: scroll snap, boutons prev/next, dots, pause auto-rotation
- [ ] Video: `preload="metadata"`, captions, keyboard controls
- [ ] Lightbox: Escape pour fermer, focus trap, prev/next
- [ ] Pas d'autoplay avec son

---

## AE. Maps & Geolocation Web

### 147. Map Integration

| Pattern | Usage | Provider | Source |
|---------|-------|----------|--------|
| Interactive map | Store locator, data visualization | Mapbox, Google Maps, Leaflet | [Google Maps Platform](https://developers.google.com/maps) |
| Static map | Confirmation d'adresse, email | Google Static Maps, Mapbox Static | Performance |
| Embed map | Contact page, directions | Google Maps Embed | Simple |

**Performance considerations:**
| Optimisation | Technique | Impact |
|-------------|-----------|--------|
| Lazy load map | IntersectionObserver, load on scroll | LCP, page weight |
| Static first | Image statique, interactive on click | Initial load |
| Marker clustering | Group markers at zoom levels | Rendering perf |

```javascript
// Lazy load map
const mapObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      loadMap(entry.target);
      mapObserver.unobserve(entry.target);
    }
  });
}, { rootMargin: '200px' });

mapObserver.observe(document.getElementById('map'));
```

**Checklist:**
- [ ] Map lazy-loaded (pas au initial page load)
- [ ] Fallback statique pour performance
- [ ] Clustering si > 50 markers
- [ ] Keyboard navigable (zoom, pan)
- [ ] Alt text ou `aria-label` sur map container

---

### 148. Location Permission UX

| Regle | Detail | Anti-pattern | Source |
|-------|--------|-------------|--------|
| Expliquer avant | Custom UI expliquant pourquoi | Permission prompt brut au load | [NN/g Permission](https://www.nngroup.com/articles/permission-requests/) |
| Contextuel | Demander quand l'action le requiert (clic "Near me") | Demander a l'arrivee sur le site | NN/g |
| Fallback | Recherche manuelle si permission refusee | Bloquer sans fallback | UX requirement |
| Precision | `enableHighAccuracy` seulement si necessaire | GPS haute precision pour "ville la plus proche" | Performance |

**Location request pattern:**
```javascript
async function requestLocation() {
  // Show custom explainer first
  const agreed = await showLocationExplainer({
    title: "Find stores near you",
    body: "We'll use your location to show nearby stores. You can always search manually.",
    cta: "Enable Location",
    dismiss: "Search manually"
  });

  if (!agreed) {
    showManualSearch();
    return;
  }

  try {
    const position = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: false, // City-level is enough
        timeout: 10000,
        maximumAge: 300000 // 5 min cache
      });
    });
    showNearbyStores(position.coords);
  } catch (error) {
    showManualSearch();
    showToast("Couldn't get your location. Try searching manually.");
  }
}
```

**Address autocomplete:**
```html
<label for="address">Address</label>
<input id="address" type="text"
       autocomplete="street-address"
       placeholder="Start typing an address..."
       aria-describedby="address-help"
       aria-autocomplete="list"
       role="combobox">
<ul id="address-suggestions" role="listbox" hidden>
  <!-- Populated by Google Places / Mapbox -->
</ul>
<p id="address-help">We'll show results as you type</p>
```

**Checklist:**
- [ ] Custom explainer avant permission native
- [ ] Fallback manuel si permission refusee
- [ ] `enableHighAccuracy: false` sauf besoin reel
- [ ] Timeout raisonnable (10s)
- [ ] Cache position (`maximumAge`)
- [ ] Address autocomplete comme alternative

---

## AF. Real-time & Collaboration

### 149. WebSocket UX

| State | Visual | Action | Source |
|-------|--------|--------|--------|
| Connecting | Subtle spinner ou dot orange | Auto, pas d'action user | Best practice |
| Connected | Dot vert ou rien (etat normal) | - | Best practice |
| Reconnecting | Banner "Reconnecting..." + spinner | Auto-retry avec backoff | [MDN WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) |
| Disconnected | Banner "Offline. Changes saved locally." | Retry button | Best practice |
| Error | Banner avec message specifique | Retry ou refresh | Best practice |

**Reconnection avec exponential backoff:**
```javascript
class ReconnectingWebSocket {
  constructor(url) {
    this.url = url;
    this.retryCount = 0;
    this.maxRetries = 10;
    this.connect();
  }

  connect() {
    this.ws = new WebSocket(this.url);

    this.ws.onopen = () => {
      this.retryCount = 0;
      hideReconnectBanner();
    };

    this.ws.onclose = () => {
      if (this.retryCount < this.maxRetries) {
        const delay = Math.min(1000 * Math.pow(2, this.retryCount), 30000);
        showReconnectBanner(`Reconnecting in ${delay/1000}s...`);
        setTimeout(() => this.connect(), delay);
        this.retryCount++;
      } else {
        showDisconnectedBanner();
      }
    };
  }
}
```

**Checklist:**
- [ ] Connection state visible mais non-intrusif
- [ ] Auto-reconnect avec exponential backoff
- [ ] Cap sur les retries (ex: 10)
- [ ] Donnees locales preservees pendant deconnexion
- [ ] Banner non-bloquant pour etat connexion

---

### 150. Presence & Live Indicators

| Pattern | Usage | Implementation |
|---------|-------|----------------|
| Live cursors | Collaborative editing (Figma, Google Docs) | WebSocket + `pointermove` throttled |
| Avatar stack | Qui est en ligne | WebSocket presence channel |
| Typing indicator | Chat | "User is typing..." avec timeout 3s |
| Read receipts | Messaging | Double check marks |
| Live counter | "5 people viewing" | Presence count |

**Presence indicators:**
```html
<!-- Online users -->
<div class="presence" aria-label="3 people online">
  <div class="avatar-stack">
    <img src="user1.jpg" alt="Alice" class="avatar online">
    <img src="user2.jpg" alt="Bob" class="avatar online">
    <img src="user3.jpg" alt="Carol" class="avatar idle">
  </div>
  <span class="presence-count">3 online</span>
</div>

<!-- Status dot -->
<span class="status-dot status-online" aria-label="Online"></span>
<span class="status-dot status-idle" aria-label="Idle"></span>
<span class="status-dot status-offline" aria-label="Offline"></span>
```

**Status dot sizes:**
| Context | Size | Position |
|---------|------|----------|
| Avatar (32px) | 8px dot | Bottom-right, offset -2px |
| Avatar (48px) | 10px dot | Bottom-right, offset -2px |
| List item | 8px dot | Inline, before name |

**Checklist:**
- [ ] Presence updates throttled (pas chaque ms)
- [ ] Idle detection (5 min sans activite)
- [ ] Graceful degradation (cursor lag acceptable)
- [ ] Screen reader: status annonce via `aria-label`
- [ ] Typing indicator timeout (3s apres dernier keystroke)

---

### 151. Chat Patterns

| Element | Pattern | Source |
|---------|---------|--------|
| Messages | Bulles, sender gauche/droite | Messaging convention |
| Timestamps | Relative ("2 min ago"), groupees par jour | UX standard |
| Status | Sent (1 check) > Delivered (2 checks) > Read (2 blue checks) | WhatsApp pattern |
| Typing | "Alice is typing..." avec animation dots | Convention |
| Reactions | Emoji picker on long-press/hover | Slack/Discord pattern |

**Message states:**
| State | Icon | Meaning |
|-------|------|---------|
| Sending | Clock/spinner | En cours d'envoi |
| Sent | Single check | Serveur a recu |
| Delivered | Double check | Destinataire a recu |
| Read | Double check (colored) | Destinataire a lu |
| Failed | Error icon + Retry | Echec d'envoi |

**Checklist:**
- [ ] Messages groupes par jour/heure
- [ ] Status d'envoi visible (sent/delivered/read)
- [ ] Typing indicator avec timeout
- [ ] Scroll auto en bas pour nouveaux messages
- [ ] "New messages" divider si scroll up
- [ ] Retry sur messages echoues

---

## AG. Admin & Dashboard Patterns

### 152. CRUD Interfaces

| Action | Pattern | UX Regle | Source |
|--------|---------|----------|--------|
| Create | Formulaire modal ou page dediee | Pre-remplir defaults, validation inline | Best practice |
| Read | Table + detail view | Responsive table, click-to-expand | [Pencil & Paper](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-data-tables) |
| Update | Inline edit ou modal | Save/cancel explicit, undo | Best practice |
| Delete | Confirm dialog | Undo 5s > dialog pour destructif | [NN/g Undo](https://www.nngroup.com/articles/confirmation-dialog/) |

**Delete confirmation levels:**
| Severity | Pattern | Exemple |
|----------|---------|---------|
| Low | Undo toast (5s) | Delete message |
| Medium | Simple confirm dialog | Delete project |
| High | Type name to confirm | Delete account |

```html
<!-- High severity: type to confirm -->
<dialog>
  <h2>Delete your account?</h2>
  <p>This will permanently delete all your data.
     This action cannot be undone.</p>
  <label>Type <strong>DELETE</strong> to confirm</label>
  <input type="text" pattern="DELETE" required>
  <button class="destructive" disabled>Delete Account</button>
  <button class="secondary">Cancel</button>
</dialog>
```

**Checklist:**
- [ ] Create: validation inline, defaults pre-remplis
- [ ] Read: pagination, sort, filter, search
- [ ] Update: inline edit quand possible, save explicite
- [ ] Delete: severity-appropriate confirmation
- [ ] Bulk actions: select all, select page, deselect all
- [ ] Undo prefere aux confirmations (sauf destructif)

---

### 153. Data Tables with Bulk Operations

| Feature | Implementation | Source |
|---------|---------------|--------|
| Select all (page) | Checkbox dans header | Convention |
| Select all (dataset) | Banner "Select all 1,234 items" apres select-all page | Gmail pattern |
| Bulk actions bar | Sticky bar en haut avec actions + count | Material Design |
| Deselect | "Clear selection" ou uncheck all | Convention |

**Bulk actions bar:**
```html
<div class="bulk-actions" role="toolbar" aria-label="Bulk actions"
     hidden>
  <span class="selection-count">3 items selected</span>
  <button class="bulk-edit">Edit</button>
  <button class="bulk-export">Export</button>
  <button class="bulk-delete destructive">Delete</button>
  <button class="deselect" aria-label="Clear selection">X</button>
</div>
```

**Checklist:**
- [ ] Checkbox select individual + select all page
- [ ] "Select all X items" pour dataset entier
- [ ] Bulk actions bar sticky avec count
- [ ] Destructive bulk actions: confirmation obligatoire
- [ ] Loading state pendant bulk operation
- [ ] Deselect accessible

---

### 154. Dashboard Layout

| Layout | Usage | Structure |
|--------|-------|-----------|
| Sidebar + content | Admin panels, SaaS | Sidebar 240-280px + main content |
| Top nav + content | Simple dashboards | Horizontal nav + cards grid |
| Two-sidebar | IDE-like, complex tools | Left nav + main + right panel |

**Dashboard metrics display:**
| Component | Usage | Format |
|-----------|-------|--------|
| KPI card | Single number highlight | Number + label + trend arrow + sparkline |
| Chart | Trends over time | Line/bar chart, clear axis labels |
| Table | Detailed data | Sortable, filterable |
| Activity feed | Recent events | Timeline, relative timestamps |

**KPI card anatomy:**
```html
<div class="kpi-card" role="group" aria-label="Active users">
  <span class="kpi-label">Active Users</span>
  <span class="kpi-value">2,847</span>
  <span class="kpi-trend positive" aria-label="Up 12% from last month">
    +12%
  </span>
  <div class="kpi-sparkline" aria-hidden="true">
    <!-- Mini chart -->
  </div>
</div>
```

**Sidebar navigation:**
| Element | Spec |
|---------|------|
| Width expanded | 240-280px |
| Width collapsed | 64-72px |
| Icon size | 20-24px |
| Item height | 40-48px |
| Active indicator | Background highlight ou left border 3px |
| Group separator | Label uppercase 12px + divider |

**Checklist:**
- [ ] Sidebar collapsible (icon-only mode)
- [ ] Active page highlighted dans sidebar
- [ ] KPI cards avec trend et contexte
- [ ] Responsive: sidebar -> bottom nav ou hamburger sur mobile
- [ ] Dashboard customizable (drag to reorder widgets)
- [ ] Date range picker pour filtrer les donnees

---

## AH. Navigation Advanced Web

### 155. Mega Menu

| Element | Regle | Anti-pattern | Source |
|---------|-------|-------------|--------|
| Trigger | Hover (desktop) ou click | Hover sans delai (menu disparait en traversant) | [NN/g Mega Menus](https://www.nngroup.com/articles/mega-menus-work-well/) |
| Layout | Colonnes par categorie, max 7 categories | Liste lineaire trop longue | NN/g |
| Featured content | Image/promo dans une colonne | Menu 100% texte (missed marketing opportunity) | Convention |
| Close | Click outside, Escape, clic sur lien | Pas de moyen de fermer | WCAG |
| Mobile | Accordion ou drill-down | Mega menu hover sur mobile | UX requirement |

**Hover intent pattern (eviter fermeture accidentelle):**
```javascript
let openTimeout, closeTimeout;
const OPEN_DELAY = 100;  // ms before opening
const CLOSE_DELAY = 300; // ms before closing (allow diagonal movement)

menuTrigger.addEventListener('mouseenter', () => {
  clearTimeout(closeTimeout);
  openTimeout = setTimeout(openMenu, OPEN_DELAY);
});

menuTrigger.addEventListener('mouseleave', () => {
  clearTimeout(openTimeout);
  closeTimeout = setTimeout(closeMenu, CLOSE_DELAY);
});

megaMenu.addEventListener('mouseenter', () => {
  clearTimeout(closeTimeout);
});

megaMenu.addEventListener('mouseleave', () => {
  closeTimeout = setTimeout(closeMenu, CLOSE_DELAY);
});
```

**Checklist:**
- [ ] Hover intent avec delai (300ms fermeture)
- [ ] Colonnes organisees par categorie
- [ ] Keyboard navigable (Arrow keys, Escape)
- [ ] Featured content / promo dans le menu
- [ ] Mobile: accordion ou drill-down (pas hover)
- [ ] Max 7 categories top-level

---

### 156. Command Palette (Cmd+K)

| Element | Spec | Source |
|---------|------|--------|
| Shortcut | `Cmd+K` (Mac) / `Ctrl+K` (Win) | Spotlight/Raycast pattern |
| UI | Modal center-top, search input + results list | Convention |
| Search | Fuzzy matching, recent items first | UX best practice |
| Categories | Pages, Actions, Settings, Users | Organize results |
| Keyboard | Arrow up/down to navigate, Enter to select, Escape to close | WCAG |

**Command palette pattern:**
```html
<dialog class="command-palette" role="combobox">
  <input type="search" placeholder="Search or type a command..."
         aria-label="Command palette"
         aria-expanded="true"
         aria-controls="command-results"
         aria-activedescendant="result-1">
  <ul id="command-results" role="listbox">
    <li role="option" id="result-1" aria-selected="true">
      <span class="result-icon">Page</span>
      <span class="result-label">Dashboard</span>
      <kbd class="result-shortcut">Cmd+D</kbd>
    </li>
    <li role="option" id="result-2">
      <span class="result-icon">Action</span>
      <span class="result-label">Log Cigarette</span>
      <kbd class="result-shortcut">Cmd+L</kbd>
    </li>
  </ul>
</dialog>
```

**Result ranking:**
1. Exact match on title
2. Recent/frequent items
3. Fuzzy match on title
4. Match on description/tags
5. Actions related to current context

**Checklist:**
- [ ] `Cmd+K` / `Ctrl+K` shortcut
- [ ] Fuzzy search avec ranking
- [ ] Categories pour organiser les resultats
- [ ] Recent items en premier
- [ ] Keyboard navigation complete
- [ ] Escape pour fermer
- [ ] Max 7-10 resultats visibles

---

### 157. Breadcrumbs & Sticky Headers

**Breadcrumbs:**
```html
<nav aria-label="Breadcrumb">
  <ol class="breadcrumbs">
    <li><a href="/">Home</a></li>
    <li><a href="/stats">Statistics</a></li>
    <li aria-current="page">Weekly Report</li>
  </ol>
</nav>
```

| Regle | Detail | Source |
|-------|--------|--------|
| Separator | `>` ou `/` via CSS `::before` (pas dans le markup) | [WCAG Breadcrumb](https://www.w3.org/WAI/ARIA/apg/patterns/breadcrumb/) |
| Current page | Pas de lien, `aria-current="page"` | WCAG |
| Mobile | Tronquer (... > Parent > Current) si trop long | UX mobile |
| Max depth | 4-5 niveaux visibles | UX readability |

**Sticky header show/hide:**
```css
.header {
  position: sticky;
  top: 0;
  z-index: 100;
  transition: transform 200ms ease-out;
}

.header--hidden {
  transform: translateY(-100%);
}
```

```javascript
let lastScrollY = 0;
const header = document.querySelector('.header');

window.addEventListener('scroll', () => {
  const currentScrollY = window.scrollY;

  if (currentScrollY > lastScrollY && currentScrollY > 100) {
    // Scrolling down, past threshold
    header.classList.add('header--hidden');
  } else {
    // Scrolling up
    header.classList.remove('header--hidden');
  }

  lastScrollY = currentScrollY;
}, { passive: true });
```

**Checklist:**
- [ ] Breadcrumbs: `<nav>` + `<ol>` + `aria-label`
- [ ] Current page sans lien, `aria-current="page"`
- [ ] Sticky header: show on scroll up, hide on scroll down
- [ ] Header threshold: hide seulement apres 100px de scroll
- [ ] Skip navigation link en premier element focusable
- [ ] `{ passive: true }` sur scroll listener

---

## AI. Cookie Consent & GDPR

### 158. Cookie Banner Patterns

| Pattern | Pros | Cons | Source |
|---------|------|------|--------|
| Bottom bar | Moins intrusif, contenu accessible | Peut etre ignore | [GDPR.eu](https://gdpr.eu/cookies/) |
| Modal overlay | Force la decision | Bloque le contenu, mauvais UX | IAB TCF |
| Corner popup | Discret | Facile a rater | Convention |
| Top bar | Visible immediatement | Pousse le contenu vers le bas (CLS!) | Convention |

**Cookie banner minimal viable:**
```html
<div class="cookie-banner" role="dialog"
     aria-label="Cookie consent"
     aria-describedby="cookie-description">
  <p id="cookie-description">
    We use cookies to improve your experience.
    <a href="/privacy">Learn more</a>
  </p>
  <div class="cookie-actions">
    <button class="primary" data-consent="all">Accept All</button>
    <button class="secondary" data-consent="necessary">
      Necessary Only
    </button>
    <button class="tertiary" data-consent="customize">
      Customize
    </button>
  </div>
</div>
```

**Cookie categories:**
| Category | Exemples | Opt-out possible | Source |
|----------|----------|-----------------|--------|
| Necessary | Session, CSRF, consent choice | Non (toujours actif) | GDPR Art. 6(1)(f) |
| Analytics | Google Analytics, Mixpanel | Oui | GDPR Art. 6(1)(a) |
| Marketing | Facebook Pixel, Google Ads | Oui | GDPR Art. 6(1)(a) |
| Functional | Language pref, theme, A/B test | Oui | GDPR Art. 6(1)(a) |

**Regles GDPR essentielles:**
| Regle | Requirement |
|-------|------------|
| Consentement pre-coche | INTERDIT (pas de cases pre-cochees) |
| Reject aussi facile que Accept | Bouton "Reject All" au meme niveau que "Accept All" |
| Granularite | Choix par categorie possible |
| Retrait | Pouvoir changer d'avis (lien dans footer) |
| Preuve | Stocker le consentement avec timestamp |
| Renouvellement | Re-demander tous les 6-12 mois |

**Checklist:**
- [ ] "Reject All" aussi visible que "Accept All"
- [ ] Pas de cases pre-cochees
- [ ] Customisation par categorie
- [ ] "Necessary only" comme option claire
- [ ] Cookie settings accessible dans footer
- [ ] Consent stocke avec timestamp
- [ ] Pas de tracking avant consentement
- [ ] Renouvellement du consentement periodique

---

### 159. Privacy & Data Rights UX

| Droit GDPR | UX Implementation | Delai legal |
|------------|-------------------|-------------|
| Acces (Art. 15) | "Download my data" button dans settings | 30 jours |
| Rectification (Art. 16) | Edit profile fields directement | 30 jours |
| Effacement (Art. 17) | "Delete my account" avec confirmation | 30 jours |
| Portabilite (Art. 20) | Export JSON/CSV dans settings | 30 jours |
| Opposition (Art. 21) | Unsubscribe links, notification settings | Immediat |

**Account deletion flow:**
1. Settings > Account > "Delete my account"
2. Expliquer consequences (data perdue, abonnement annule)
3. Confirmation forte (type "DELETE" ou re-enter password)
4. Grace period: 30 jours pour annuler
5. Email de confirmation avec lien "Cancel deletion"
6. Suppression definitive apres 30 jours

**Checklist:**
- [ ] "Download my data" dans settings
- [ ] "Delete my account" accessible (pas cache)
- [ ] Grace period 30 jours pour deletion
- [ ] Confirmation email pour deletion
- [ ] Privacy policy lisible (pas juste legal)
- [ ] Cookie settings accessible en permanence (footer link)

---

## AJ. Rich Text & Content

### 160. Rich Text Editor

| Type | Complexite | Usage | Exemples |
|------|-----------|-------|----------|
| Basic | Gras, italique, lien, liste | Commentaires, descriptions | TipTap, Quill |
| Medium | + images, headings, tables | Blog posts, documentation | ProseMirror, TipTap |
| Full | + code, embeds, collaboration | CMS, knowledge base | Notion-like, Editor.js |
| Markdown | Texte brut avec preview | Developpeurs, technical writing | CodeMirror, Monaco |

**Toolbar patterns:**
| Pattern | Usage | Avantage |
|---------|-------|----------|
| Fixed top toolbar | Desktop editors | Toujours visible |
| Floating toolbar | Selection-based | Moins intrusif |
| Slash commands | "/heading", "/image" | Power users, no toolbar needed |
| Bubble menu | Near selection | Contextuel |

**Toolbar essentials:**
```
[B] [I] [U] [S] | [H1] [H2] [H3] | [UL] [OL] | [Link] [Image] | [Code] [Quote]
```

**Checklist:**
- [ ] Toolbar adapte au use case (basic vs full)
- [ ] Raccourcis clavier (Ctrl+B, Ctrl+I, Ctrl+K)
- [ ] Undo/Redo (Ctrl+Z, Ctrl+Shift+Z)
- [ ] Paste from Word/Google Docs (clean HTML)
- [ ] Image upload inline (drag & drop)
- [ ] Autosave (draft every 30s)
- [ ] Mobile: toolbar sticky en bas

---

### 161. Draft & Version History

| Feature | Implementation | Source |
|---------|---------------|--------|
| Autosave | Save draft every 30s ou on pause (debounce 2s) | Google Docs pattern |
| Draft indicator | "Saved" / "Saving..." / "Unsaved changes" | UX feedback |
| Version history | Timeline of saves, diff view, restore | Google Docs, Notion |
| Publishing | Draft -> Review -> Published states | CMS workflow |

**Save states:**
| State | Visual | Trigger |
|-------|--------|---------|
| Editing | "Unsaved changes" (subtle, grey) | Any keystroke |
| Saving | "Saving..." + spinner | Debounce 2s after last edit |
| Saved | "All changes saved" + check | Save complete |
| Error | "Failed to save. Retrying..." | Network error |
| Offline | "Saved locally. Will sync when online." | No connection |

**Checklist:**
- [ ] Autosave avec debounce (2s apres dernier edit)
- [ ] Save state toujours visible
- [ ] Version history accessible
- [ ] Restore previous version avec confirmation
- [ ] Offline: save to localStorage, sync later
- [ ] "Unsaved changes" warning si navigation away

---

## AK. Social Features Web

### 162. Share & Comments

**Web Share API (preferred):**
```javascript
async function share(content) {
  if (navigator.share) {
    try {
      await navigator.share({
        title: content.title,
        text: content.description,
        url: content.url
      });
    } catch (err) {
      if (err.name !== 'AbortError') console.error(err);
    }
  } else {
    showShareFallback(content); // Custom share buttons
  }
}
```

**Share fallback buttons order (by usage 2025):**
1. Copy link (most universal)
2. WhatsApp
3. X/Twitter
4. Facebook
5. Email
6. LinkedIn (B2B)

**Comment system patterns:**
| Feature | Pattern |
|---------|---------|
| Threading | Max 2-3 levels deep, then "View thread" |
| Sorting | "Newest" / "Most liked" / "Oldest" toggle |
| Moderation | Flag/report, auto-moderation, admin tools |
| Reactions | Emoji picker ou predefined (thumbs up, heart, etc.) |
| Mentions | @username with autocomplete |
| Edit/delete | Own comments, within time window (15 min edit) |

**Checklist:**
- [ ] Web Share API avec fallback custom buttons
- [ ] Copy link toujours disponible en premier
- [ ] Comments: threading 2-3 levels max
- [ ] Report/flag mechanism
- [ ] Edit window pour ses propres commentaires
- [ ] Reactions pour engagement low-friction
- [ ] `rel="noopener noreferrer"` sur social links

---

### 163. User Profiles & Activity

| Element | Spec |
|---------|------|
| Avatar | 40px (list), 64px (card), 96-128px (profile page) |
| Name display | Full name ou username, truncate a 20 chars |
| Bio | Max 160 chars (comme Twitter) |
| Stats | Followers, posts, achievements |
| Activity feed | Chronological, groupable by day |

**Activity feed patterns:**
| Pattern | Usage |
|---------|-------|
| Simple list | "Alice logged 3 cigarettes" |
| Grouped | "Alice and 2 others achieved 1-week milestone" |
| Cards | Rich content (images, stats) |

**Checklist:**
- [ ] Avatar avec fallback initiales si pas d'image
- [ ] Profile page responsive (stack on mobile)
- [ ] Activity feed avec pagination/infinite scroll
- [ ] Privacy controls sur le profil
- [ ] Block/report other users

---

## AL. Valeurs Cles Web (Memo Rapide)

### 164. Performance Budgets

| Metric | Target | Poor | Source |
|--------|--------|------|--------|
| LCP | <= 2.5s | > 4.0s | web.dev |
| CLS | <= 0.1 | > 0.25 | web.dev |
| INP | <= 200ms | > 500ms | web.dev |
| TTFB | <= 800ms | > 1800ms | web.dev |
| FCP | <= 1.8s | > 3.0s | web.dev |
| Total JS | < 200KB gz | > 400KB | Best practice |
| Total CSS | < 50KB gz | > 100KB | Best practice |
| Total page | < 1.5MB | > 3MB | HTTP Archive |
| Requests | < 50 | > 100 | Best practice |
| Fonts total | < 100KB | > 200KB | Best practice |
| Hero image | < 200KB | > 500KB | Best practice |

---

### 165. Breakpoints

| Token | Value | Target |
|-------|-------|--------|
| `sm` | 480px | Mobile large |
| `md` | 768px | Tablet |
| `lg` | 1024px | Desktop |
| `xl` | 1280px | Desktop large |
| `2xl` | 1536px | Ultra-wide |

---

### 166. Z-index Scale

| Layer | Z-index | Usage |
|-------|---------|-------|
| Base | 0 | Normal flow |
| Dropdown | 100 | Menus, selects |
| Sticky | 200 | Sticky header, sidebar |
| Fixed | 300 | Fixed elements |
| Overlay/backdrop | 400 | Modal backdrop, drawer backdrop |
| Modal | 500 | Dialogs, modals |
| Popover | 600 | Tooltips, popovers |
| Toast | 700 | Snackbars, notifications |
| Max | 999 | Skip link focus, debug overlays |

---

### 167. Typography Scale

| Token | Size | Line-height | Weight | Usage |
|-------|------|-------------|--------|-------|
| `display` | clamp(2.25rem, 4vw, 4rem) | 1.1 | 700 | Hero headlines |
| `h1` | clamp(1.875rem, 3vw, 3rem) | 1.2 | 700 | Page titles |
| `h2` | clamp(1.5rem, 2.5vw, 2.25rem) | 1.25 | 600 | Section titles |
| `h3` | clamp(1.25rem, 2vw, 1.75rem) | 1.3 | 600 | Subsection titles |
| `h4` | clamp(1.125rem, 1.5vw, 1.375rem) | 1.35 | 600 | Card titles |
| `body` | clamp(1rem, 0.5vw + 0.875rem, 1.125rem) | 1.5 | 400 | Body text |
| `small` | 0.875rem (14px) | 1.4 | 400 | Secondary text |
| `caption` | 0.75rem (12px) | 1.33 | 400 | Labels, captions |

---

### 168. Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | 4px | Inline padding, icon gaps |
| `--space-2` | 8px | Tight padding, form gaps |
| `--space-3` | 12px | Card padding (compact) |
| `--space-4` | 16px | Default padding, card padding |
| `--space-5` | 20px | - |
| `--space-6` | 24px | Section padding |
| `--space-8` | 32px | Large gaps |
| `--space-10` | 40px | Section spacing |
| `--space-12` | 48px | Section spacing (large) |
| `--space-16` | 64px | Page section spacing |
| `--space-20` | 80px | Desktop margins |
| `--space-24` | 96px | Hero padding |

---

### 169. Animation Timings

| Token | Duration | Easing | Usage |
|-------|----------|--------|-------|
| `instant` | 100ms | `ease-out` | Hover, focus states |
| `fast` | 150ms | `ease-out` | Tooltips, fade |
| `normal` | 200ms | `ease-in-out` | Transitions, collapse |
| `slow` | 300ms | `ease-in-out` | Modal enter, slide |
| `slower` | 500ms | `cubic-bezier(0.4, 0, 0.2, 1)` | Page transitions |

**Easing tokens:**
| Token | Value | Usage |
|-------|-------|-------|
| `ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | Enter animations |
| `ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | Exit animations |
| `ease-in-out` | `cubic-bezier(0.4, 0, 0.2, 1)` | State changes |
| `spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Playful bounces |

**Reduce motion:**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

### 170. WCAG Quick Reference

| Criterion | Level | Threshold | Source |
|-----------|-------|-----------|--------|
| Color contrast (normal text) | AA | 4.5:1 | WCAG 1.4.3 |
| Color contrast (large text 18px+) | AA | 3:1 | WCAG 1.4.3 |
| Color contrast (UI components) | AA | 3:1 | WCAG 1.4.11 |
| Touch target | AA | 24x24px min | WCAG 2.5.8 |
| Touch target | Best practice | 44x44px recommended | Apple HIG |
| Focus visible | AA | 2px outline, 3:1 contrast | WCAG 2.4.7, 2.4.11 |
| Text resize | AA | Up to 200% without loss | WCAG 1.4.4 |
| Timing adjustable | A | Warning before timeout | WCAG 2.2.1 |
| Keyboard | A | All functionality via keyboard | WCAG 2.1.1 |
| Alt text | A | All images have alt (or alt="") | WCAG 1.1.1 |
| Page language | A | `lang` attribute on `<html>` | WCAG 3.1.1 |
| Error identification | A | Errors described in text | WCAG 3.3.1 |
| Labels | A | All inputs have labels | WCAG 1.3.1 |

---

### 171. CSS Container & Media Query Reference

| Query | Syntax | Usage |
|-------|--------|-------|
| Min-width (mobile-first) | `@media (min-width: 768px)` | Breakpoint up |
| Max-width (desktop-first) | `@media (max-width: 767px)` | Breakpoint down |
| Dark mode | `@media (prefers-color-scheme: dark)` | Theme |
| Reduced motion | `@media (prefers-reduced-motion: reduce)` | Accessibility |
| High contrast | `@media (forced-colors: active)` | Windows high contrast |
| Touch device | `@media (pointer: coarse)` | Touch targets |
| Mouse device | `@media (pointer: fine)` | Hover effects |
| Hover capable | `@media (hover: hover)` | Hover states |
| Print | `@media print` | Print stylesheet |
| Container | `@container name (min-width: 400px)` | Component responsive |
| Orientation | `@media (orientation: portrait)` | Mobile orientation |
| Display mode (PWA) | `@media (display-mode: standalone)` | PWA-specific styles |

---

### 172. HTML Autocomplete Reference

| Field Type | `autocomplete` Value |
|-----------|---------------------|
| Full name | `name` |
| Email | `email` |
| Phone | `tel` |
| Street address | `street-address` |
| City | `address-level2` |
| State/Province | `address-level1` |
| Postal code | `postal-code` |
| Country | `country` |
| Login password | `current-password` |
| New password | `new-password` |
| Credit card number | `cc-number` |
| Card expiry | `cc-exp` |
| Card CVC | `cc-csc` |
| Card holder | `cc-name` |
| OTP code | `one-time-code` |
| Username | `username` |
| Organization | `organization` |
| Birthday | `bday` |

---

### 173. Cookie Consent Quick Reference

| Regle | Requirement | Reference |
|-------|------------|-----------|
| Pre-checked boxes | INTERDIT | GDPR Art. 7 |
| Reject = Accept | Meme niveau visuel | EDPB Guidelines |
| Granularity | Par categorie minimum | ePrivacy Directive |
| Withdraw | A tout moment, facilement | GDPR Art. 7(3) |
| Proof | Stocker consentement + timestamp | GDPR Art. 7(1) |
| Renewal | 6-12 mois | Best practice |
| No tracking before consent | Aucun cookie non-necessaire avant | GDPR Art. 6 |
| Children | Age verification si applicable | GDPR Art. 8 |

---

### 174. Common HTTP Status Codes for UX

| Code | Meaning | UX Response |
|------|---------|-------------|
| 200 | OK | Normal flow |
| 201 | Created | Success toast + redirect |
| 204 | No Content | Silent success (delete) |
| 301 | Moved Permanently | Auto-redirect |
| 304 | Not Modified | Serve from cache |
| 400 | Bad Request | Inline validation errors |
| 401 | Unauthorized | Redirect to login |
| 403 | Forbidden | "Access denied" + contact admin |
| 404 | Not Found | Custom 404 page |
| 409 | Conflict | "Already exists" or merge prompt |
| 413 | Payload Too Large | "File too large" error |
| 422 | Unprocessable Entity | Form validation errors |
| 429 | Too Many Requests | Countdown + auto-retry |
| 500 | Internal Server Error | "Something went wrong" + retry |
| 502 | Bad Gateway | "Server temporarily unavailable" |
| 503 | Service Unavailable | Maintenance page |

---

### 175. Minimum Dimensions Reference

| Element | Min Size | Touch Target | Source |
|---------|----------|-------------|--------|
| Button | 32x32px (desktop) | 48x48px (mobile) | WCAG 2.5.8 |
| Icon button | 24x24px visual | 44x44px tap area | Apple HIG |
| Checkbox/Radio | 16x16px visual | 44x44px tap area | WCAG |
| Input field height | 36-40px | 48px mobile | Convention |
| Link spacing | N/A | 8px between adjacent links | WCAG 2.5.8 |
| Scrollbar | 8px (desktop) | 4px (overlay style) | OS convention |
| Modal min-width | 320px | 100vw mobile | Convention |
| Modal max-width | 640px (form), 960px (content) | - | Convention |
| Sidebar | 240-280px expanded | 64-72px collapsed | Convention |
| Toast/Snackbar | 288px min-width | - | Material Design |
## AM. Design Tokens & Theming System

### 176. Token Naming Architecture

Design tokens follow a **three-tier hierarchy**: primitive → semantic → component. This separation enables theme switching without touching component code.

| Tier | Purpose | Naming Convention | Example |
|------|---------|-------------------|---------|
| Primitive | Raw values, no meaning | `--color-blue-500`, `--space-4` | `#3b82f6`, `16px` |
| Semantic | Intent-based aliases | `--color-primary`, `--color-surface` | References `--color-blue-500` |
| Component | Scoped to a component | `--button-bg`, `--card-radius` | References `--color-primary` |

**Token categories:**

| Category | Primitives | Semantic Examples |
|----------|-----------|-------------------|
| Color | `--color-{hue}-{shade}` (50-950) | `--color-primary`, `--color-error`, `--color-text-secondary` |
| Spacing | `--space-{scale}` (1-24) | `--space-inline`, `--space-stack`, `--space-section` |
| Typography | `--font-size-{scale}`, `--font-weight-{name}` | `--text-body`, `--text-heading` |
| Border radius | `--radius-{scale}` (none/sm/md/lg/full) | `--radius-card`, `--radius-button` |
| Shadow | `--shadow-{scale}` (sm/md/lg/xl) | `--shadow-dropdown`, `--shadow-modal` |
| Motion | `--duration-{name}`, `--ease-{name}` | `--duration-fast`, `--ease-enter` |
| Z-index | `--z-{layer}` | `--z-dropdown`, `--z-modal`, `--z-toast` |

### 177. CSS Custom Properties & Theme Switching

```css
/* Primitive tokens */
:root {
  --color-blue-500: #3b82f6;
  --color-blue-600: #2563eb;
  --color-gray-50: #f9fafb;
  --color-gray-900: #111827;
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
}

/* Semantic tokens — light theme (default) */
:root, [data-theme="light"] {
  --color-bg: var(--color-gray-50);
  --color-text: var(--color-gray-900);
  --color-primary: var(--color-blue-500);
  --color-primary-hover: var(--color-blue-600);
  --color-surface: #ffffff;
  --color-border: #e5e7eb;
  --shadow-card: 0 1px 3px rgba(0,0,0,0.1);
}

/* Dark theme */
[data-theme="dark"] {
  --color-bg: #0f172a;
  --color-text: #f1f5f9;
  --color-primary: #60a5fa;
  --color-primary-hover: #93bbfd;
  --color-surface: #1e293b;
  --color-border: #334155;
  --shadow-card: 0 1px 3px rgba(0,0,0,0.4);
}

/* Brand override example */
[data-theme="brand-acme"] {
  --color-primary: #e11d48;
  --color-primary-hover: #be123c;
}
```

**Theme toggle implementation:**

```javascript
// Respect system preference, allow user override
function initTheme() {
  const stored = localStorage.getItem('theme');
  if (stored) return applyTheme(stored);
  const prefersDark = matchMedia('(prefers-color-scheme: dark)').matches;
  applyTheme(prefersDark ? 'dark' : 'light');
}
function applyTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  localStorage.setItem('theme', theme);
}
// Listen for system changes
matchMedia('(prefers-color-scheme: dark)')
  .addEventListener('change', e => {
    if (!localStorage.getItem('theme')) applyTheme(e.matches ? 'dark' : 'light');
  });
```

### 178. Style Dictionary Configuration

```json
{
  "source": ["tokens/**/*.json"],
  "platforms": {
    "css": {
      "transformGroup": "css",
      "buildPath": "dist/css/",
      "files": [{
        "destination": "tokens.css",
        "format": "css/variables",
        "options": { "outputReferences": true }
      }]
    },
    "js": {
      "transformGroup": "js",
      "buildPath": "dist/js/",
      "files": [{
        "destination": "tokens.mjs",
        "format": "javascript/es6"
      }]
    }
  }
}
```

**Token file structure:**

```
tokens/
├── primitive/
│   ├── color.json       # Raw palette
│   ├── spacing.json     # 4px scale
│   └── typography.json  # Font sizes, weights
├── semantic/
│   ├── light.json       # Light theme aliases
│   ├── dark.json        # Dark theme aliases
│   └── motion.json      # Duration, easing
└── component/
    ├── button.json
    ├── card.json
    └── input.json
```

### 179. Figma Variables Sync

| Figma Feature | Token Tier | Sync Direction |
|---------------|-----------|----------------|
| Color variables | Primitive + Semantic | Figma → Code (via Tokens Studio) |
| Number variables | Spacing, radius, sizing | Figma → Code |
| String variables | Font family | Figma → Code |
| Modes (Light/Dark) | Semantic tier | Bidirectional |

**Versioning strategy:**

| Strategy | When | Example |
|----------|------|---------|
| SemVer for token packages | Published as npm | `@acme/tokens@2.1.0` |
| Breaking change | Removing/renaming a semantic token | Major bump |
| Non-breaking | Adding new tokens, changing primitives | Minor/patch |
| Deprecation period | 2 minor versions before removal | `/* @deprecated use --color-primary */` |

**Anti-patterns:**
- ❌ Using primitive tokens directly in components (`var(--color-blue-500)` in a button)
- ❌ Hardcoded hex values bypassing the token system
- ❌ Mixing naming conventions (`camelCase` + `kebab-case`)
- ❌ No dark theme fallback — only testing light mode
- ❌ Theme flash on load (FART — Flash of inAccurate coloR Theme)

**Checklist:**
- [ ] Three-tier token architecture (primitive → semantic → component)
- [ ] Dark mode tested with all semantic tokens
- [ ] `prefers-color-scheme` respected as default
- [ ] Theme persisted in `localStorage`, applied before paint (script in `<head>`)
- [ ] Style Dictionary (or Tokens Studio) generates CSS + JS from single source
- [ ] Token versioning with SemVer and deprecation notices
- [ ] Figma variables synced with code tokens
- [ ] No primitive tokens referenced directly in component CSS

> **Sources:** [Style Dictionary docs](https://amzn.github.io/style-dictionary/), [Tokens Studio](https://tokens.studio/), [Material Design Tokens](https://m3.material.io/foundations/design-tokens), [W3C Design Tokens Community Group](https://design-tokens.github.io/community-group/format/)

---

## AN. SEO & Structured Data UX

### 180. Semantic HTML for SEO

| Element | SEO Impact | Usage Rule |
|---------|-----------|------------|
| `<h1>` | High — defines page topic | Exactly 1 per page, contains primary keyword |
| `<h2>`–`<h6>` | Medium — content structure | Hierarchical, no skipping levels (h2→h4) |
| `<main>` | High — identifies primary content | Exactly 1 per page |
| `<article>` | High — self-contained content | Blog posts, product cards, news |
| `<nav>` | Medium — navigation identification | Label with `aria-label` if multiple |
| `<header>` / `<footer>` | Low–Medium | Page or section level |
| `<figure>` + `<figcaption>` | Medium — image context | Always pair with descriptive caption |
| `<time datetime="">` | Medium — machine-readable dates | ISO 8601 format: `2025-03-06T14:00:00Z` |
| `<address>` | Medium — contact info for nearest article/body | Business info, author contact |

### 181. JSON-LD Structured Data Schemas

```html
<!-- Product -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Premium Plan",
  "description": "Full-featured smoking cessation tracking",
  "offers": {
    "@type": "Offer",
    "price": "9.99",
    "priceCurrency": "EUR",
    "availability": "https://schema.org/InStock"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "reviewCount": "1280"
  }
}
</script>

<!-- FAQPage -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "How does cigarette tracking work?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "The watch detects smoking gestures via motion sensors..."
    }
  }]
}
</script>

<!-- BreadcrumbList -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://example.com/" },
    { "@type": "ListItem", "position": 2, "name": "Blog", "item": "https://example.com/blog" },
    { "@type": "ListItem", "position": 3, "name": "Quit Tips" }
  ]
}
</script>

<!-- HowTo -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to set up your watch",
  "step": [
    { "@type": "HowToStep", "name": "Install", "text": "Download from Play Store" },
    { "@type": "HowToStep", "name": "Pair", "text": "Open the phone app and tap Pair Watch" }
  ]
}
</script>
```

### 182. Meta Tags & Open Graph

| Tag | Value | Spec |
|-----|-------|------|
| `<title>` | 50–60 chars, primary keyword first | Google truncates at ~60 chars |
| `<meta name="description">` | 120–158 chars, action-oriented | Google may rewrite if poor |
| `<link rel="canonical">` | Absolute URL, self-referencing | Prevents duplicate content |
| `og:title` | Same as `<title>` or shorter | Max 60 chars |
| `og:description` | 2-4 sentences, compelling | Max 200 chars |
| `og:image` | **1200 × 630 px**, < 1 MB | Required for social sharing |
| `og:type` | `website`, `article`, `product` | Per page type |
| `twitter:card` | `summary_large_image` | Requires og:image |
| `twitter:site` | `@handle` | Brand Twitter |

```html
<head>
  <title>Quit Smoking Tracker — Infernal Wheel</title>
  <meta name="description" content="Track your cigarettes, detect patterns, and quit for good. Watch + phone app with AI-powered insights.">
  <link rel="canonical" href="https://infernal-wheel.app/features">
  <meta property="og:title" content="Quit Smoking Tracker — Infernal Wheel">
  <meta property="og:description" content="Track cigarettes with your smartwatch. AI-powered cessation.">
  <meta property="og:image" content="https://infernal-wheel.app/og-features.jpg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:type" content="website">
  <meta name="twitter:card" content="summary_large_image">
</head>
```

### 183. Core Web Vitals as Ranking Signal

| CWV Metric | Good | Needs Improvement | Poor | SEO Impact |
|-----------|------|-------------------|------|------------|
| LCP | ≤ 2.5s | 2.5s–4.0s | > 4.0s | Direct ranking factor |
| INP | ≤ 200ms | 200ms–500ms | > 500ms | Direct ranking factor |
| CLS | ≤ 0.1 | 0.1–0.25 | > 0.25 | Direct ranking factor |

**URL slug conventions:**

| Rule | Good | Bad |
|------|------|-----|
| Lowercase, hyphenated | `/quit-smoking-tips` | `/Quit_Smoking_Tips` |
| Short, keyword-rich | `/features/tracking` | `/page?id=42&cat=3` |
| No trailing slash inconsistency | Pick one, 301 the other | Both `/blog` and `/blog/` live |
| Transliterate accents | `/cessation-tabac` | `/cessation-tabàc` |
| Max depth 3 levels | `/blog/category/post` | `/a/b/c/d/e/post` |

**Internal linking rules:**

| Rule | Detail |
|------|--------|
| Descriptive anchor text | "Read our quit guide" not "click here" |
| Link to deep pages from high-authority pages | Home → Feature → Sub-feature |
| Max ~100 links per page | Diminishing returns beyond |
| Breadcrumbs count as internal links | Implement on all deep pages |
| Broken link audit | Monthly, use Screaming Frog or similar |

**Image alt text for SEO:**
- Describe the image content concisely (5–15 words)
- Include keyword naturally if relevant — no stuffing
- Decorative images: `alt=""`
- Complex images (charts): longer alt + `aria-describedby` for data table

**Anti-patterns:**
- ❌ Missing canonical URL → duplicate content penalties
- ❌ `og:image` smaller than 1200×630 → poor social previews
- ❌ Keyword stuffing in `<title>` or alt text
- ❌ Client-rendered-only content with no SSR/SSG → not indexed
- ❌ Blocking Googlebot with overly aggressive `robots.txt`
- ❌ Multiple `<h1>` tags on one page

**Checklist:**
- [ ] One `<h1>` per page with primary keyword
- [ ] Semantic HTML (`<main>`, `<article>`, `<nav>`, `<section>`)
- [ ] JSON-LD for Product, FAQ, Breadcrumb, HowTo, Article as applicable
- [ ] `og:image` at 1200×630px on every page
- [ ] `<link rel="canonical">` on every page
- [ ] `<title>` 50–60 chars, `<meta description>` 120–158 chars
- [ ] URL slugs lowercase, hyphenated, max 3 levels deep
- [ ] All images have descriptive `alt` (or `alt=""` for decorative)
- [ ] Core Web Vitals in "Good" range
- [ ] Internal links use descriptive anchor text

> **Sources:** [Google Search Central](https://developers.google.com/search/docs), [Schema.org](https://schema.org/), [Open Graph Protocol](https://ogp.me/), [web.dev CWV](https://web.dev/articles/vitals), [Moz Beginner's Guide to SEO](https://moz.com/beginners-guide-to-seo)

---

## AO. AI & Conversational UI

### 184. Prompt Input Patterns

| Pattern | Spec | Usage |
|---------|------|-------|
| Auto-expanding `<textarea>` | Min 44px height, max 200px, then scroll | Chat input, AI prompt |
| Placeholder copy | "Ask anything..." or "Describe what you need" | Guide first interaction |
| Submit on Enter, Shift+Enter for newline | Desktop convention | Match ChatGPT/Gemini pattern |
| Character count | Show at 80%+ of limit (e.g., `3200/4000`) | Long-form input |
| File/image attachment | Icon button left of send, drag-and-drop | Multimodal prompts |
| Suggested prompts | 2–4 pill buttons above empty input | Cold-start onboarding |

```html
<div class="prompt-input" role="search">
  <label for="ai-prompt" class="sr-only">Ask the AI assistant</label>
  <textarea id="ai-prompt"
    placeholder="Ask anything..."
    rows="1"
    aria-label="Message"
    style="min-height: 44px; max-height: 200px; resize: none;">
  </textarea>
  <button type="submit" aria-label="Send message">
    <svg><!-- send icon --></svg>
  </button>
</div>
```

### 185. Streaming Response Rendering

| Behavior | Spec | Source |
|----------|------|--------|
| Token-by-token display | Render each chunk as received via SSE/WebSocket | ChatGPT, Claude patterns |
| Cursor/caret indicator | Blinking block or `▊` at end of stream | Visual "typing" signal |
| Markdown rendering | Parse incrementally — headings, lists, code blocks | Avoid layout jumps on block completion |
| Code blocks | Syntax-highlight after block closes (`` ``` ``) | Highlight.js or Prism |
| Scroll behavior | Auto-scroll to bottom while streaming; stop if user scrolls up | User intent detection |
| Stop generation button | Visible during streaming, `Escape` key shortcut | Allow cancellation |
| Time to first token | Target < 500ms perceived (show typing indicator at 200ms) | Perceived performance |

```css
/* Streaming cursor */
.ai-response.streaming::after {
  content: '▊';
  animation: blink 1s step-end infinite;
  color: var(--color-primary);
}
@keyframes blink {
  50% { opacity: 0; }
}

/* Smooth token appearance */
.ai-response .token {
  animation: fadeIn 80ms ease-out;
}
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
```

### 186. AI Response Affordances

| Affordance | Placement | Icon |
|------------|-----------|------|
| Copy response | Top-right of response bubble | 📋 clipboard icon |
| Regenerate | Below response | ↻ refresh icon + "Regenerate" label |
| Edit prompt | On user message bubble | ✏️ pencil icon, click to edit + re-submit |
| Thumbs up / down | Below response | 👍 👎 — opens feedback form on 👎 |
| Share/export | Overflow menu (⋯) | Link, PDF, Markdown |
| Citation/sources | Inline numbered references [1][2] | Click to expand source card |
| Branch/fork | On specific response | Explore alternative from this point |

**AI vs Human indicator:**

| Signal | Implementation |
|--------|---------------|
| Avatar | Bot icon (sparkle ✦) vs user avatar |
| Label | "AI" badge on bot messages |
| Styling | Slightly different background (e.g., `--color-surface-alt`) |
| Disclaimer | "AI-generated content may contain errors" — footer of chat |

### 187. AI Loading & Error States

| State | Visual | Duration |
|-------|--------|----------|
| Thinking | 3 animated dots or shimmer bar | 0–2s typical |
| Searching/tool use | "Searching the web..." with spinner + tool name | 2–10s |
| Streaming | Token-by-token + cursor (see §185) | 5–60s |
| Error | Red inline message + retry button | Immediate |
| Rate limited | "You've reached the limit. Resets in X:XX" + countdown | Show reset time |
| Content filtered | "I can't help with that request" — neutral tone | Immediate |
| Timeout | "This is taking longer than expected" + cancel/retry | After 30s |

**Confidence indicators:**

| Pattern | Usage | Visual |
|---------|-------|--------|
| High/Medium/Low badge | When model has calibrated confidence | Color-coded pill |
| "I'm not sure, but..." | Hedging language in response | Text-based |
| Source count | "Based on 5 sources" | Numbered citations |
| Disclaimer banner | Legal/medical/financial topics | Yellow warning bar |

**Safety disclaimer patterns:**

```html
<div class="ai-disclaimer" role="note" aria-label="AI disclaimer">
  <p>⚠️ AI responses may be inaccurate. Verify important information.
     <a href="/ai-policy">Learn more</a></p>
</div>
```

**Anti-patterns:**
- ❌ No way to stop a long generation
- ❌ Streaming without auto-scroll management (user loses their place)
- ❌ AI responses visually identical to user messages
- ❌ No feedback mechanism (thumbs up/down)
- ❌ Hiding that content is AI-generated
- ❌ Claiming 100% accuracy — always include disclaimers
- ❌ Losing conversation context on page refresh

**Checklist:**
- [ ] Streaming renders token-by-token with visible cursor
- [ ] Stop/cancel button visible during generation
- [ ] AI messages visually distinct from user messages (avatar, badge, bg color)
- [ ] Regenerate + copy + feedback (👍👎) on every AI response
- [ ] Edit-and-resubmit on user messages
- [ ] Citations rendered as clickable inline references
- [ ] Error states show retry with clear message
- [ ] Safety disclaimer visible in chat interface
- [ ] Suggested prompts for empty/cold-start state
- [ ] Conversation persisted across page refresh
- [ ] `prefers-reduced-motion` disables streaming animation

> **Sources:** [OpenAI UX Guidelines](https://platform.openai.com/docs/guides), [Google Conversational Design](https://designguidelines.withgoogle.com/conversation/), [NN/g AI UX](https://www.nngroup.com/articles/ai-ux/), [Anthropic Usage Policy](https://www.anthropic.com/policies)

---

## AP. Typography Advanced (Font Pairing & Variable Fonts)

### 188. System Font Stacks

| Stack | CSS Value | Usage |
|-------|-----------|-------|
| Sans-serif system | `system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif` | Default body text |
| Serif system | `'Iowan Old Style', 'Palatino Linotype', Palatino, Georgia, serif` | Editorial, long-form |
| Monospace system | `ui-monospace, 'Cascadia Code', 'Source Code Pro', Menlo, Consolas, 'DejaVu Sans Mono', monospace` | Code blocks |
| Emoji | `'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'` | Append to any stack |

**Zero-FOUT stack (0 layout shift, 0 download):**
```css
body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont,
    'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}
```

### 189. Variable Font Axes

| Axis | Tag | Range (typical) | CSS Property |
|------|-----|-----------------|-------------|
| Weight | `wght` | 100–900 | `font-weight` |
| Width | `wdth` | 75–125 (%) | `font-stretch` |
| Italic | `ital` | 0–1 | `font-style` |
| Slant | `slnt` | -12–0 (degrees) | `font-style: oblique Xdeg` |
| Optical size | `opsz` | 8–144 (pt) | `font-optical-sizing: auto` |
| Grade | `GRAD` | -200–150 | Custom axis (`font-variation-settings`) |

```css
/* Variable font loading */
@font-face {
  font-family: 'Inter Variable';
  src: url('Inter-Variable.woff2') format('woff2-variations');
  font-weight: 100 900;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0131, U+0152-0153; /* Latin subset */
}

/* Usage with animation */
.heading {
  font-family: 'Inter Variable', system-ui, sans-serif;
  font-weight: 700;
  font-variation-settings: 'opsz' 32;
}

/* Dark mode: increase grade for consistent perceived weight */
@media (prefers-color-scheme: dark) {
  body { font-variation-settings: 'GRAD' 50; }
}
```

### 190. Font Pairing Rules

| Rule | Detail | Example Pair |
|------|--------|-------------|
| Contrast in classification | Sans + Serif, or Slab + Geometric | Inter + Lora |
| Match x-height | Pair fonts with similar x-height ratios | Roboto (0.528) + Merriweather (0.500) |
| Limit to 2 families | 3 max (heading + body + mono) | Poppins + Source Serif Pro + Fira Code |
| Same designer/foundry | Fonts designed together pair naturally | IBM Plex Sans + IBM Plex Serif |
| Avoid same category | Two geometric sans rarely work | ❌ Futura + Montserrat |
| Weight contrast | Bold headings (700) + Regular body (400) | Weight delta ≥ 200 |

**Proven pairings:**

| Heading | Body | Vibe |
|---------|------|------|
| Inter (sans) | Merriweather (serif) | Professional, readable |
| Poppins (geometric sans) | Lora (oldstyle serif) | Modern, warm |
| Space Grotesk (sans) | Source Serif Pro (serif) | Technical, editorial |
| Playfair Display (serif) | Raleway (sans) | Elegant, luxury |
| DM Sans (sans) | DM Serif Display (serif) | Cohesive, matching family |

### 191. Fallback Matching & CJK

**Fallback size matching (prevent CLS on font load):**

```css
@font-face {
  font-family: 'Inter';
  src: url('inter.woff2') format('woff2');
  font-display: swap;
  /* Match system fallback to Inter metrics */
  size-adjust: 107%;
  ascent-override: 90%;
  descent-override: 22%;
  line-gap-override: 0%;
}
```

| Property | Purpose | Typical Range |
|----------|---------|---------------|
| `size-adjust` | Scale fallback to match web font width | 90%–115% |
| `ascent-override` | Match ascender height | 80%–110% |
| `descent-override` | Match descender depth | 15%–30% |
| `line-gap-override` | Match line gap | 0%–10% |

**CJK (Chinese/Japanese/Korean) stacks:**

| Language | Stack |
|----------|-------|
| Japanese | `'Noto Sans JP', 'Hiragino Kaku Gothic ProN', 'Yu Gothic', 'Meiryo', sans-serif` |
| Chinese (Simplified) | `'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif` |
| Chinese (Traditional) | `'Noto Sans TC', 'PingFang TC', 'Microsoft JhengHei', sans-serif` |
| Korean | `'Noto Sans KR', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif` |

**CJK subsetting:** Full CJK fonts are 2–20 MB. Use unicode-range splitting:
```css
/* Split into ~100KB chunks */
@font-face {
  font-family: 'Noto Sans JP';
  src: url('noto-jp-subset1.woff2') format('woff2');
  unicode-range: U+3000-30FF; /* Katakana + punctuation */
  font-display: swap;
}
```

**Google Fonts vs Self-hosted:**

| Factor | Google Fonts | Self-hosted |
|--------|-------------|-------------|
| Setup | 1 line of CSS/HTML | Build step required |
| Cache benefit | Shared cache (removed in 2020 by browsers) | Same-origin cache |
| Privacy (GDPR) | Sends IP to Google — problematic in EU | No third-party requests ✅ |
| Performance | Extra DNS + connection | Fewer requests ✅ |
| Control | Limited subsetting | Full subsetting, `font-display` control ✅ |
| **Recommendation** | Prototyping only | **Production — always self-host** |

**Anti-patterns:**
- ❌ More than 3 font families loaded
- ❌ Loading full weight range (100–900) when only 400+700 needed
- ❌ `font-display: block` causing invisible text (FOIT)
- ❌ No fallback metrics — large CLS on font swap
- ❌ Using Google Fonts CDN in EU without consent (GDPR violation — Landgericht München ruling)
- ❌ Full CJK font file without subsetting (15 MB+ download)

**Checklist:**
- [ ] Max 2 font families (+ 1 mono if needed)
- [ ] Variable fonts used to reduce total file count
- [ ] `font-display: swap` on all `@font-face`
- [ ] Fallback metrics set (`size-adjust`, `ascent-override`) to prevent CLS
- [ ] Self-hosted in production (GDPR compliance)
- [ ] `woff2` format only (97%+ browser support)
- [ ] Subset to needed character ranges (`unicode-range`)
- [ ] `<link rel="preload" as="font" crossorigin>` for critical fonts
- [ ] Font pairs tested at body (16px) and heading (32px) sizes
- [ ] Optical sizing enabled for variable fonts (`font-optical-sizing: auto`)

> **Sources:** [Google Fonts Knowledge](https://fonts.google.com/knowledge), [MDN Variable Fonts](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_fonts/Variable_fonts_guide), [web.dev Font Best Practices](https://web.dev/articles/font-best-practices), [Fallback Font Generator](https://screenspan.net/fallback)

---

## AQ. Accessibility Testing Methodology

### 192. Automated Testing Tools

| Tool | Type | Coverage | Integration |
|------|------|----------|-------------|
| axe-core | Engine/library | ~57% of WCAG issues | Jest, Cypress, Playwright |
| Lighthouse a11y | Browser audit | Score 0–100, maps to axe rules | CI/CD via lighthouse-ci |
| Pa11y | CLI/CI tool | HTML_CodeSniffer rules | GitHub Actions, Jenkins |
| eslint-plugin-jsx-a11y | Linter | React JSX static analysis | ESLint config |
| Storybook a11y addon | Component-level | axe-core per story | Storybook |
| WAVE | Browser extension | Visual overlay of issues | Manual review |

**Cypress + axe-core example:**

```javascript
// cypress/e2e/a11y.cy.js
import 'cypress-axe';

describe('Accessibility', () => {
  it('homepage has no critical violations', () => {
    cy.visit('/');
    cy.injectAxe();
    cy.checkA11y(null, {
      runOnly: {
        type: 'tag',
        values: ['wcag2a', 'wcag2aa', 'wcag21aa']
      }
    }, (violations) => {
      violations.forEach(v =>
        cy.log(`${v.impact}: ${v.description} (${v.nodes.length} nodes)`)
      );
    });
  });
});
```

**Playwright + axe-core:**

```javascript
import AxeBuilder from '@axe-core/playwright';

test('page should pass axe', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa'])
    .analyze();
  expect(results.violations).toEqual([]);
});
```

### 193. Manual Testing Matrix

| Screen Reader | Browser | OS | Priority |
|--------------|---------|-----|----------|
| NVDA | Chrome | Windows | **P0 — highest usage** |
| JAWS | Chrome / Edge | Windows | **P0 — enterprise** |
| VoiceOver | Safari | macOS | **P0 — Apple ecosystem** |
| VoiceOver | Safari | iOS | **P1 — mobile** |
| TalkBack | Chrome | Android | **P1 — mobile** |
| Narrator | Edge | Windows | P2 |
| Orca | Firefox | Linux | P3 |

**Manual testing protocol (per page/component):**

| Check | Method | Pass Criteria |
|-------|--------|---------------|
| Keyboard-only navigation | Tab through entire page | All interactive elements reachable, logical order |
| Focus visibility | Tab through, observe focus ring | 2px+ outline, 3:1 contrast, never hidden |
| Screen reader flow | NVDA + Chrome, read page | Landmarks, headings, alt text all announced correctly |
| Zoom 200% | Ctrl+= to 200% | No content loss, no horizontal scroll |
| Zoom 400% (reflow) | 1280px viewport at 400% → 320px equivalent | Content reflows, no overlap |
| Color contrast | DevTools or Colour Contrast Analyser | 4.5:1 normal text, 3:1 large/UI |
| Color-only info | Disable colors (grayscale extension) | Info conveyed via shape/text/pattern too |
| Motion | Enable `prefers-reduced-motion` | No essential animation, no vestibular triggers |
| Pointer independence | No hover-only interactions | Everything works via keyboard/touch |
| Form errors | Submit invalid form | Errors described in text, focus moves to first error |

### 194. Bug Severity Classification

| Severity | WCAG Level | Definition | SLA |
|----------|-----------|------------|-----|
| **P0 — Blocker** | A violation | User cannot complete task (no keyboard access, missing alt on critical image, form not submittable) | Fix before release |
| **P1 — Critical** | AA violation | Major barrier (contrast fail on primary text, missing labels, broken focus order) | Fix within 1 sprint |
| **P2 — Major** | AA violation, partial | Workaround exists but degraded (poor error messaging, missing skip link) | Fix within 2 sprints |
| **P3 — Minor** | AAA or best practice | Enhancement (insufficient touch target by 2px, decorative image with redundant alt) | Backlog, fix when nearby |

**Testing cadence:**

| Activity | Frequency | Tool |
|----------|-----------|------|
| Automated axe scan | Every PR (CI) | axe-core in Playwright/Cypress |
| Lighthouse a11y audit | Weekly scheduled | lighthouse-ci |
| Manual screen reader test | Each feature release | NVDA + VoiceOver |
| Full manual audit | Quarterly | Internal or vendor |
| User testing with disabled users | Twice per year | Recruited panel (6–8 users) |
| VPAT/ACR update | Annually or after major release | Legal/compliance |

**Compliance reporting:**

| Document | Audience | Content |
|----------|----------|---------|
| VPAT (Voluntary Product Accessibility Template) | Enterprise buyers, procurement | WCAG 2.1 AA conformance per criterion |
| ACR (Accessibility Conformance Report) | Same as VPAT | Completed VPAT with evaluation results |
| Internal dashboard | Engineering team | axe violations over time, by severity |
| Remediation roadmap | Product/engineering | P0-P3 issues, assignees, target dates |

**Anti-patterns:**
- ❌ Relying only on automated testing (catches ~30–57% of issues)
- ❌ Testing only with one screen reader
- ❌ No disabled users in testing
- ❌ Treating a11y as a "phase" instead of continuous
- ❌ P0 bugs shipped to production
- ❌ No regression testing after fixes

**Checklist:**
- [ ] axe-core runs on every PR in CI, zero violations policy for P0
- [ ] Manual screen reader testing on NVDA+Chrome, VoiceOver+Safari per feature
- [ ] Keyboard-only test: all pages navigable without mouse
- [ ] Zoom to 200% and 400% tested
- [ ] Color contrast verified with tool (not eyeball)
- [ ] Bug severity P0–P3 defined and enforced in triage
- [ ] Quarterly full manual audit
- [ ] User testing with disabled users at least twice/year
- [ ] VPAT/ACR maintained and published
- [ ] Accessibility regression tests for fixed issues

> **Sources:** [axe-core](https://github.com/dequelabs/axe-core), [WebAIM Screen Reader Survey](https://webaim.org/projects/screenreadersurvey10/), [W3C WCAG-EM](https://www.w3.org/WAI/test-evaluate/conformance/wcag-em/), [Deque University](https://dequeuniversity.com/), [GOV.UK Accessibility Testing](https://www.gov.uk/service-manual/helping-people-to-use-your-service/testing-for-accessibility)

---

## AR-bis. Checkout Address & Payment UX Deep

### 195. Address Autocomplete

| Feature | Spec | Source |
|---------|------|--------|
| Provider | Google Places Autocomplete, Mapbox, Loqate | Coverage varies by region |
| Trigger | Start after 3 characters typed | Reduce API calls |
| Debounce | 300ms after keystroke | Performance |
| Dropdown | Max 5 suggestions, keyboard navigable | UX + API cost |
| Auto-fill fields | Street, city, state, postal code, country | Single selection fills all |
| Fallback | Manual entry always available | If API fails or address not found |

```html
<label for="address-search">Address</label>
<input id="address-search" type="text"
  autocomplete="street-address"
  placeholder="Start typing your address..."
  aria-autocomplete="list"
  aria-controls="address-suggestions"
  role="combobox">
<ul id="address-suggestions" role="listbox" aria-label="Address suggestions">
  <!-- Populated dynamically -->
</ul>
```

**Country-dependent field order:**

| Country | Field Order | Notes |
|---------|------------|-------|
| US | Street → Apt → City → State → ZIP | State = dropdown (50 + territories) |
| UK | Postcode → House number (lookup) → Street → City | Postcode-first lookup common |
| Japan | Postal → Prefecture → City → Ward → Block → Building | Reverse order (large → small) |
| Brazil | CEP → Street → Number → Complement → Neighborhood → City → State | CEP auto-fills city/state |
| Germany | Street + Nr → PLZ → City | Nr on same line as street |

### 196. Express Checkout & Payment Methods

| Principle | Spec |
|-----------|------|
| Express checkout position | **Above the fold**, before form — reduces abandonment by 20–35% |
| Button order | Apple Pay → Google Pay → PayPal (by platform detection) |
| "OR" divider | `<hr>` with centered text "or continue with card" |
| Saved payment methods | Radio list, last 4 digits + card brand icon, default pre-selected |
| New card form | Number → Expiry → CVC → Name (single row for expiry + CVC) |
| Card brand detection | Detect from first digits: 4=Visa, 5=MC, 34/37=Amex, 6=Discover |
| Input masking | `4242 •••• •••• 1234` with auto-advance between groups |

```html
<!-- Express checkout placement -->
<section class="express-checkout" aria-label="Express checkout">
  <button class="apple-pay-button" aria-label="Pay with Apple Pay">
    <!-- Apple Pay mark -->
  </button>
  <button class="google-pay-button" aria-label="Pay with Google Pay">
    <!-- Google Pay mark -->
  </button>
</section>

<div class="divider" role="separator">
  <span>or pay with card</span>
</div>

<form class="card-form">
  <!-- Card fields -->
</form>
```

### 197. Promo Code & Order Summary

**Promo code UX:**

| Pattern | Spec |
|---------|------|
| Placement | Collapsible "Have a promo code?" link — not an open field |
| Validation | Apply button, validate server-side, show result inline |
| Success | Green checkmark, "SAVE20 applied — $10.00 off" |
| Error | Red inline: "Code expired" or "Not valid for these items" |
| Removal | "✕ Remove" link next to applied code |
| Multiple codes | Support or clearly state "one code per order" |

**Order summary (sticky sidebar):**

| Element | Spec |
|---------|------|
| Position | Sticky sidebar on desktop (`position: sticky; top: 24px`) |
| Mobile | Collapsible summary at top, expands on tap |
| Items | Product image (64×64px), name, quantity, line price |
| Subtotal | Clear label |
| Discount | Shown in green with negative value (`-$10.00`) |
| Shipping | "Free" in green or calculated amount |
| Tax | Line item or "Calculated at next step" |
| **Total** | Bold, largest text in summary, updated live |
| CTA | "Place Order — $XX.XX" with total in button text |

### 198. Subscription Billing UI

| Element | Spec |
|---------|------|
| Plan selector | Toggle: Monthly / Annual ("Save 20%") — annual pre-selected |
| Price display | Monthly: "$9.99/mo" · Annual: "$7.99/mo billed $95.88/year" |
| Trial callout | "Start 14-day free trial — cancel anytime" above CTA |
| Payment method | Saved card with update link |
| Next billing date | "Next charge: April 6, 2026" |
| Cancel flow | Settings → Cancel → reason survey → confirm → "Active until [date]" |
| Downgrade | Show what features will be lost, allow grace period |
| Dunning | Failed payment: email → in-app banner → 3 retry attempts over 14 days |

**Anti-patterns:**
- ❌ Express checkout buttons below the fold or after the form
- ❌ Promo code field always visible and prominent (distracts, causes "coupon hunting")
- ❌ Total not updating live when promo applied
- ❌ No saved payment methods for returning users
- ❌ Requiring account creation before checkout (guest checkout mandatory)
- ❌ Hiding shipping cost until final step (top abandonment reason — Baymard 2024: 48%)
- ❌ Subscription: no easy cancel → Dark pattern, violates FTC guidelines

**Checklist:**
- [ ] Address autocomplete with fallback to manual entry
- [ ] Field order adapts to selected country
- [ ] Express checkout (Apple Pay/Google Pay) above the fold
- [ ] Card brand auto-detected from first digits
- [ ] Promo code: collapsible, validates inline, removable
- [ ] Order summary sticky on desktop, collapsible on mobile
- [ ] Total in "Place Order" button text
- [ ] Subscription: clear pricing, trial terms, easy cancel
- [ ] Guest checkout available (no forced account creation)
- [ ] `autocomplete` attributes on all payment/address fields

> **Sources:** [Baymard Institute Checkout UX](https://baymard.com/blog/checkout-usability), [Stripe Checkout Best Practices](https://stripe.com/docs/payments/checkout), [Apple Pay Web Guidelines](https://developer.apple.com/apple-pay/), [Google Pay Web Integration](https://developers.google.com/pay/api/web)

---

## AS. Content Strategy & Information Architecture

### 199. Scanning Patterns

| Pattern | Layout Shape | Best For | Source |
|---------|-------------|----------|--------|
| F-pattern | Left-heavy horizontal scans | Text-heavy pages (articles, search results) | NN/g eye tracking |
| Z-pattern | Diagonal across page | Landing pages, minimal content | NN/g |
| Layer-cake | Headings scanned, body skipped | Long-form with clear headings | NN/g |
| Spotted pattern | Fixation on specific elements | Dashboards, data-heavy pages | NN/g |

**Content writing rules:**

| Rule | Target | Source |
|------|--------|--------|
| Flesch-Kincaid grade level | 7–8 for consumer, 10–12 for professional | Readability research |
| Line length | **45–75 characters** (optimal ~66 chars) | Bringhurst, *Elements of Typographic Style* |
| Paragraph length | 3–4 sentences max for web | NN/g Scannable Content |
| Sentence length | 15–20 words average | Plain language guidelines |
| Front-loading | Key info in first 2 words of headings/bullets | Inverted pyramid |
| Active voice | 80%+ sentences active | Clarity |

### 200. Information Hierarchy & Microcopy

**Inverted pyramid for web:**

```
┌──────────────────────────────┐
│   Lead: Who/What/Why         │  ← Above fold, 25 words
├──────────────────────────────┤
│   Key details & evidence     │  ← Supporting info
├──────────────────────────────┤
│   Background & nice-to-know  │  ← For deep readers
└──────────────────────────────┘
```

**Heading hierarchy rules:**

| Rule | Detail |
|------|--------|
| Single `<h1>` | Page title, contains primary keyword |
| No skipping | h2 → h3 → h4 (never h2 → h4) |
| Scannable alone | Headings should tell the story without body text |
| Max nesting | 3–4 levels (h1–h4) for most pages |
| Heading length | 4–8 words ideal |

**Microcopy character limits:**

| Element | Max Chars | Example |
|---------|-----------|---------|
| Button label | 20 | "Start Free Trial" |
| Tooltip | 80 | "Click to copy the share link" |
| Toast/snackbar | 60 | "Changes saved successfully" |
| Form helper text | 80 | "Must be at least 8 characters" |
| Error message | 80 | "Email is already in use" |
| Empty state title | 30 | "No results found" |
| Empty state body | 80 | "Try adjusting your filters" |
| Tab label | 15 | "Analytics" |
| Badge | 10 | "New", "Beta" |
| Placeholder | 40 | "Search by name or email..." |

**Above-the-fold strategy:**

| Element | Must Be Above Fold | Purpose |
|---------|--------------------|---------|
| Value proposition | ✅ | User decides in 3–5 seconds |
| Primary CTA | ✅ | First action without scrolling |
| Navigation | ✅ | Orientation |
| Hero image/visual | ✅ if it supports value prop | Visual anchor |
| Social proof (logos) | Preferred | Trust signal |
| Long-form content | ❌ | Below fold is fine if above fold hooks |

**Checklist:**
- [ ] Flesch-Kincaid grade 7–8 for consumer content
- [ ] Line length 45–75 characters
- [ ] Inverted pyramid: key info first
- [ ] Headings are scannable alone, no levels skipped
- [ ] Microcopy within character limits per element type
- [ ] Value proposition + CTA above the fold
- [ ] Active voice in 80%+ of sentences
- [ ] Paragraphs max 3–4 sentences

> **Sources:** [NN/g F-Shaped Pattern](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/), [NN/g How Users Read](https://www.nngroup.com/articles/how-users-read-on-the-web/), [Bringhurst, *Elements of Typographic Style*](https://en.wikipedia.org/wiki/The_Elements_of_Typographic_Style), [plainlanguage.gov](https://www.plainlanguage.gov/)

---

## AT. Voice UI on Web

### 201. Web Speech API

| API | Purpose | Browser Support |
|-----|---------|----------------|
| `SpeechRecognition` | Speech-to-text | Chrome, Edge, Safari 14.1+ (webkit prefix) |
| `SpeechSynthesis` | Text-to-speech | All modern browsers |

```javascript
// Speech recognition
const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
recognition.continuous = false;
recognition.interimResults = true;
recognition.lang = 'en-US';

recognition.onresult = (event) => {
  const transcript = event.results[0][0].transcript;
  const confidence = event.results[0][0].confidence;
  searchInput.value = transcript;
  if (event.results[0].isFinal) submitSearch(transcript);
};

recognition.onerror = (event) => {
  if (event.error === 'not-allowed') showPermissionDenied();
  if (event.error === 'no-speech') showNoSpeechDetected();
};
```

### 202. Voice Search Button & Feedback

| Element | Spec |
|---------|------|
| Mic button | Inside search input, right side, 44×44px touch target |
| Icon | Microphone outline (idle), filled (listening), waveform (processing) |
| Listening visual | Pulsing ring animation (2s loop), red dot indicator |
| Interim transcription | Gray italic text updating live in input field |
| Final transcription | Black text, auto-submit or user confirms |
| Timeout | Stop listening after 5s silence, show "No speech detected" |
| Privacy notice | "Voice data is processed by [browser/service]" — first use only |

```html
<div class="search-with-voice">
  <input type="search" id="search" placeholder="Search or try voice...">
  <button id="voice-btn"
    aria-label="Search by voice"
    aria-pressed="false"
    class="voice-btn">
    <svg class="mic-icon"><!-- mic icon --></svg>
  </button>
</div>

<!-- Listening state overlay -->
<div class="voice-overlay" role="status" aria-live="assertive" hidden>
  <div class="pulse-ring"></div>
  <p class="transcript">Listening...</p>
  <button class="voice-cancel">Cancel</button>
</div>
```

```css
.pulse-ring {
  width: 80px; height: 80px;
  border: 3px solid var(--color-primary);
  border-radius: 50%;
  animation: pulse 1.5s ease-out infinite;
}
@keyframes pulse {
  0% { transform: scale(0.95); opacity: 1; }
  100% { transform: scale(1.5); opacity: 0; }
}
@media (prefers-reduced-motion: reduce) {
  .pulse-ring { animation: none; border-width: 4px; }
}
```

**Error states:**

| Error | Message | Recovery |
|-------|---------|----------|
| `not-allowed` | "Microphone access denied" | Link to browser settings |
| `no-speech` | "No speech detected. Try again." | Auto-dismiss after 3s |
| `network` | "Voice search unavailable offline" | Fallback to text input |
| `aborted` | (Silent) | User cancelled, no message |

**Anti-patterns:**
- ❌ Auto-starting microphone without user action (privacy violation, browser will block)
- ❌ No visual feedback during listening
- ❌ No cancel button during voice capture
- ❌ Ignoring `prefers-reduced-motion` on pulse animation
- ❌ No fallback when Speech API unsupported (check `'SpeechRecognition' in window`)

**Checklist:**
- [ ] Feature-detect `SpeechRecognition` before showing mic button
- [ ] Clear visual feedback during listening (pulse, waveform)
- [ ] Interim results shown live in input
- [ ] Timeout after 5s silence
- [ ] Cancel button during listening
- [ ] Error messages for denied permission, no speech, network
- [ ] Privacy notice on first use
- [ ] `aria-live="assertive"` on transcript display
- [ ] `prefers-reduced-motion` respected

> **Sources:** [MDN Web Speech API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API), [Google Voice Search UX](https://developers.google.com/search), [Can I Use SpeechRecognition](https://caniuse.com/speech-recognition)

---

## AU. Comparison Tables & Feature Matrix

### 203. Table Structure & Responsiveness

| Element | Spec | Source |
|---------|------|--------|
| Fixed first column | Product/feature name, sticky on scroll | Usability convention |
| Fixed header row | Plan names, sticky on vertical scroll | `position: sticky; top: 0` |
| Max columns | 3–4 plans visible (5 max with scroll) | Cognitive load |
| Column width | Equal width or featured column 10% wider | Visual balance |
| Row height | Min 48px, consistent per row | Readability |
| Zebra striping | Alternating row bg (`odd: #f9fafb`) | Long table readability |

```css
.comparison-table {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}
.comparison-table th:first-child,
.comparison-table td:first-child {
  position: sticky;
  left: 0;
  background: var(--color-surface);
  z-index: 1;
  min-width: 180px;
}
.comparison-table thead th {
  position: sticky;
  top: 0;
  background: var(--color-surface);
  z-index: 2;
}
```

### 204. Icons, Badges & CTA Row

| Element | Spec |
|---------|------|
| Check icon | ✅ Green checkmark (`#22c55e`) — `aria-label="Included"` |
| Cross icon | ❌ Gray or red cross (`#ef4444`) — `aria-label="Not included"` |
| Partial | `◐` half-circle or "Limited" text with tooltip |
| "Recommended" badge | Ribbon or highlighted column border, `aria-label="Recommended"` |
| Sticky CTA row | Plan CTA buttons in last row, `position: sticky; bottom: 0` |
| Color coding | Highlight recommended column with brand color bg (subtle, 5–10% opacity) |

```html
<table class="comparison-table" role="table" aria-label="Plan comparison">
  <thead>
    <tr>
      <th scope="col">Feature</th>
      <th scope="col">Free</th>
      <th scope="col" class="recommended">
        Pro <span class="badge">Recommended</span>
      </th>
      <th scope="col">Enterprise</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Cigarette tracking</th>
      <td><span aria-label="Included">✓</span></td>
      <td class="recommended"><span aria-label="Included">✓</span></td>
      <td><span aria-label="Included">✓</span></td>
    </tr>
    <tr>
      <th scope="row">AI insights</th>
      <td><span aria-label="Not included">—</span></td>
      <td class="recommended"><span aria-label="Included">✓</span></td>
      <td><span aria-label="Included">✓</span></td>
    </tr>
  </tbody>
  <tfoot class="sticky-cta">
    <tr>
      <td></td>
      <td><a href="/signup/free" class="btn btn-secondary">Get Free</a></td>
      <td class="recommended"><a href="/signup/pro" class="btn btn-primary">Start Pro Trial</a></td>
      <td><a href="/contact" class="btn btn-secondary">Contact Sales</a></td>
    </tr>
  </tfoot>
</table>
```

**Responsive collapse strategies:**

| Strategy | When | Implementation |
|----------|------|---------------|
| Horizontal scroll | 3–5 columns | `overflow-x: auto` with sticky first column |
| Stacked cards | Mobile < 640px | Each plan as a card with feature list |
| Toggle/tabs | Mobile, 3+ plans | One plan visible at a time, swipe/tab |
| Hide columns | Secondary plans | Show only Free + Recommended on mobile |

**Anti-patterns:**
- ❌ Check/cross icons without text alternatives (inaccessible)
- ❌ More than 5 columns without scroll mechanism
- ❌ No sticky header — user forgets which column is which
- ❌ CTA buttons only at top of table (scrolled away)
- ❌ Tooltip-only info without keyboard access

**Checklist:**
- [ ] First column and header row sticky
- [ ] Max 4 visible columns, horizontal scroll beyond
- [ ] ✓/— icons have `aria-label` ("Included"/"Not included")
- [ ] "Recommended" column visually highlighted
- [ ] CTA row sticky at bottom
- [ ] Responsive: cards or tabs on mobile
- [ ] Partial features explained with tooltip (keyboard accessible)
- [ ] Zebra striping on rows > 8

> **Sources:** [NN/g Comparison Tables](https://www.nngroup.com/articles/comparison-tables/), [Baymard Pricing Table UX](https://baymard.com/blog/pricing-table-design), [A11y: Tables](https://www.w3.org/WAI/tutorials/tables/)

---

## AV. FAQ & Help Center Patterns

### 205. Accordion FAQ Design

| Element | Spec |
|---------|------|
| Behavior | **One-open** (closing others) for short FAQs; **multi-open** for reference | 
| Expand/collapse icon | Chevron `>` rotating 90° or `+`/`−` toggle, right-aligned |
| Question text | 16–18px, font-weight 600, min-height 48px tap target |
| Answer text | 14–16px, max-width 700px for readability |
| Animation | `max-height` transition 200ms ease-out, or native `<details>` |
| Default state | All collapsed, or first item open |
| Keyboard | `Enter`/`Space` to toggle, `ArrowDown`/`ArrowUp` between questions |
| ARIA | `role="region"` on answer, `aria-expanded`, `aria-controls` |

```html
<!-- Native HTML accordion -->
<div class="faq-list">
  <details>
    <summary>How does cigarette detection work?</summary>
    <div class="faq-answer">
      <p>The watch uses accelerometer and gyroscope data to detect
         the hand-to-mouth gesture pattern associated with smoking...</p>
    </div>
  </details>
  <details>
    <summary>Is my data private?</summary>
    <div class="faq-answer">
      <p>All data is stored locally on your device and synced
         end-to-end encrypted to your phone...</p>
    </div>
  </details>
</div>
```

### 206. FAQ Search & Schema Markup

| Feature | Spec |
|---------|------|
| Search within FAQ | Filter questions in real-time as user types, min 10 questions to justify search |
| No-results state | "No matching questions. [Contact support →]" |
| Categories/tabs | Group by topic if > 15 questions |
| Answer length | 50–150 words ideal; link to full article for complex topics |
| "Was this helpful?" | Yes/No buttons below each answer, track per-question |
| Contact escalation | "Still need help? [Contact us →]" at bottom of FAQ page |

**schema.org FAQPage markup:**

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How does cigarette detection work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The watch uses accelerometer and gyroscope data..."
      }
    }
  ]
}
</script>
```

**Anti-patterns:**
- ❌ Accordion with nested accordions (confusing hierarchy)
- ❌ FAQ answers longer than 200 words without linking to full article
- ❌ No search on FAQ pages with 20+ questions
- ❌ "Was this helpful?" with no action on negative feedback
- ❌ FAQ as a dumping ground for unstructured content

**Checklist:**
- [ ] Native `<details>`/`<summary>` or ARIA accordion pattern
- [ ] `aria-expanded` toggled on question buttons
- [ ] Keyboard navigation (Enter/Space, arrow keys)
- [ ] Search filter if > 10 questions
- [ ] FAQPage JSON-LD schema for rich results
- [ ] Answers 50–150 words, links to full articles if longer
- [ ] "Was this helpful?" feedback on each answer
- [ ] Contact escalation CTA at page bottom
- [ ] Categories/tabs for > 15 questions

> **Sources:** [W3C Accordion Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/), [Google FAQ Rich Results](https://developers.google.com/search/docs/appearance/structured-data/faqpage), [NN/g Accordions](https://www.nngroup.com/articles/accordions-complex-content/)

---

## AW. Blog & Article Layout

### 207. Content Width & Typography

| Element | Spec | Source |
|---------|------|--------|
| Content max-width | **600–700px** (optimal: 680px / ~66 chars) | Bringhurst |
| Body font size | 18–20px for long-form reading | Readability research |
| Line height | 1.5–1.7 for body text | WCAG 1.4.12 |
| Paragraph spacing | 1em–1.5em between paragraphs | Typography convention |
| Heading spacing | 2em above, 0.5em below | Visual hierarchy |
| Image max-width | 100% of content column, or breakout to ~900px | Editorial pattern |

```css
.article-body {
  max-width: 680px;
  margin: 0 auto;
  font-size: clamp(1.125rem, 0.5vw + 1rem, 1.25rem);
  line-height: 1.65;
  color: var(--color-text);
}
.article-body > * + * { margin-top: 1.25em; }
.article-body h2 { margin-top: 2.5em; }
.article-body figure.breakout {
  max-width: 900px;
  margin-left: calc(50% - 450px);
  margin-right: calc(50% - 450px);
}
```

### 208. Sidebar, Progress & Meta

| Element | Spec |
|---------|------|
| Sticky ToC sidebar | Left or right, `position: sticky; top: 80px`, highlights active section |
| ToC visibility | Desktop only (> 1200px), collapses to dropdown on tablet |
| Reading time | `Math.ceil(wordCount / 238)` min — display near title |
| Scroll progress bar | Fixed top, 3px height, brand color, `width` tied to scroll % |
| Author byline | Avatar (40×40px) + name + date + reading time — below title |
| Share buttons | Fixed left sidebar or floating bottom on mobile |
| Share options | Copy link, Twitter/X, LinkedIn, Email (4 max) |

```javascript
// Reading time calculation
function readingTime(text) {
  const words = text.trim().split(/\s+/).length;
  return Math.ceil(words / 238); // 238 wpm average (Medium)
}

// Scroll progress bar
window.addEventListener('scroll', () => {
  const article = document.querySelector('.article-body');
  const rect = article.getBoundingClientRect();
  const progress = Math.min(1, Math.max(0,
    -rect.top / (rect.height - window.innerHeight)
  ));
  progressBar.style.width = `${progress * 100}%`;
});
```

### 209. Rich Content Elements

| Element | HTML | Spec |
|---------|------|------|
| Figure + caption | `<figure><img><figcaption>` | Caption below image, muted color, 14px |
| Code blocks | `<pre><code>` | Syntax highlighted, copy button, overflow-x scroll |
| Block quotes | `<blockquote>` | Left border 3px, italic or indent, attribution |
| Related articles | Section below article | 3 cards (image + title + date), grid layout |
| Footnotes | Superscript link → bottom section | `<a href="#fn1">[1]</a>` + back link |
| Table of contents | Ordered list of h2/h3 | Generated from heading IDs |

```html
<figure>
  <img src="chart.png" alt="Monthly cigarette consumption declining over 6 months"
       width="680" height="400" loading="lazy">
  <figcaption>Fig. 1 — Average daily cigarettes per month, showing 60% reduction
    after 6 months of tracking.</figcaption>
</figure>
```

**Anti-patterns:**
- ❌ Content wider than 75 characters per line (hard to track to next line)
- ❌ Body font size < 16px
- ❌ No heading IDs (can't link to sections)
- ❌ Share buttons covering content on mobile
- ❌ Auto-playing videos in article body
- ❌ Reading time missing or calculated wrong (images add ~12s each)

**Checklist:**
- [ ] Content max-width 600–700px
- [ ] Body font 18–20px, line-height 1.5–1.7
- [ ] Reading time displayed (words/238 + image time)
- [ ] Scroll progress bar (3px, fixed top)
- [ ] Sticky ToC on desktop, highlights active section
- [ ] Author byline with avatar, date, reading time
- [ ] `<figure>` + `<figcaption>` for all images
- [ ] Code blocks with syntax highlighting and copy button
- [ ] Related articles section (3 cards)
- [ ] Share buttons (max 4, including copy link)
- [ ] All headings have `id` for deep linking

> **Sources:** [Medium Typography](https://medium.design/), [Smashing Magazine Article Design](https://www.smashingmagazine.com/2020/09/readability-text-web/), [Bringhurst *Elements of Typographic Style*](https://en.wikipedia.org/wiki/The_Elements_of_Typographic_Style), [web.dev Content Width](https://web.dev/articles/responsive-web-design-basics)

---

## AX. Gallery & Portfolio Layout

### 210. Layout Modes

| Mode | Best For | CSS Method |
|------|----------|-----------|
| Masonry | Mixed aspect ratios, Pinterest-style | `columns: 3` + `break-inside: avoid`, or CSS Grid masonry (experimental) |
| Justified grid | Photo gallery, equal row heights | Flexbox with calculated widths (Flickr-style) |
| Fixed grid | Uniform thumbnails, products | `display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr))` |
| Carousel | Featured/hero images | Scroll snap, navigation arrows |

```css
/* Masonry with CSS columns */
.gallery-masonry {
  columns: 3;
  column-gap: 16px;
}
.gallery-masonry .item {
  break-inside: avoid;
  margin-bottom: 16px;
}

/* CSS aspect-ratio for fixed grid */
.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}
.gallery-grid .item {
  aspect-ratio: 4 / 3;
  overflow: hidden;
}
.gallery-grid .item img {
  width: 100%; height: 100%;
  object-fit: cover;
}

/* Responsive column count */
@media (max-width: 768px) { .gallery-masonry { columns: 2; } }
@media (max-width: 480px) { .gallery-masonry { columns: 1; } }
```

### 211. Lightbox & Interaction

| Element | Spec |
|---------|------|
| Lightbox trigger | Click on thumbnail opens full-size in modal overlay |
| Backdrop | Black 85% opacity (`rgba(0,0,0,0.85)`) |
| Navigation | Left/right arrows (48×48px), keyboard ← →, swipe on mobile |
| Close | `×` button top-right (48×48px) + `Escape` key + click backdrop |
| Counter | "3 / 24" — current position |
| Zoom | Double-click or pinch to zoom, pan when zoomed |
| Preloading | Preload next and previous images |
| ARIA | `role="dialog"`, `aria-label="Image viewer"`, focus trap |
| Thumbnails | 64×64px strip below image, scrollable, current highlighted |

**Lazy loading for galleries:**

```html
<img src="thumb-placeholder.jpg"
     data-src="full-image.jpg"
     alt="Sunset over the mountains"
     width="400" height="300"
     loading="lazy"
     decoding="async">
```

| Strategy | Trigger | Performance |
|----------|---------|-------------|
| Native `loading="lazy"` | Browser viewport proximity | Simplest, 95%+ support |
| Intersection Observer | Custom threshold (200px before viewport) | More control |
| Blur-up placeholder | Low-res inline → full swap | Perceived performance |
| LQIP (Low Quality Image Placeholder) | 20×15px inline base64 | Fastest initial paint |

**Filtering & sorting:**

| Control | Implementation |
|---------|---------------|
| Category filter | Pill buttons or dropdown, `aria-pressed` for active |
| Sort | "Newest / Oldest / Most popular" dropdown |
| Animation | CSS `transition: opacity 200ms, transform 200ms` on filter change |
| URL state | Filter reflected in URL params (`?category=landscape&sort=newest`) |
| Empty state | "No images match this filter" with reset link |

**Anti-patterns:**
- ❌ Images without explicit `width`/`height` → CLS
- ❌ Lightbox without focus trap → keyboard users escape into background
- ❌ No lazy loading on gallery pages (loads 50+ images at once)
- ❌ Lightbox images served at thumbnail resolution
- ❌ No keyboard navigation in lightbox

**Checklist:**
- [ ] `width` and `height` or `aspect-ratio` on all images
- [ ] `loading="lazy"` on below-fold images
- [ ] `object-fit: cover` for uniform grid thumbnails
- [ ] Lightbox with keyboard nav (arrows, Escape), focus trap, swipe
- [ ] Responsive column count (3 → 2 → 1)
- [ ] Filter state reflected in URL
- [ ] Image metadata (alt text, caption) displayed in lightbox
- [ ] Preload adjacent images in lightbox

> **Sources:** [CSS-Tricks Masonry Layout](https://css-tricks.com/piecing-together-approaches-for-a-css-masonry-layout/), [MDN aspect-ratio](https://developer.mozilla.org/en-US/docs/Web/CSS/aspect-ratio), [W3C Dialog Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [web.dev Lazy Loading](https://web.dev/articles/lazy-loading-images)

---

## AY. Notification Center Pattern

### 212. Bell Icon & Badge

| Element | Spec |
|---------|------|
| Icon | Bell outline (idle), filled bell (has unread) |
| Badge | Red circle, 18–20px diameter, white text 11–12px |
| Badge count | Show exact count up to 99, then "99+" |
| Badge position | Top-right of bell icon, offset 25% overlap |
| Zero unread | No badge shown (not "0") |
| `aria-label` | `"Notifications, 5 unread"` — dynamic |
| Click | Opens notification dropdown/panel |

```html
<button class="notification-bell"
  aria-label="Notifications, 5 unread"
  aria-expanded="false"
  aria-controls="notification-panel">
  <svg class="bell-icon"><!-- bell --></svg>
  <span class="badge" aria-hidden="true">5</span>
</button>
```

```css
.notification-bell { position: relative; }
.badge {
  position: absolute;
  top: -4px; right: -4px;
  min-width: 18px; height: 18px;
  padding: 0 5px;
  border-radius: 9px;
  background: #ef4444;
  color: white;
  font-size: 11px;
  font-weight: 700;
  line-height: 18px;
  text-align: center;
}
```

### 213. Notification Panel

| Element | Spec |
|---------|------|
| Panel width | 360–400px (desktop dropdown) |
| Max height | 480px, scrollable |
| Position | Anchored below bell icon, right-aligned |
| Header | "Notifications" title + "Mark all as read" link |
| Empty state | Illustration + "You're all caught up!" |
| Tabs (optional) | "All" / "Unread" / "Mentions" |
| Loading | Skeleton items (3–5) |
| Pagination | "Load older" button at bottom or infinite scroll |

**Notification item anatomy:**

| Part | Spec |
|------|------|
| Avatar/icon | 40×40px, left side |
| Title | 14–16px, bold if unread, normal if read |
| Body | 13–14px, 2 lines max, muted color |
| Timestamp | 12px, relative ("2m ago", "1h ago", "Yesterday") |
| Unread indicator | Blue dot (8px) left of item, or light blue background |
| Click target | Entire row is clickable, navigates to source |
| Actions | "×" dismiss on hover, or swipe on mobile |

```html
<div id="notification-panel" role="region" aria-label="Notifications">
  <div class="panel-header">
    <h2>Notifications</h2>
    <button class="mark-all-read">Mark all as read</button>
  </div>
  <ul class="notification-list" role="list">
    <li class="notification-item unread" role="listitem">
      <img src="avatar.jpg" alt="" width="40" height="40" class="notif-avatar">
      <div class="notif-content">
        <p class="notif-title"><strong>Marie D.</strong> reached 7 smoke-free days</p>
        <time class="notif-time" datetime="2026-03-06T10:30:00Z">2h ago</time>
      </div>
      <span class="unread-dot" aria-label="Unread"></span>
    </li>
  </ul>
</div>
```

### 214. Real-time Updates & Grouping

| Feature | Implementation |
|---------|---------------|
| Real-time delivery | WebSocket or Server-Sent Events (SSE) |
| New notification | Prepend to list + increment badge + optional sound |
| Sound | Only if user opted in; respect system "Do Not Disturb" |
| Grouping | "3 new followers" instead of 3 separate items |
| Group threshold | Group after 3+ of same type within 1 hour |
| Mark as read | Click = read; "Mark all as read" = batch |
| Persistence | Store read/unread state server-side |
| Browser notification | Only if granted via `Notification.requestPermission()` |

**Anti-patterns:**
- ❌ Badge showing "0" instead of hiding
- ❌ Notifications that can't be dismissed
- ❌ No "Mark all as read" when > 10 unread
- ❌ Auto-playing notification sounds
- ❌ Each notification is a separate toast (overwhelm)
- ❌ No grouping — 50 individual "X liked your post" items

**Checklist:**
- [ ] Badge shows count up to 99, then "99+"
- [ ] `aria-label` on bell includes unread count
- [ ] Panel 360–400px, max-height 480px, scrollable
- [ ] Unread indicator (blue dot or background)
- [ ] "Mark all as read" in panel header
- [ ] Relative timestamps ("2m ago")
- [ ] Similar notifications grouped
- [ ] Empty state: illustration + positive message
- [ ] Real-time via WebSocket/SSE
- [ ] Clicking notification navigates to source and marks as read

> **Sources:** [Material Design Notifications](https://m3.material.io/), [NN/g Notifications](https://www.nngroup.com/articles/push-notification/), [W3C Notifications API](https://notifications.spec.whatwg.org/)

---

## AZ. Wizard/Stepper Visual Specs

### 215. Step Indicator Anatomy

| Part | Spec |
|------|------|
| Step circle | 32px diameter (desktop), 24px diameter (mobile) |
| Step number/icon | 14px font inside circle, or ✓ checkmark for completed |
| Step label | Below circle, 12–14px, max 2 lines, center-aligned |
| Connector line | 2px height, connects circles, fills with brand color on completion |
| Active step | Brand color fill on circle, bold label |
| Completed step | Brand color fill + white ✓ icon, normal label |
| Upcoming step | Gray border only (#d1d5db), muted label |
| Error step | Red border + ⚠ icon, error label color |

```css
.stepper {
  display: flex;
  align-items: flex-start;
  gap: 0;
}
.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  position: relative;
}
.step-circle {
  width: 32px; height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  border: 2px solid var(--color-border);
  background: var(--color-surface);
  color: var(--color-text-muted);
}
.step.active .step-circle {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}
.step.completed .step-circle {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}
.step-connector {
  position: absolute;
  top: 16px; /* half of circle */
  left: calc(50% + 16px);
  right: calc(-50% + 16px);
  height: 2px;
  background: var(--color-border);
}
.step.completed + .step .step-connector,
.step.completed .step-connector {
  background: var(--color-primary);
}
.step-label {
  margin-top: 8px;
  font-size: 13px;
  text-align: center;
  max-width: 100px;
}
```

### 216. Stepper Variants & Behavior

| Variant | Usage | Spec |
|---------|-------|------|
| Horizontal linear | Short forms (3–5 steps) | Default — must complete in order |
| Horizontal non-linear | Settings, profile setup | Clickable completed + upcoming steps |
| Vertical | Mobile, complex forms (6+ steps) | Label + optional description right of circle |
| Compact / dots | Mobile when labels aren't needed | 8px dots, no labels, progress bar alternative |

**Vertical stepper (mobile-friendly):**

```html
<ol class="stepper vertical" aria-label="Setup progress">
  <li class="step completed" aria-current="false">
    <div class="step-circle" aria-hidden="true">✓</div>
    <div class="step-content">
      <span class="step-label">Account</span>
      <span class="step-description">Email and password</span>
    </div>
  </li>
  <li class="step active" aria-current="step">
    <div class="step-circle" aria-hidden="true">2</div>
    <div class="step-content">
      <span class="step-label">Profile</span>
      <span class="step-description">Name and preferences</span>
    </div>
  </li>
  <li class="step upcoming">
    <div class="step-circle" aria-hidden="true">3</div>
    <div class="step-content">
      <span class="step-label">Connect Watch</span>
    </div>
  </li>
</ol>
```

**ARIA for stepper:**

| Attribute | Element | Value |
|-----------|---------|-------|
| `role="list"` / `<ol>` | Stepper container | Ordered step list |
| `aria-current="step"` | Active step `<li>` | Identifies current step |
| `aria-label` | Container | "Setup progress, step 2 of 3" |
| `aria-disabled="true"` | Upcoming step links (non-linear) | Not yet available |

**Anti-patterns:**
- ❌ More than 7 steps in a wizard (split into sections)
- ❌ No way to go back to previous steps
- ❌ Losing form data when navigating between steps
- ❌ Step labels that don't fit (truncated)
- ❌ Horizontal stepper on mobile without scrolling or adaptation

**Checklist:**
- [ ] Step circle 32px desktop, 24px mobile
- [ ] Connector line 2px, fills on completion
- [ ] Clear visual states: completed (✓), active (filled), upcoming (outline), error (red)
- [ ] `aria-current="step"` on active step
- [ ] Back navigation preserves entered data
- [ ] Max 5–7 steps (split if more)
- [ ] Vertical layout on mobile or compact dots
- [ ] Non-linear variant allows clicking completed steps

> **Sources:** [Material Design Stepper](https://m2.material.io/components/steppers), [W3C APG](https://www.w3.org/WAI/ARIA/apg/), [NN/g Wizard Pattern](https://www.nngroup.com/articles/wizards/)

---

## BA. Date & Time Pickers

### 217. Native vs Custom Picker

| Approach | Pros | Cons | When |
|----------|------|------|------|
| `<input type="date">` | Free, accessible, OS-native | Inconsistent styling, limited features | Simple forms, date of birth |
| Custom calendar picker | Full control, date ranges, presets | Complex to build accessibly | Date ranges, booking, dashboards |
| `<input type="time">` | Native, keyboard friendly | No time range, no timezone | Simple time input |
| Custom time picker | 12h/24h toggle, timezone selector | Accessibility burden | Scheduling, multi-timezone |

**Native input limitations:**

| Issue | Detail |
|-------|--------|
| `min`/`max` support | Supported but no visual indication of disabled dates |
| Styling | Cannot style the calendar dropdown (browser chrome) |
| Date range | No native date range input — need 2 inputs |
| Locale | Follows `navigator.language`, not controllable |
| Mobile | Good UX (native date wheel) |
| Desktop | Poor UX in some browsers (text input, no calendar popup before Chrome 99+) |

### 218. Custom Calendar Picker Specs

| Element | Spec |
|---------|------|
| Trigger | Input field + calendar icon button (24×24px) |
| Calendar popup | 280–320px width, 7-column grid |
| Month/year nav | `<` `>` arrows (48px touch target) + month/year label (clickable for jump) |
| Day cell | 40×40px, 14px text, border-radius 50% |
| Today | Outlined circle (no fill) |
| Selected | Brand color fill, white text |
| Disabled dates | Gray text, `pointer-events: none`, `aria-disabled="true"` |
| Hover | Light brand tint background |
| Range selection | Start + end highlighted, range cells with tinted background |
| Keyboard | Arrow keys navigate days, Enter selects, Escape closes |

```css
.calendar-grid {
  display: grid;
  grid-template-columns: repeat(7, 40px);
  gap: 2px;
}
.day-cell {
  width: 40px; height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  cursor: pointer;
  border: none;
  background: transparent;
}
.day-cell.today { border: 2px solid var(--color-primary); }
.day-cell.selected {
  background: var(--color-primary);
  color: white;
}
.day-cell.in-range {
  background: var(--color-primary-10);
  border-radius: 0;
}
.day-cell.range-start { border-radius: 50% 0 0 50%; }
.day-cell.range-end { border-radius: 0 50% 50% 0; }
.day-cell:disabled { color: var(--color-text-muted); opacity: 0.4; }
```

### 219. Time Picker & Relative Shortcuts

**12h vs 24h by locale:**

| Locale | Format | Example |
|--------|--------|---------|
| en-US | 12h | `2:30 PM` |
| en-GB, fr-FR, de-DE | 24h | `14:30` |
| ja-JP | 24h | `14:30` or `午後2:30` |

Detect from locale: `new Intl.DateTimeFormat(navigator.language, { hour: 'numeric' }).resolvedOptions().hour12`

**Relative date shortcuts (for dashboards/analytics):**

| Shortcut | Value |
|----------|-------|
| Today | Current day |
| Yesterday | Previous day |
| Last 7 days | -7d to today |
| Last 30 days | -30d to today |
| This month | 1st to today |
| Last month | Previous month full |
| Custom range | Opens calendar range picker |

**Timezone UX:**

| Pattern | Spec |
|---------|------|
| Display | Always show timezone abbreviation: "2:30 PM EST" |
| User timezone | Auto-detect via `Intl.DateTimeFormat().resolvedOptions().timeZone` |
| Multi-timezone | Dropdown to select, show equivalent in user's tz |
| Relative display | "in 2 hours" or "3 hours ago" for < 24h |

**Anti-patterns:**
- ❌ Custom date picker without keyboard navigation
- ❌ Scrolling through months/years one at a time (for birth dates — use year dropdown)
- ❌ No timezone indicator on times
- ❌ Forcing 12h format on European users (or vice versa)
- ❌ Date input requiring specific format without mask/example

**Checklist:**
- [ ] Native `<input type="date">` for simple single dates
- [ ] Custom picker for date ranges, presets, disabled dates
- [ ] Calendar popup 280–320px, 40×40px day cells
- [ ] Keyboard nav: arrows, Enter, Escape
- [ ] 12h/24h auto-detected from locale
- [ ] Relative shortcuts for dashboards ("Last 7 days")
- [ ] Timezone displayed and auto-detected
- [ ] `role="grid"` on calendar, `aria-selected` on chosen date
- [ ] Birth date: year dropdown (not month-by-month scroll)
- [ ] Date range: visual indication of selected range

> **Sources:** [W3C Date Picker APG](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/), [Material Design Date Pickers](https://m3.material.io/components/date-pickers), [Intl.DateTimeFormat MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat)

---

## BB. Conditional Forms & Multi-step Logic

### 220. Show/Hide Fields

| Technique | When | Implementation |
|-----------|------|----------------|
| CSS `display: none` | Simple toggle, no layout shift risk | `hidden` attribute or `.hidden` class |
| CSS `visibility: hidden` + height collapse | Animated show/hide | `max-height` + `overflow: hidden` transition |
| DOM insertion | Complex branching with many variants | Render conditionally (React/Vue) |
| `<fieldset>` + `disabled` | Group of fields, prevent submission of hidden | Native form behavior |

```html
<!-- Toggle shipping address -->
<label>
  <input type="checkbox" id="diff-address"
    aria-controls="shipping-fields"
    aria-expanded="false">
  Ship to a different address
</label>

<fieldset id="shipping-fields" hidden disabled>
  <legend>Shipping Address</legend>
  <label for="ship-street">Street</label>
  <input id="ship-street" type="text" autocomplete="shipping street-address">
  <!-- more fields -->
</fieldset>
```

```javascript
diffAddress.addEventListener('change', (e) => {
  const show = e.target.checked;
  shippingFields.hidden = !show;
  shippingFields.disabled = !show;
  e.target.setAttribute('aria-expanded', show);
  if (show) shippingFields.querySelector('input').focus();
});
```

### 221. Branching & Skip Logic

| Pattern | Implementation |
|---------|---------------|
| Binary branch | Radio "Yes"/"No" → show/hide follow-up fields |
| Multi-branch | Select/radio → different field sets based on value |
| Skip logic | If answer = X, skip step 3 entirely in wizard |
| Dependent dropdowns | Country → State → City (each loads from previous) |

**Validation rules for conditional forms:**

| Rule | Detail |
|------|--------|
| Validate visible only | Never validate `hidden` or `disabled` fields |
| Clear hidden values | When hiding fields, clear their values (avoid ghost data) |
| Re-validate on show | When showing previously hidden fields, run validation |
| Required conditionally | `required` attribute added/removed dynamically |

```javascript
// Clear values when hiding fields
function hideFieldset(fieldset) {
  fieldset.hidden = true;
  fieldset.disabled = true;
  fieldset.querySelectorAll('input, select, textarea').forEach(input => {
    input.value = '';
    input.removeAttribute('required');
    input.setCustomValidity('');
  });
}
```

### 222. Progress Indicator for Branching

| Scenario | Progress Behavior |
|----------|-------------------|
| Linear (no branching) | "Step 2 of 5" — fixed total |
| With skip logic | "Step 2 of 4" — total adjusts dynamically |
| Complex branching | Percentage bar (no step count) — avoids confusion |
| Unknown length | "Almost done..." qualitative indicator |

**`aria-live` for dynamic fields:**

```html
<!-- Announce new fields to screen readers -->
<div aria-live="polite" aria-atomic="false" class="sr-only" id="form-announcer">
  <!-- Populated via JS when fields appear/disappear -->
</div>
```

```javascript
function announceFieldChange(message) {
  const announcer = document.getElementById('form-announcer');
  announcer.textContent = message; // e.g., "Shipping address fields added"
}
```

**Anti-patterns:**
- ❌ Validating hidden/disabled fields → confusing errors for invisible fields
- ❌ Not clearing hidden field values → submitting ghost data
- ❌ Progress saying "Step 2 of 5" then jumping to "Step 2 of 3" on branch
- ❌ No `aria-expanded` on triggering control
- ❌ Focus not moved to new fields after reveal
- ❌ Dependent dropdown not resetting when parent changes

**Checklist:**
- [ ] Hidden fields use `hidden` + `disabled` (not just CSS)
- [ ] Only visible fields are validated
- [ ] Hidden field values cleared on hide
- [ ] `aria-expanded` on trigger, `aria-controls` pointing to target
- [ ] `aria-live="polite"` announces new fields to screen readers
- [ ] Focus moved to first new field on reveal
- [ ] Progress indicator adjusts to branch path
- [ ] Dependent dropdowns reset when parent changes
- [ ] Required attributes added/removed dynamically

> **Sources:** [W3C Forms Tutorial](https://www.w3.org/WAI/tutorials/forms/), [NN/g Conditional Form Fields](https://www.nngroup.com/articles/conditional-form-fields/), [MDN aria-expanded](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-expanded)

---

## BC. Scroll Animations & Scroll-linked Experiences

### 223. CSS Scroll-driven Animations

```css
/* Scroll progress bar (pure CSS, no JS) */
.progress-bar {
  position: fixed;
  top: 0; left: 0;
  width: 100%;
  height: 3px;
  background: var(--color-primary);
  transform-origin: left;
  animation: scaleX linear;
  animation-timeline: scroll();
}
@keyframes scaleX {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
}

/* Element reveal on scroll (CSS animation-timeline: view()) */
.reveal {
  animation: fadeSlideUp linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 100%;
}
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}
```

**Browser support (2026):** `animation-timeline: scroll()` — Chrome 115+, Edge 115+. Firefox behind flag. Safari: not yet. Use `@supports` for progressive enhancement.

### 224. Intersection Observer Patterns

```javascript
// Fade-in on scroll
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target); // Fire once
    }
  });
}, {
  threshold: 0.15,      // 15% visible
  rootMargin: '0px 0px -50px 0px' // Trigger 50px before entering
});

document.querySelectorAll('.animate-on-scroll').forEach(el => observer.observe(el));
```

```css
.animate-on-scroll {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 400ms ease-out, transform 400ms ease-out;
}
.animate-on-scroll.visible {
  opacity: 1;
  transform: translateY(0);
}
```

### 225. Scroll Snap & Parallax

```css
/* Scroll snap for sections */
.snap-container {
  scroll-snap-type: y mandatory;
  overflow-y: scroll;
  height: 100vh;
}
.snap-section {
  scroll-snap-align: start;
  height: 100vh;
}

/* Smooth scrolling (anchor links) */
html {
  scroll-behavior: smooth;
}
@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
}

/* CSS parallax (GPU-accelerated, no JS) */
.parallax-container {
  perspective: 1px;
  height: 100vh;
  overflow-x: hidden;
  overflow-y: auto;
}
.parallax-bg {
  transform: translateZ(-1px) scale(2);
  position: absolute;
  inset: 0;
  z-index: -1;
}
```

**Performance rules:**

| Rule | Detail | Source |
|------|--------|--------|
| Only animate `transform` and `opacity` | Avoids layout/paint | Chrome DevTools |
| Use `will-change` sparingly | `will-change: transform` on animated elements only | MDN |
| Debounce scroll handlers | 16ms (requestAnimationFrame) if using JS | Performance |
| Avoid layout thrashing | Batch reads before writes | Paul Irish |
| Test on low-end devices | Target 60fps on mid-range Android | web.dev |

**`prefers-reduced-motion` handling:**

```css
@media (prefers-reduced-motion: reduce) {
  .animate-on-scroll,
  .parallax-bg,
  .reveal {
    animation: none !important;
    transition: none !important;
    transform: none !important;
    opacity: 1 !important;
  }
  .snap-container {
    scroll-snap-type: none;
  }
}
```

**Anti-patterns:**
- ❌ Animating `width`, `height`, `top`, `left` on scroll (layout thrashing)
- ❌ Parallax with JS `scroll` event without `requestAnimationFrame`
- ❌ Scroll-jacking (overriding native scroll behavior)
- ❌ Mandatory scroll-snap without escape hatch
- ❌ Animations that prevent content from being read/used
- ❌ Ignoring `prefers-reduced-motion`

**Checklist:**
- [ ] Scroll animations use `transform` + `opacity` only
- [ ] Intersection Observer for reveal animations (not scroll event)
- [ ] CSS `animation-timeline: scroll()` with `@supports` fallback
- [ ] `prefers-reduced-motion: reduce` removes all scroll animations
- [ ] Parallax uses CSS `perspective` method (not JS)
- [ ] `scroll-behavior: smooth` with reduced-motion override
- [ ] 60fps on mid-range devices tested
- [ ] Content accessible without animations (progressive enhancement)

> **Sources:** [web.dev Scroll-driven Animations](https://developer.chrome.com/docs/css-ui/scroll-driven-animations), [MDN Intersection Observer](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API), [web.dev CSS Scroll Snap](https://web.dev/articles/css-scroll-snap), [Paul Lewis Rendering Performance](https://web.dev/articles/rendering-performance)

---

## BD. Print Styles

### 226. Page Setup & Layout

```css
@media print {
  @page {
    size: A4;
    margin: 20mm 15mm 25mm 15mm; /* top right bottom left */
  }
  @page :first {
    margin-top: 30mm; /* Extra space on first page for header */
  }

  body {
    font-family: Georgia, 'Times New Roman', serif;
    font-size: 12pt;
    line-height: 1.5;
    color: #000;
    background: #fff;
  }
}
```

### 227. Hiding & Showing Elements

| Action | CSS | What |
|--------|-----|------|
| Hide interactive elements | `display: none !important` | Nav, footer, sidebar, buttons, forms |
| Hide decorative | `display: none !important` | Background images, icons, ads |
| Show URLs for links | `a[href]::after { content: " (" attr(href) ")"; }` | External links |
| Show abbreviations | `abbr[title]::after { content: " (" attr(title) ")"; }` | Acronyms |
| Force backgrounds | `color-adjust: exact; -webkit-print-color-adjust: exact;` | Charts, badges |

```css
@media print {
  /* Hide non-printable elements */
  nav, footer, .sidebar, .cookie-banner, .fab,
  button:not(.print-btn), .share-buttons,
  video, iframe, .scroll-to-top,
  .notification-bell, .chat-widget {
    display: none !important;
  }

  /* Show link URLs */
  a[href^="http"]::after {
    content: " (" attr(href) ")";
    font-size: 10pt;
    color: #555;
    word-break: break-all;
  }
  /* Don't show for internal/anchor links */
  a[href^="#"]::after,
  a[href^="/"]::after,
  a[href^="javascript"]::after {
    content: none;
  }

  /* Page break control */
  h1, h2, h3 {
    break-after: avoid;    /* Don't leave heading at bottom of page */
    page-break-after: avoid;
  }
  table, figure, blockquote {
    break-inside: avoid;   /* Don't split across pages */
    page-break-inside: avoid;
  }
  p {
    orphans: 3;  /* Min lines at bottom of page */
    widows: 3;   /* Min lines at top of next page */
  }
}
```

### 228. Invoice / Document Template

```css
@media print {
  .invoice {
    max-width: 100%;
    padding: 0;
  }
  .invoice-header {
    display: flex;
    justify-content: space-between;
    border-bottom: 2pt solid #000;
    padding-bottom: 10mm;
    margin-bottom: 10mm;
  }
  .invoice-table {
    width: 100%;
    border-collapse: collapse;
  }
  .invoice-table th,
  .invoice-table td {
    border: 0.5pt solid #ccc;
    padding: 4mm 3mm;
    text-align: left;
    font-size: 10pt;
  }
  .invoice-total {
    font-size: 14pt;
    font-weight: bold;
    text-align: right;
  }
}
```

**Anti-patterns:**
- ❌ Not providing print styles at all
- ❌ Printing interactive elements (buttons, inputs, nav)
- ❌ Background images printing as blank areas
- ❌ Headers/footers orphaned from their content
- ❌ Tables splitting mid-row across pages
- ❌ Links showing as colored text with no URL

**Checklist:**
- [ ] `@page` margins set (20mm typical)
- [ ] Body in serif font, 12pt, black on white
- [ ] Nav, footer, buttons, ads hidden
- [ ] Link URLs shown via `::after` pseudo-element
- [ ] `break-inside: avoid` on tables, figures, blockquotes
- [ ] `break-after: avoid` on headings
- [ ] `orphans: 3; widows: 3` on paragraphs
- [ ] `color-adjust: exact` for charts/badges that need backgrounds
- [ ] Test in Chrome Print Preview + actual print

> **Sources:** [MDN @page](https://developer.mozilla.org/en-US/docs/Web/CSS/@page), [MDN break-inside](https://developer.mozilla.org/en-US/docs/Web/CSS/break-inside), [Smashing Magazine Print CSS](https://www.smashingmagazine.com/2018/05/print-stylesheets-in-2018/), [A List Apart CSS for Print](https://alistapart.com/article/goingtoprint/)

---

## BE. Email Design Patterns

### 229. Email Layout Fundamentals

| Spec | Value | Source |
|------|-------|--------|
| Max width | **600px** (some go 640px) | Email client rendering |
| Layout method | **Table-based** (`<table>`) — not div/flex/grid | Outlook, Gmail compatibility |
| CSS | **Inline** (`style=""`) — Gmail strips `<style>` in some contexts | Gmail, Yahoo |
| Images | Host externally, `display: block`, always include `alt` | Images often blocked by default |
| Font stack | System fonts: `Arial, Helvetica, sans-serif` or `Georgia, serif` | Web fonts unreliable |
| Background color | Set on `<body>` AND outer `<table>` | Outlook fallback |

```html
<!-- Email boilerplate structure -->
<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light dark">
  <meta name="supported-color-schemes" content="light dark">
  <title>Your Subject Line</title>
  <!--[if mso]>
  <style>table { border-collapse: collapse; }</style>
  <![endif]-->
</head>
<body style="margin:0; padding:0; background:#f4f4f4;">
  <!-- Preheader text (hidden, shown in inbox preview) -->
  <div style="display:none; max-height:0; overflow:hidden;">
    Preview text goes here (40-130 chars)...
    &nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj; <!-- padding -->
  </div>

  <table role="presentation" width="100%" cellpadding="0" cellspacing="0"
    style="background:#f4f4f4;">
    <tr><td align="center" style="padding: 20px 10px;">
      <!-- Inner container -->
      <table role="presentation" width="600" cellpadding="0" cellspacing="0"
        style="background:#ffffff; border-radius:8px;">
        <!-- Header, Body, Footer rows -->
      </table>
    </td></tr>
  </table>
</body>
</html>
```

### 230. CTA Button & Responsive Email

**Bulletproof button (works in Outlook):**

```html
<table role="presentation" cellpadding="0" cellspacing="0" style="margin:0 auto;">
  <tr>
    <td style="border-radius:6px; background:#3b82f6;" align="center">
      <a href="https://example.com/cta"
        target="_blank"
        style="display:inline-block;
          padding: 14px 32px;
          font-family: Arial, sans-serif;
          font-size: 16px;
          font-weight: bold;
          color: #ffffff;
          text-decoration: none;
          border-radius: 6px;
          min-height: 44px;
          line-height: 44px;">
        Start Your Free Trial
      </a>
    </td>
  </tr>
</table>
```

**Responsive email (fluid hybrid method):**

```html
<!-- Fluid column that stacks on mobile -->
<table role="presentation" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <!--[if mso]><table role="presentation"><tr><td width="280"><![endif]-->
      <div style="display:inline-block; width:100%; max-width:280px;
        vertical-align:top;">
        <!-- Column 1 content -->
      </div>
      <!--[if mso]></td><td width="280"><![endif]-->
      <div style="display:inline-block; width:100%; max-width:280px;
        vertical-align:top;">
        <!-- Column 2 content -->
      </div>
      <!--[if mso]></td></tr></table><![endif]-->
    </td>
  </tr>
</table>
```

### 231. Dark Mode & Compliance

**Email dark mode:**

```css
/* In <style> block (supported clients) */
@media (prefers-color-scheme: dark) {
  .email-body { background-color: #1a1a2e !important; }
  .email-text { color: #e0e0e0 !important; }
  .email-card { background-color: #16213e !important; }
  /* Use transparent PNGs with dark-friendly colors */
}
```

| Dark Mode Behavior | Email Client |
|-------------------|-------------|
| Respects `color-scheme` meta | Apple Mail, Outlook.com |
| Auto-inverts colors | Outlook (Windows), Gmail (Android) |
| No dark mode | Some older clients |

**Compliance requirements:**

| Requirement | Law | Implementation |
|-------------|-----|----------------|
| Unsubscribe link | CAN-SPAM (US), GDPR (EU) | Footer, clearly visible, one-click |
| `List-Unsubscribe` header | RFC 8058 | `List-Unsubscribe-Post: List-Unsubscribe=One-Click` |
| Physical address | CAN-SPAM | Footer of every marketing email |
| Consent | GDPR | Double opt-in for EU subscribers |
| Preheader text | Best practice | 40–130 chars, complements subject line |

**Anti-patterns:**
- ❌ `<div>` layout (breaks Outlook)
- ❌ CSS in `<style>` only (Gmail strips it in some contexts)
- ❌ Images without `alt` text (images blocked by default)
- ❌ CTA button as image (not clickable if images blocked)
- ❌ No unsubscribe link (CAN-SPAM violation: $51,744 per email)
- ❌ Width > 600px (horizontal scroll in many clients)
- ❌ Web fonts in email (inconsistent rendering)

**Checklist:**
- [ ] Max width 600px, table-based layout
- [ ] All CSS inline (use inliner tool in build step)
- [ ] CTA button: bulletproof (table+td+a), 44px min-height, 14px+ padding
- [ ] All images have `alt` text, `display: block`
- [ ] Preheader text 40–130 chars
- [ ] System fonts only (Arial, Georgia)
- [ ] Dark mode support via `color-scheme` meta + `@media`
- [ ] Unsubscribe link in footer + `List-Unsubscribe` header
- [ ] Physical address in footer (CAN-SPAM)
- [ ] Tested in Litmus or Email on Acid (Outlook, Gmail, Apple Mail)

> **Sources:** [Litmus Email Design Guide](https://www.litmus.com/resources), [Can I Email](https://www.caniemail.com/), [Email on Acid](https://www.emailonacid.com/), [CAN-SPAM Act](https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business), [RFC 8058](https://www.rfc-editor.org/rfc/rfc8058)

---

## BF. Testimonial & Review Display

### 232. Star Rating Component

| Element | Spec |
|---------|------|
| Star size | 16–20px inline, 24–32px for focal ratings |
| Fill color | `#f59e0b` (amber/gold) for filled, `#d1d5db` (gray) for empty |
| Half stars | Clip-path or overlay technique for 0.5 increments |
| Numeric display | "4.7" next to stars + "(1,280 reviews)" |
| Accessible | `aria-label="Rated 4.7 out of 5 stars"` |
| Interactive (input) | Hover preview, click to set, keyboard 1-5, `role="radiogroup"` |

```html
<!-- Display rating (read-only) -->
<div class="rating" aria-label="Rated 4.7 out of 5 stars" role="img">
  <span class="stars" style="--rating: 4.7;" aria-hidden="true">★★★★★</span>
  <span class="rating-number">4.7</span>
  <span class="review-count">(1,280 reviews)</span>
</div>
```

```css
.stars {
  --percent: calc(var(--rating) / 5 * 100%);
  display: inline-block;
  font-size: 20px;
  letter-spacing: 2px;
  background: linear-gradient(90deg, #f59e0b var(--percent), #d1d5db var(--percent));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

### 233. Review Card & Summary

**Review card anatomy:**

| Part | Spec |
|------|------|
| Stars | 5-star display, top of card |
| Title | 16px bold, optional review title |
| Body | 14px, max 4 lines then "Read more" |
| Author | Name + "Verified Purchase" badge if applicable |
| Date | Relative or absolute date |
| Helpful votes | "Was this helpful? Yes (12) · No (2)" |
| Photo(s) | Thumbnails 64×64px below body, clickable to enlarge |
| Merchant response | Indented reply below review, labeled "Response from [Brand]" |

**Review summary histogram:**

```
5 ★ ████████████████████ 68%   (870)
4 ★ ████████             22%   (282)
3 ★ ██                    5%   (64)
2 ★ █                     3%   (38)
1 ★ ▌                     2%   (26)
```

| Element | Spec |
|---------|------|
| Bars | Brand color, proportional width |
| Clickable | Each bar filters reviews to that rating |
| Average | Large display: "4.5" with star icon |
| Total | "Based on 1,280 reviews" |

### 234. Filtering, Schema & Social Proof

**Filtering & sorting:**

| Control | Options |
|---------|---------|
| Sort | "Most Recent", "Most Helpful", "Highest Rated", "Lowest Rated" |
| Filter by rating | Click histogram bar, or dropdown |
| Filter by type | "With Photos", "Verified Purchase" |
| Search reviews | Text search within reviews (> 50 reviews) |

**Schema.org Review markup:**

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Infernal Wheel Premium",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "bestRating": "5",
    "worstRating": "1",
    "ratingCount": "1280"
  },
  "review": [{
    "@type": "Review",
    "author": { "@type": "Person", "name": "Marie D." },
    "datePublished": "2026-02-15",
    "reviewRating": { "@type": "Rating", "ratingValue": "5" },
    "reviewBody": "I quit smoking after 15 years..."
  }]
}
</script>
```

**Anti-patterns:**
- ❌ Only showing 5-star reviews (trust destruction)
- ❌ No "Verified Purchase" distinction
- ❌ Stars without numeric value or count (ambiguous)
- ❌ "Was this helpful?" with no visible vote count
- ❌ Reviews not sortable (only "most recent")
- ❌ Fake review indicators (identical language, same date)

**Checklist:**
- [ ] Star rating with numeric value + review count
- [ ] Rating histogram with clickable filtering
- [ ] Review cards: stars + body + author + date + helpful votes
- [ ] "Verified Purchase" badge for authenticated buyers
- [ ] Sort: Recent, Helpful, Highest, Lowest
- [ ] Filter by rating, photos, verified
- [ ] Merchant response capability
- [ ] Schema.org AggregateRating + Review markup
- [ ] `aria-label` on star display with rating text
- [ ] "Write a Review" CTA for authenticated users

> **Sources:** [Baymard Institute Reviews UX](https://baymard.com/blog/user-reviews-usability), [Google Review Rich Results](https://developers.google.com/search/docs/appearance/structured-data/review-snippet), [NN/g Social Proof](https://www.nngroup.com/articles/social-proof-ux/)

---

## BG. User Profile & Account Pages

### 235. Profile Layout

| Element | Spec |
|---------|------|
| Banner/cover | 100% width × 200–250px height, `object-fit: cover` |
| Avatar | 96–128px circle, overlapping banner by 50%, 3px white border |
| Name | 24–28px, bold, below avatar |
| Bio/subtitle | 14–16px, muted color, max 160 chars |
| Stats row | "Smoke-free: 42 days · Saved: €630" — horizontal pills |
| Action buttons | "Edit Profile" (primary), "Settings" (secondary) |
| Tabs | "Overview", "Activity", "Achievements", "Settings" — underline active |

```css
.profile-header {
  position: relative;
}
.profile-banner {
  width: 100%;
  height: 200px;
  object-fit: cover;
}
.profile-avatar {
  width: 128px; height: 128px;
  border-radius: 50%;
  border: 4px solid var(--color-surface);
  position: absolute;
  bottom: -64px; /* Half overlapping */
  left: 24px;
  object-fit: cover;
}
```

### 236. Avatar Upload & Editing

| Step | Spec |
|------|------|
| Trigger | Click avatar → file picker OR "Upload Photo" button |
| Accepted formats | JPEG, PNG, WebP; max 5 MB |
| Crop modal | Square crop with circular preview, zoom slider (1–3×) |
| Output size | 256×256px (stored), displayed at various sizes |
| Placeholder | Initials on brand-color circle (computed from name) |
| Loading | Spinner overlay on avatar during upload |
| Error | "File too large (max 5 MB)" or "Unsupported format" inline |

```html
<label for="avatar-upload" class="avatar-upload-trigger">
  <img src="current-avatar.jpg" alt="Your profile photo" class="avatar">
  <span class="avatar-overlay" aria-hidden="true">📷 Change</span>
</label>
<input type="file" id="avatar-upload" accept="image/jpeg,image/png,image/webp"
  class="sr-only" aria-label="Upload profile photo">
```

### 237. Account Security & Data

**Account security section:**

| Element | Spec |
|---------|------|
| Password change | Current password + new password + confirm, strength meter |
| Email change | New email → verification email → confirm — show pending state |
| 2FA/MFA | Toggle + QR code setup + recovery codes download |
| Active sessions | List: device + location + last active + "Sign out" per row |
| Connected accounts | Google, Apple, etc. — connect/disconnect + linked email shown |

**Email change flow:**

```
[Enter new email] → [Send verification] → [Check inbox banner]
→ [Click email link] → [Success: "Email updated to new@email.com"]
// Old email also receives notification of change (security)
```

**Data export & account deletion:**

| Action | Spec |
|--------|------|
| Data export | "Download My Data" → background job → email with download link |
| Format | JSON + CSV in ZIP archive |
| Timeline | "Ready within 48 hours" (GDPR: max 30 days) |
| Account deletion | "Delete Account" → confirm email + type "DELETE" → 30-day grace period |
| Grace period | "Your account will be permanently deleted on [date]. Sign in to cancel." |

**Subscription/billing section:**

| Element | Spec |
|---------|------|
| Current plan | Plan name + price + next billing date |
| Payment method | Card last 4 + expiry + "Update" link |
| Billing history | Table: date, description, amount, status, invoice PDF link |
| Upgrade/downgrade | Link to pricing page with current plan highlighted |
| Cancel | "Cancel Subscription" → reason survey → confirmation |

**Anti-patterns:**
- ❌ No confirmation email when email/password changed (security risk)
- ❌ Instant account deletion with no grace period
- ❌ Profile photo upload with no crop tool (aspect ratio issues)
- ❌ Hiding security settings behind multiple clicks
- ❌ No active session management
- ❌ Data export in proprietary format

**Checklist:**
- [ ] Profile: banner + avatar (overlapping) + name + bio + stats
- [ ] Avatar upload with crop to 256×256px, 5 MB max
- [ ] Initials placeholder when no avatar uploaded
- [ ] Email change: verification required, old email notified
- [ ] Password change: require current password, show strength meter
- [ ] 2FA setup with QR code + recovery codes
- [ ] Active sessions list with remote sign-out
- [ ] Data export in JSON/CSV (GDPR compliance)
- [ ] Account deletion: type confirmation + 30-day grace period
- [ ] Billing history with downloadable invoices

> **Sources:** [GDPR Art. 15, 17, 20](https://gdpr-info.eu/), [NIST Digital Identity Guidelines](https://pages.nist.gov/800-63-3/), [NN/g Account Settings](https://www.nngroup.com/articles/account-settings/), [Apple HIG Settings](https://developer.apple.com/design/human-interface-guidelines/settings)

---

## BH. Pricing Page Patterns (Extended)

### 238. Pricing Table Layout

| Element | Spec |
|---------|------|
| Number of plans | 3 optimal (anchor pricing), 4 max visible |
| Column width | Equal width, or featured plan 10–15% wider |
| Featured plan | Elevated card (shadow/border), "Most Popular" badge, brand color header |
| Price display | Large (32–40px), bold, with period ("/mo") smaller (16px) |
| Annual/monthly toggle | Pill toggle centered above table, "Save 20%" badge on annual |
| Feature list | 8–12 key features, ✓/— icons, grouped by category |
| CTA per plan | Aligned vertically across all columns |

**Annual vs monthly toggle:**

```html
<div class="billing-toggle" role="radiogroup" aria-label="Billing period">
  <button role="radio" aria-checked="false" data-period="monthly">
    Monthly
  </button>
  <button role="radio" aria-checked="true" data-period="annual">
    Annual <span class="save-badge">Save 20%</span>
  </button>
</div>
```

**Price display patterns:**

| Type | Display | Example |
|------|---------|---------|
| Flat monthly | `$9
## BI. Tooltip & Popover Specs

### 241. Tooltip vs Popover

| Property | Tooltip | Popover |
|----------|---------|---------|
| Purpose | Brief label/description | Rich content, interactive |
| Trigger | Hover + focus (auto) | Click/tap (manual) |
| Content | Text only, 1–2 lines | Text, links, buttons, images |
| Dismiss | Mouse leave / blur | Click outside, close button, Escape |
| ARIA role | `role="tooltip"` | `role="dialog"` or none |
| Association | `aria-describedby` | `aria-expanded` + `aria-controls` |
| Max width | 240px | 320px |
| Interactive | No — disappears on leave | Yes — user can interact with content |

### 242. Tooltip Specs

| Spec | Value |
|------|-------|
| Show delay | **300ms** hover, **0ms** focus | 
| Hide delay | **200ms** (prevents flicker when moving between trigger and tooltip) |
| Max width | 240px |
| Padding | 8px 12px |
| Font size | 13–14px |
| Background | Dark (`#1e293b`, 95% opacity) or light depending on theme |
| Text color | White on dark bg |
| Border radius | 6px |
| Arrow | 6×6px rotated square, centered on trigger edge |
| Z-index | 600 (above modals if needed) |
| Placement | Auto-flip: prefer top, flip to bottom/left/right if clipped |
| Animation | `opacity 0→1`, `translateY(4px→0)`, 150ms ease-out |

```css
[role="tooltip"] {
  position: absolute;
  max-width: 240px;
  padding: 8px 12px;
  background: #1e293b;
  color: #fff;
  font-size: 13px;
  line-height: 1.4;
  border-radius: 6px;
  z-index: 600;
  pointer-events: none; /* Tooltip is non-interactive */
  opacity: 0;
  transform: translateY(4px);
  transition: opacity 150ms ease-out, transform 150ms ease-out;
}
[role="tooltip"].visible {
  opacity: 1;
  transform: translateY(0);
}
/* Arrow */
[role="tooltip"]::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%) rotate(45deg);
  width: 10px; height: 10px;
  background: #1e293b;
}
```

```html
<button aria-describedby="tip-export" class="icon-btn">
  <svg><!-- download icon --></svg>
</button>
<div role="tooltip" id="tip-export">Export data as CSV</div>
```

### 243. Mobile Tooltip Behavior

| Platform | Behavior |
|----------|----------|
| Desktop | Hover (300ms delay) + keyboard focus |
| Touch (mobile) | **Tap to show, tap elsewhere to dismiss** |
| Long-press alternative | Long press (500ms) to show, release to dismiss |
| Alternative | Replace tooltip with inline helper text on mobile |

**Popover placement algorithm:**

1. Preferred position (e.g., `top`)
2. Check viewport boundaries (12px margin from edge)
3. Flip to opposite side if clipped
4. If still clipped, try perpendicular axes
5. Last resort: shift along axis to fit

**Anti-patterns:**
- ❌ Tooltip on touch-only element with no focus (inaccessible)
- ❌ Interactive content inside tooltip (use popover instead)
- ❌ Tooltip covering the trigger element
- ❌ No delay — flickering on mouse movement
- ❌ Tooltip text > 80 characters (use popover)
- ❌ `title` attribute as tooltip (inconsistent, no styling, 2s delay)

**Checklist:**
- [ ] `role="tooltip"` + `aria-describedby` on trigger
- [ ] 300ms show delay, 200ms hide delay
- [ ] Max width 240px, 13–14px text
- [ ] Auto-flip placement when clipped by viewport
- [ ] Non-interactive content only (text, no links/buttons)
- [ ] Keyboard accessible (shows on focus)
- [ ] Mobile: tap to show or replaced with inline text
- [ ] Animation: 150ms fade + translate
- [ ] Popovers use `aria-expanded` + click dismiss + close button

> **Sources:** [W3C Tooltip APG](https://www.w3.org/WAI/ARIA/apg/patterns/tooltip/), [Floating UI](https://floating-ui.com/), [Reach UI Tooltip](https://reach.tech/tooltip/), [Inclusive Components: Tooltips](https://inclusive-components.design/tooltips-toggletips/)

---

## BJ. Keyboard Shortcuts System

### 244. Shortcut Discovery

| Pattern | Spec |
|---------|------|
| Help shortcut | `?` (question mark) opens shortcut cheatsheet |
| Cheatsheet overlay | Modal/dialog, grouped by category, 480–640px width |
| Inline hints | Show shortcut next to menu item (e.g., "Save Ctrl+S") |
| First-use hint | Subtle banner: "Pro tip: Press ? to see keyboard shortcuts" |
| Settings page | Full list + ability to customize (power users) |

```html
<dialog id="shortcuts-dialog" aria-label="Keyboard shortcuts">
  <h2>Keyboard Shortcuts</h2>
  <section>
    <h3>General</h3>
    <dl class="shortcut-list">
      <div class="shortcut-item">
        <dt><kbd>?</kbd></dt>
        <dd>Show shortcuts</dd>
      </div>
      <div class="shortcut-item">
        <dt><kbd>Ctrl</kbd> + <kbd>K</kbd></dt>
        <dd>Open command palette</dd>
      </div>
      <div class="shortcut-item">
        <dt><kbd>/</kbd></dt>
        <dd>Focus search</dd>
      </div>
    </dl>
  </section>
  <button class="close-btn" aria-label="Close">×</button>
</dialog>
```

```css
kbd {
  display: inline-block;
  padding: 2px 8px;
  font-family: ui-monospace, monospace;
  font-size: 12px;
  line-height: 1.4;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 4px;
  box-shadow: 0 1px 0 var(--color-border);
  min-width: 24px;
  text-align: center;
}
```

### 245. Shortcut Implementation

**Modifier key display by OS:**

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| Save | `⌘ S` | `Ctrl+S` |
| Undo | `⌘ Z` | `Ctrl+Z` |
| Search | `⌘ K` | `Ctrl+K` |
| Bold | `⌘ B` | `Ctrl+B` |

```javascript
// Detect OS for display
const isMac = navigator.platform.includes('Mac');
const modKey = isMac ? '⌘' : 'Ctrl';

// Shortcut handler with scope awareness
document.addEventListener('keydown', (e) => {
  // Don't trigger in inputs/textareas
  if (e.target.matches('input, textarea, select, [contenteditable]')) return;

  // Don't conflict with browser shortcuts
  const mod = isMac ? e.metaKey : e.ctrlKey;

  if (e.key === '?' && !mod) openShortcutsDialog();
  if (e.key === '/' && !mod) { e.preventDefault(); focusSearch(); }
  if (e.key === 'k' && mod) { e.preventDefault(); openCommandPalette(); }
});
```

**Conflict avoidance:**

| Reserved (never override) | Browser/OS Function |
|---------------------------|-------------------|
| `Ctrl+T` | New tab |
| `Ctrl+W` | Close tab |
| `Ctrl+N` | New window |
| `Ctrl+L` | Address bar |
| `Ctrl+F` | Find in page |
| `Ctrl+P` | Print |
| `F5` / `Ctrl+R` | Refresh |
| `Alt+F4` | Close window (Windows) |

**Sequential shortcuts** (e.g., Gmail: `g` then `i` = go to Inbox):

```javascript
let pendingKey = null;
let pendingTimeout = null;

document.addEventListener('keydown', (e) => {
  if (e.target.matches('input, textarea')) return;
  if (pendingKey === 'g') {
    clearTimeout(pendingTimeout);
    pendingKey = null;
    if (e.key === 'i') navigateTo('/inbox');
    if (e.key === 's') navigateTo('/sent');
    return;
  }
  if (e.key === 'g') {
    pendingKey = 'g';
    pendingTimeout = setTimeout(() => { pendingKey = null; }, 1500);
  }
});
```

**Anti-patterns:**
- ❌ Overriding browser-reserved shortcuts
- ❌ No way to discover shortcuts exist
- ❌ Shortcuts firing inside text inputs
- ❌ Different shortcuts on same app across pages (inconsistent)
- ❌ No visual feedback when shortcut fires
- ❌ macOS showing "Ctrl" instead of "⌘"

**Checklist:**
- [ ] `?` opens shortcut cheatsheet
- [ ] Shortcuts grouped by category in overlay
- [ ] Modifier key displayed per OS (⌘ vs Ctrl)
- [ ] Shortcuts disabled inside `input`, `textarea`, `[contenteditable]`
- [ ] No conflicts with browser/OS reserved keys
- [ ] `<kbd>` elements for accessible shortcut display
- [ ] Visual feedback when shortcut triggers (focus, toast, etc.)
- [ ] Sequential shortcuts timeout after 1.5s
- [ ] Customizable shortcuts for power-user apps
- [ ] Shortcut hints shown in menus and tooltips

> **Sources:** [GitHub Keyboard Shortcuts](https://docs.github.com/en/get-started/accessibility/keyboard-shortcuts), [Gmail Keyboard Shortcuts](https://support.google.com/mail/answer/6594), [MDN KeyboardEvent](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent), [Mousetrap.js](https://craig.is/killing/mice)

---

## BK. High Contrast & Forced Colors

### 246. Forced Colors Mode

Windows High Contrast Mode (now "Contrast Themes") overrides all colors with system-defined values. CSS must adapt.

| System Color Keyword | Maps To | Usage |
|---------------------|---------|-------|
| `Canvas` | Background | Page/component backgrounds |
| `CanvasText` | Foreground text | Body text, headings |
| `LinkText` | Links | Anchor elements |
| `ButtonFace` | Button background | Button, input backgrounds |
| `ButtonText` | Button text | Button labels |
| `Highlight` | Selection/focus background | Selected items, focus rings |
| `HighlightText` | Selection text | Text on highlighted bg |
| `GrayText` | Disabled text | Disabled elements |

```css
@media (forced-colors: active) {
  /* Borders become critical — they're the only visible boundaries */
  .card {
    border: 1px solid ButtonText;
    /* box-shadow is stripped, background-color overridden */
  }

  /* Custom focus ring using system colors */
  :focus-visible {
    outline: 2px solid Highlight;
    outline-offset: 2px;
  }

  /* Icons need forced-color-adjust or explicit color */
  .icon svg {
    fill: ButtonText;
  }

  /* Preserve important decorative colors (use sparingly) */
  .status-badge {
    forced-color-adjust: none;
    /* Retains original colors — use only when color IS the information */
  }

  /* Images and custom graphics */
  img {
    /* Images render normally by default — no action needed */
  }

  /* Disabled states must use GrayText */
  button:disabled {
    color: GrayText;
    border-color: GrayText;
  }
}
```

### 247. Design Strategies for Forced Colors

| Strategy | Detail |
|----------|--------|
| **Border-based design** | Use visible borders (not just shadows/background) for all containers |
| **Transparent borders** | Add `border: 2px solid transparent` to elements that rely on bg color for boundaries — becomes visible in forced colors |
| **Icon visibility** | SVG icons: `fill: currentColor` works; CSS background icons: may disappear |
| **Focus indicators** | Use `outline` (not `box-shadow`) — shadows are stripped |
| **Form controls** | Ensure all inputs have visible borders |
| **Selected state** | Use `Highlight`/`HighlightText` or `border` — not just background color change |

```css
/* Transparent border trick — invisible normally, visible in forced colors */
.chip {
  background: var(--color-primary-10);
  border: 2px solid transparent; /* Becomes system color in forced-colors */
  border-radius: 16px;
  padding: 4px 12px;
}

/* Selected tab — ensure visible without color */
.tab[aria-selected="true"] {
  border-bottom: 3px solid var(--color-primary);
  /* In forced-colors, border-bottom becomes Highlight */
}

/* Toggle/switch — don't rely on background alone */
.toggle-track {
  border: 2px solid ButtonText;
  border-radius: 12px;
}
.toggle-thumb {
  background: ButtonText; /* System color */
  border: 2px solid Canvas;
}
```

### 248. Testing Forced Colors

| Method | Steps |
|--------|-------|
| Windows | Settings → Accessibility → Contrast Themes → select "Aquatic", "Desert", "Dusk", or "Night Sky" |
| Chrome DevTools | Rendering tab → "Emulate CSS media feature forced-colors" → active |
| Firefox | about:config → `ui.use_standins_for_native_colors` → true |
| Edge | Same as Chrome DevTools |
| Automated | `@media (forced-colors: active)` in Playwright: `page.emulateMedia({ forcedColors: 'active' })` |

**Testing checklist for forced colors:**

| Check | Pass Criteria |
|-------|---------------|
| Cards/containers | All have visible borders |
| Buttons | Visible boundary + text legible |
| Icons | All SVG icons visible (using currentColor or explicit system color) |
| Focus rings | `outline` visible on all interactive elements |
| Form inputs | Borders visible, checked state distinguishable |
| Selected/active states | Distinguished by border/outline, not just bg color |
| Disabled states | Use `GrayText` system color |
| Images | Render without artifacts |

**Anti-patterns:**
- ❌ Relying on `box-shadow` for visual boundaries (stripped in forced colors)
- ❌ Icons using CSS `background-image` with no fallback (may disappear)
- ❌ Custom focus styles using only `box-shadow` (use `outline`)
- ❌ States distinguished only by background color (invisible)
- ❌ Overusing `forced-color-adjust: none` (defeats the purpose)
- ❌ Never testing in Windows High Contrast Mode

**Checklist:**
- [ ] All containers have borders (or transparent-border trick)
- [ ] SVG icons use `fill: currentColor` or explicit system color keywords
- [ ] Focus indicators use `outline`, not `box-shadow`
- [ ] Selected/active states use border or outline — not just bg color
- [ ] Disabled elements use `GrayText`
- [ ] `forced-color-adjust: none` used sparingly and only when color is essential information
- [ ] Tested in at least 2 Windows Contrast Themes (Aquatic + Night Sky)
- [ ] Tested via Chrome DevTools forced-colors emulation
- [ ] All 4 contrast themes produce usable UI

> **Sources:** [MDN forced-colors](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/forced-colors), [WCAG 1.4.11 Non-text Contrast](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html), [Microsoft High Contrast](https://learn.microsoft.com/en-us/windows/apps/design/accessibility/high-contrast-themes), [Smashing Magazine Forced Colors](https://www.smashingmagazine.com/2022/06/guide-windows-high-contrast-mode/), [a]

---

## BL. Drag & Drop Patterns

### 249. Drag Handle & Visual Feedback

| Element | Spec |
|---------|------|
| Drag handle | 6-dot grip icon (`⠿`), 24×24px, `cursor: grab` |
| Dragging cursor | `cursor: grabbing` on active drag |
| Drag preview | Semi-transparent clone (50–70% opacity) following cursor |
| Drop zone | Highlighted border (2px dashed brand color) + background tint |
| Placeholder | Empty space or line indicator where item will land |
| Animation | Items shift with 200ms ease transition to make room |

```css
.drag-item {
  cursor: grab;
  transition: box-shadow 200ms ease, opacity 200ms ease;
}
.drag-item.dragging {
  cursor: grabbing;
  opacity: 0.5;
  box-shadow: var(--shadow-lg);
}
.drop-zone.active {
  border: 2px dashed var(--color-primary);
  background: var(--color-primary-5);
}
.drag-placeholder {
  height: 2px;
  background: var(--color-primary);
  border-radius: 1px;
  margin: -1px 0;
}
```

### 250. Accessible Drag & Drop

| Requirement | Implementation |
|-------------|---------------|
| Keyboard alternative | Select item → arrow keys to move → Enter to confirm |
| Screen reader | `aria-grabbed`, `aria-dropeffect` (deprecated) → use `aria-roledescription="sortable"` + live announcements |
| Touch | Long press (500ms) to initiate, visual + haptic feedback |
| Cancel | `Escape` key returns item to original position |
| Announcements | "Grabbed item 3. Use arrow keys to move. Press Enter to drop." |

```html
<ul role="listbox" aria-label="Sortable task list" aria-roledescription="sortable list">
  <li role="option" tabindex="0" aria-roledescription="sortable item"
    aria-label="Task: Buy groceries, position 1 of 5">
    <span class="drag-handle" aria-hidden="true">⠿</span>
    Buy groceries
  </li>
</ul>
<div aria-live="assertive" class="sr-only" id="drag-announcer"></div>
```

**Anti-patterns:**
- ❌ Drag & drop as the ONLY way to reorder (must have keyboard alternative)
- ❌ No visual feedback during drag (item disappears)
- ❌ Drop zones not clearly indicated
- ❌ No cancel mechanism (Escape)
- ❌ Small drag handle without adequate touch target (min 44×44px)

**Checklist:**
- [ ] Drag handle with grip icon, `cursor: grab`/`grabbing`
- [ ] Semi-transparent preview during drag
- [ ] Drop zone highlighted with dashed border
- [ ] Smooth 200ms shift animation for sibling items
- [ ] Keyboard alternative: select + arrow keys + Enter
- [ ] `aria-live` announcements for screen readers
- [ ] Touch: long-press to initiate
- [ ] Escape cancels and restores original position
- [ ] Works with mouse, touch, and keyboard

> **Sources:** [W3C Drag and Drop APG](https://www.w3.org/WAI/ARIA/apg/patterns/), [Atlassian Pragmatic Drag and Drop](https://atlassian.design/components/pragmatic-drag-and-drop), [dnd kit](https://dndkit.com/), [Dragon Drop (accessible)](https://github.com/schne324/dragon-drop)

---

## BM. Command Palette / Omnibar

### 251. Command Palette Anatomy

| Element | Spec |
|---------|------|
| Trigger | `Ctrl+K` (Windows/Linux) / `⌘K` (macOS) |
| Overlay | Centered modal, 560–640px width, top 20% of viewport |
| Backdrop | Dark overlay 50% opacity, click to dismiss |
| Search input | Autofocused, 48px height, magnifying glass icon, placeholder "Type a command..." |
| Results list | Max 8–10 visible items, scrollable, keyboard navigable |
| Result item | Icon (20px) + label + optional description + shortcut hint (right-aligned) |
| Categories | Grouped: "Pages", "Actions", "Recent", with section headers |
| Empty state | "No results for '[query]'" |
| Dismiss | `Escape`, click backdrop, or select a result |

```html
<dialog id="command-palette" aria-label="Command palette" class="palette">
  <div class="palette-input-wrapper">
    <svg class="search-icon" aria-hidden="true"><!-- search --></svg>
    <input type="text" id="palette-search"
      placeholder="Type a command or search..."
      aria-autocomplete="list"
      aria-controls="palette-results"
      role="combobox"
      aria-expanded="true">
  </div>
  <ul id="palette-results" role="listbox" aria-label="Results">
    <li role="option" aria-selected="true" class="result active">
      <svg class="result-icon"><!-- page icon --></svg>
      <span class="result-label">Dashboard</span>
      <kbd class="result-shortcut">G D</kbd>
    </li>
    <li role="option" aria-selected="false" class="result">
      <svg class="result-icon"><!-- settings icon --></svg>
      <span class="result-label">Settings</span>
    </li>
  </ul>
</dialog>
```

```css
.palette {
  width: min(640px, 90vw);
  max-height: 480px;
  border-radius: 12px;
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-xl);
  padding: 0;
  position: fixed;
  top: 20vh;
  left: 50%;
  transform: translateX(-50%);
}
.palette-input-wrapper {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid var(--color-border);
}
.palette-input-wrapper input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 16px;
  background: transparent;
}
.result {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  cursor: pointer;
}
.result.active, .result:hover {
  background: var(--color-primary-5);
}
.result-shortcut {
  margin-left: auto;
  font-size: 12px;
  color: var(--color-text-muted);
}
```

### 252. Behavior & Fuzzy Search

| Behavior | Spec |
|----------|------|
| Fuzzy matching | Tolerate typos: "setings" → "Settings" (Levenshtein or fuse.js) |
| Ranking | Recent items first, then exact match, then fuzzy |
| Highlight matches | Bold matched characters in result label |
| Keyboard nav | `↓`/`↑` to navigate, `Enter` to select, `Escape` to close |
| Debounce | 100–150ms debounce on input |
| Recent commands | Show last 5 used commands when input is empty |
| Nested commands | Select "Theme" → sub-list: "Light / Dark / System" |
| Loading | Spinner for server-side search results |

```javascript
// Fuzzy search with Fuse.js
import Fuse from 'fuse.js';

const commands = [
  { label: 'Dashboard', category: 'Pages', shortcut: 'G D', action: () => navigate('/') },
  { label: 'Settings', category: 'Pages', shortcut: 'G S', action: () => navigate('/settings') },
  { label: 'Toggle Dark Mode', category: 'Actions', action: () => toggleTheme() },
  { label: 'Sign Out', category: 'Actions', action: () => signOut() },
];

const fuse = new Fuse(commands, {
  keys: ['label', 'category'],
  threshold: 0.4,         // Fuzzy tolerance
  includeMatches: true,    // For highlight
});

paletteInput.addEventListener('input', debounce((e) => {
  const query = e.target.value;
  const results = query ? fuse.search(query) : recentCommands;
  renderResults(results);
}, 100));
```

**Anti-patterns:**
- ❌ Command palette only works with mouse (no keyboard nav)
- ❌ No fuzzy matching — exact match only
- ❌ Palette not dismissable with Escape
- ❌ Results not grouped or categorized (overwhelming)
- ❌ No recent commands when input is empty
- ❌ Conflicting with browser `Ctrl+K` (address bar in Firefox — consider `Ctrl+/` alternative)

**Checklist:**
- [ ] `Ctrl+K` / `⌘K` trigger (with awareness of Firefox address bar conflict)
- [ ] Centered modal, 560–640px width, autofocused input
- [ ] Fuzzy search with match highlighting
- [ ] Keyboard navigation: ↑↓ + Enter + Escape
- [ ] Results grouped by category with section headers
- [ ] Recent commands shown on empty input
- [ ] Max 8–10 visible results, scrollable
- [ ] Shortcut hints right-aligned in results
- [ ] `role="combobox"` + `role="listbox"` + `aria-selected`
- [ ] 100ms debounce on search input

> **Sources:** [GitHub Command Palette](https://docs.github.com/en/get-started/accessibility/github-command-palette), [VS Code Command Palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette), [kbar (React)](https://kbar.vercel.app/), [Fuse.js](https://www.fusejs.io/), [cmdk (React)](https://cmdk.paco.me/)
## BN. Tab & Accordion Component Specs

### ARIA Tab Pattern

```html
<div role="tablist" aria-label="Account settings">
  <button role="tab" id="tab-1" aria-selected="true"
          aria-controls="panel-1" tabindex="0">Profile</button>
  <button role="tab" id="tab-2" aria-selected="false"
          aria-controls="panel-2" tabindex="-1">Security</button>
  <button role="tab" id="tab-3" aria-selected="false"
          aria-controls="panel-3" tabindex="-1">Billing</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1" tabindex="0">
  <!-- Panel content -->
</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" tabindex="0" hidden>
  <!-- Panel content -->
</div>
```

### Keyboard Interaction

| Key | Behavior |
|-----|----------|
| `ArrowRight` / `ArrowLeft` | Move focus between tabs (wrap at ends) |
| `ArrowDown` / `ArrowUp` | Move focus in vertical tablist |
| `Tab` | Move focus from active tab into its panel |
| `Home` / `End` | Jump to first / last tab |
| `Enter` / `Space` | Activate tab (manual activation mode only) |

**Automatic vs Manual Activation.** Automatic: focus follows selection (simpler for ≤5 tabs). Manual: `Enter`/`Space` required (use when panel load is expensive or >300 ms).

### Tab Overflow

```css
.tablist-scroll {
  overflow-x: auto;
  scroll-behavior: smooth;
  scrollbar-width: none;          /* Firefox */
  -ms-overflow-style: none;       /* IE/Edge */
}
.tablist-scroll::-webkit-scrollbar { display: none; }
```

Show gradient fade (24 px wide, `rgba(255,255,255,0)` → `rgba(255,255,255,1)`) on the overflow edge. Alternative: "More ▾" dropdown collecting hidden tabs when >6 tabs exist.

### Vertical Tabs

Use `aria-orientation="vertical"` on the tablist. Arrow keys switch to Up/Down. Minimum tab target: 44 × 36 px. Place vertical tablist on the **left** (LTR) with a 1 px border-right separator; panel gets `padding-left: 24px`.

### Accordion ARIA

```html
<div class="accordion">
  <h3>
    <button aria-expanded="true" aria-controls="sect-1" id="hdr-1">
      Shipping info
    </button>
  </h3>
  <div role="region" aria-labelledby="hdr-1" id="sect-1">
    <!-- Content -->
  </div>
</div>
```

**Single-open:** Set all other `aria-expanded="false"` on open. Appropriate for FAQ (reduces cognitive load).
**Multi-open:** Each item toggles independently. Better for reference/settings where users compare sections.

### Accordion Animation

```css
.accordion-body {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 250ms ease-out;
}
.accordion-body.open {
  grid-template-rows: 1fr;
}
.accordion-body > .inner {
  overflow: hidden;
}
```

Duration: **200–300 ms** (`ease-out`). Avoid `max-height` hacks — the `grid-template-rows` technique yields accurate height without JS measurement.

### Responsive Collapse: Tabs → Accordion

Below **768 px**, convert horizontal tabs to an accordion. Preserve the same `id` relationships. Use a single source of state; only the visual wrapper changes.

### Checklist

- [ ] `role="tablist"`, `role="tab"`, `role="tabpanel"` all present
- [ ] Only the active tab has `tabindex="0"`; others `tabindex="-1"`
- [ ] Arrow key navigation wraps cyclically
- [ ] Accordion buttons are inside heading elements (`h2`–`h6`)
- [ ] Animation respects `prefers-reduced-motion` (set `transition-duration: 0ms`)

> **Sources:** WAI-ARIA Authoring Practices 1.2 — Tabs Pattern; MDN — ARIA `tablist` role; Adrian Roselli, "Don't Use ARIA Menu for Nav" (2023).

---

## BO. Form Field Types Deep-Dive

### International Phone Input

```html
<div class="phone-input">
  <select aria-label="Country code" class="country-picker">
    <option value="+33" data-flag="🇫🇷">🇫🇷 +33</option>
    <option value="+1"  data-flag="🇺🇸">🇺🇸 +1</option>
  </select>
  <input type="tel" inputmode="tel" aria-label="Phone number"
         placeholder="6 12 34 56 78" autocomplete="tel-national">
</div>
```

Validate with **libphonenumber** (Google) — it handles per-country length rules, mobile vs landline, and formatting. Display flag + dial code in the picker; auto-detect country from browser locale or IP as default. Width: country picker ~80 px, number field fills remaining space.

### Currency Input

```js
const fmt = new Intl.NumberFormat('de-DE', {
  style: 'currency', currency: 'EUR',
  minimumFractionDigits: 2
});
// → "1.234,56 €"   (symbol after, comma decimal)
```

| Locale | Symbol Position | Decimal | Thousands |
|--------|----------------|---------|-----------|
| en-US  | $1,234.56      | `.`     | `,`       |
| fr-FR  | 1 234,56 €     | `,`     | ` `       |
| ja-JP  | ¥1,234         | —       | `,`       |

Store raw integer **cents** internally. Format on display only. Use `inputmode="decimal"` to get numeric keyboard with decimal point on mobile.

### Tag / Chip Input

- Commit tag on `Enter`, `,`, or `Tab`.
- `Backspace` on empty input → highlight last chip → second `Backspace` deletes it.
- Max chip width: `180px` with `text-overflow: ellipsis`.
- Autocomplete dropdown: max 6 suggestions, `role="listbox"`.
- "Create new" option at dropdown bottom when no match: `+ Add "user-input"`.

### Masked Inputs

```js
// Credit card: space every 4 digits
input.addEventListener('input', (e) => {
  let v = e.target.value.replace(/\D/g, '').substring(0, 16);
  e.target.value = v.replace(/(.{4})/g, '$1 ').trim();
});
```

| Type | Mask | `inputmode` | `autocomplete` |
|------|------|-------------|----------------|
| Credit card | `•••• •••• •••• 1234` | `numeric` | `cc-number` |
| IBAN | `FR76 •••• •••• ••••` (groups of 4) | `text` | — |
| Date | `DD / MM / YYYY` | `numeric` | `bday` |
| SSN (US) | `•••-••-1234` | `numeric` | — |

Always use `aria-describedby` pointing to a format hint: "Format: DD / MM / YYYY".

### Quantity Stepper

Min touch target: **44 × 44 px** per button. `−` and `+` flanking a centered `<input type="number">` (width ~64 px). Disable `−` at min, `+` at max, with `aria-disabled="true"` and 40 % opacity. Long-press acceleration: increment every **120 ms** after an initial **400 ms** hold.

### Slider / Range

```css
input[type="range"] {
  --track-h: 6px;
  --thumb-d: 24px;
  accent-color: var(--brand-primary);
}
```

Show current value in a tooltip above the thumb or in a linked `<output>` element. For dual-handle ranges, use two `<input>` elements with overlapping tracks (or a library like **noUiSlider**). Step granularity: price filters → step `10`; percentage → step `1`.

### Anti-Patterns

- Masking input **while user types** causing cursor jumps — always format on `blur` or use a battle-tested library.
- Using `type="number"` for phone/credit card (allows `e`, `+`, `-`; use `type="text"` + `inputmode`).
- Slider with no visible value readout.

> **Sources:** Google libphonenumber docs; MDN — `Intl.NumberFormat`; WAI — Custom Form Components; Baymard Institute — Phone Field UX (2023).

---

## BP. Urgency & Scarcity Patterns (Ethical)

### Ethical vs Dark Pattern Boundary

The line is simple: **display real data or face legal consequences**.

| Regulation | Key Rule | Penalty |
|-----------|----------|---------|
| FTC Click-to-Cancel Rule (2024) | Cancellation must be as easy as sign-up; no fake urgency | Up to $50,120 per violation |
| EU Consumer Rights Directive (2022 amend.) | Ban on fake countdown timers, fabricated reviews | Up to 4 % annual turnover |
| California ACPRA (2024) | Dark patterns void consent | Enforcement via CA AG |

### Countdown Timers

**Only for genuine deadlines:** flash sale with a real server-side end time, auction closing, registration cutoff.

```html
<div role="timer" aria-live="polite" aria-atomic="true"
     aria-label="Offer ends in">
  <span class="hours">02</span>:<span class="mins">14</span>:<span class="secs">37</span>
</div>
```

- Sync with server time (fetch `/api/deadline`), not client `Date.now()`.
- When timer reaches 0, remove the offer — never silently restart.
- `aria-live="polite"` announces changes without interrupt; update the live region every **60 s** (not every second — that's screen reader noise).

### Stock Indicators

"Only 3 left in stock" — acceptable **only** if inventory is real-time accurate. Thresholds:

| Stock Level | Display | Styling |
|-------------|---------|---------|
| > 10 | "In stock" (green) | `color: #2e7d32` |
| 3–10 | "Only X left" (amber) | `color: #e65100` |
| 0 | "Out of stock" (red, disable Add to Cart) | `color: #c62828` |

Never show "Only X left" if stock > 10. Never fabricate low numbers.

### Social Proof Urgency

"12 people viewing this right now" — must reflect **actual concurrent sessions** within a reasonable window (5 min). Round down, never up. Do not show below a threshold of 3 (feels artificial).

### Limited-Time Offers

Always state:
1. **Start date** and **end date** (with timezone).
2. **Original price** must have been charged for ≥30 consecutive days in the prior 90 days (EU Omnibus Directive 2022).
3. Discount percentage computed from that genuine prior price.

### GDPR Considerations

Urgency-driven data collection ("Sign up in the next 5 min for a bonus") must still provide clear consent mechanism. Time pressure does not exempt you from freely-given consent (GDPR Art. 7, Recital 42).

### A/B Testing Ethical Limits

- Never A/B test a **more aggressive** fake urgency variant against a truthful one.
- If an urgency experiment loses, **remove it** — don't just tweak wording.
- Document your test hypothesis and ensure the control is the user-favorable condition.

### Checklist

- [ ] Every countdown timer is synced to a real server-side deadline
- [ ] Stock numbers come from real inventory API, cached ≤60 s
- [ ] "People viewing" count is from real analytics, not random
- [ ] Prior price complies with Omnibus Directive 30-day rule
- [ ] Timer at zero removes the offer (no silent reset)
- [ ] Cancellation flow has same number of steps as signup flow

### Anti-Patterns

- Timer that resets on page reload (instant credibility loss + FTC violation).
- "Only 1 left!" shown to every user regardless of stock.
- "Offer expires soon" with no actual date.

> **Sources:** FTC Click-to-Cancel Rule, 16 CFR 425 (2024); EU Directive 2019/2161 (Omnibus); Brignull, H. — Deceptive Patterns typology (2023); CMA Online Choice Architecture report (2022).

---

## BQ. A/B Testing & Experimentation UX

### Anti-Flicker Snippet

```html
<script>
  // Place in <head> BEFORE any render-blocking CSS
  document.documentElement.style.opacity = '0';
  setTimeout(function() {
    document.documentElement.style.opacity = '';
  }, 4000); // hard cap: 4s
</script>
```

Your experimentation SDK unhides the page once the variant is applied. The `setTimeout` is a safety net — never let users stare at a blank page beyond **4 000 ms**. Typical resolution: 50–200 ms.

### Sticky Assignment

```js
// Deterministic hash: userId + experimentId → bucket
function assignBucket(userId, experimentId, buckets = 100) {
  const hash = cyrb53(userId + experimentId);
  return hash % buckets; // 0-99
}
// Store in cookie with 90-day expiry for anonymous users
document.cookie = `exp_${id}=${bucket}; max-age=7776000; path=/; SameSite=Lax`;
```

Rules: same user always sees the same variant within an experiment. On logout/login transition, re-assign by authenticated userId (not anonymous cookie) to avoid SRM.

### Experiment Scope

| Scope | Use When | Example |
|-------|----------|---------|
| Page-level | Entire layout change | New checkout flow |
| Component-level | Isolated widget | CTA button color |
| Feature flag | Backend logic change | New recommendation algo |
| Session-level | Multi-page journey | Onboarding funnel variant |

### Minimum Sample Size & Duration

Use **power analysis**: for a 5 % baseline conversion rate and a minimum detectable effect (MDE) of 10 % relative lift, you need ~**31,000 users per variant** (α = 0.05, β = 0.2). Calculators: Evan Miller's, Optimizely's Stats Engine.

| Platform | Minimum Duration |
|----------|-----------------|
| Desktop web | 7–14 days (capture weekly cycle) |
| Mobile web | 14+ days (higher variance, weekend spikes) |
| Low-traffic site (<1K/day) | 28+ days or use Bayesian approach |

**Never** call an experiment early because p < 0.05 showed up on day 2 — peeking inflates false positive rate to ~25 %.

### Avoiding SRM (Sample Ratio Mismatch)

SRM = variant group sizes differ from expected split by a statistically significant amount. Common causes:
- Bot filtering applied unevenly.
- Redirect experiments losing users on slow variants.
- Assignment happening after a lossy step (e.g., after page load, not at edge).

Check SRM with a chi-squared test: `p < 0.001` → investigate before trusting results. Tools: **SRM Checker** (lukasvermeer.nl).

### Metrics Hierarchy

| Tier | Role | Example |
|------|------|---------|
| Primary | Decision metric (1–2 only) | Conversion rate, revenue/user |
| Guardrail | Must not degrade | Page load time, error rate, bounce rate |
| Secondary | Directional insight | Click-through rate, engagement time |

### Feature Flag Cleanup

Stale flags are tech debt. Policy: remove the losing variant's code within **14 days** of experiment conclusion. Track flag age in your feature flag dashboard; alert at 30 days.

### Platform Patterns

- **Statsig:** Auto-exposure logging, warehouse-native analysis.
- **LaunchDarkly:** Strong server-side flags, targeting rules.
- **Optimizely:** Visual editor for non-eng, Stats Engine (sequential testing).

### Anti-Patterns

- No anti-flicker → variant "flash" erodes user trust and contaminates data.
- Running 15 experiments simultaneously on the same page (interaction effects).
- Using experiment results from desktop to ship on mobile (different populations).

> **Sources:** Kohavi, Tang & Xu, "Trustworthy Online Controlled Experiments" (2020); Optimizely Stats Engine whitepaper; Google — A/B testing at scale (2023); Lukas Vermeer — SRM (2019).

---

## BR. Cognitive Accessibility (WCAG 2.2+)

### WCAG 2.2 Cognitive Success Criteria

| SC | Name | Level | Requirement |
|----|------|-------|-------------|
| 3.3.7 | Redundant Entry | A | Don't re-ask info the user already provided in the same process |
| 3.3.8 | Accessible Authentication (Minimum) | AA | No cognitive function test (memorize, transcribe, calculate) for login — allow passkeys, password managers, copy-paste |
| 3.3.9 | Accessible Authentication (Enhanced) | AAA | No object/image recognition tests (no CAPTCHAs requiring image ID) |
| 3.2.6 | Consistent Help | A | Help mechanism (chat, phone, FAQ link) in same relative location on every page |

### 3.3.7 Redundant Entry Implementation

```html
<!-- Billing address same as shipping -->
<label>
  <input type="checkbox" checked id="same-address"
         aria-controls="billing-section">
  Billing address same as shipping
</label>
<!-- Pre-fill from prior step; user can edit -->
```

Auto-populate from session data. If a multi-step form collects name on step 1, do not ask again on step 3 — carry it forward and display it read-only or pre-filled.

### 3.3.8 Accessible Authentication

- Allow **paste** into password fields (`user-select: text`, no `onpaste` blockers).
- Support **password managers** via correct `autocomplete` attributes (`username`, `current-password`, `new-password`).
- Offer **passkey / WebAuthn** as primary login (no memorization needed).
- If CAPTCHA required, provide an **accessible alternative** (audio CAPTCHA, email verification).

### Plain Language

Target **Flesch-Kincaid Grade Level 7–8** for general audiences (roughly 12–13-year-old reading level).

| Metric | Target | Tool |
|--------|--------|------|
| Flesch Reading Ease | 60–70 | Hemingway Editor |
| Sentence length | ≤20 words average | readable.com |
| Paragraph length | ≤4 sentences | Manual review |
| Passive voice | <10 % | Grammarly, Hemingway |

### Predictable Navigation

- Main navigation in the **same position** on every page.
- Consistent ordering of nav items (don't rearrange based on "AI personalization" without user opt-in).
- No context changes on focus alone (WCAG 3.2.1).

### Chunked Content

Break long content into sections of **5 ± 2 items** (Miller's Law). Use:
- Clear headings every 300–400 words.
- Bulleted lists for 3+ related items.
- Progressive disclosure (show summary → expand for details).

### Timeout Extensions

WCAG 2.2.1: if a timeout exists, either warn the user **20 seconds** before and allow extension, or set the timeout to **20 hours minimum** for data-entry tasks. Banking/security exceptions exist but must be documented.

```js
// Warn 120s before session expiry
const WARNING_BEFORE = 120_000; // 2 min
setTimeout(() => {
  showModal('Your session expires in 2 minutes. Extend?', {
    extend: () => fetch('/api/session/extend'),
    save:   () => saveDraft()
  });
}, SESSION_DURATION - WARNING_BEFORE);
```

### ADHD Accommodations

- Respect `prefers-reduced-motion: reduce` — disable autoplay, parallax, carousels.
- Offer a **focused/reading mode** that strips sidebar, ads, and secondary content.
- Avoid notification badges with counts that induce anxiety (show dot, not "99+").
- Allow users to **pause** any auto-advancing content.

### Dyslexia-Friendly Typography

| Property | Recommendation |
|----------|---------------|
| Font | Atkinson Hyperlegible, OpenDyslexic, or system sans-serif |
| Size | ≥16 px body, user-scalable |
| Line height | 1.5–1.8 |
| Letter spacing | 0.05–0.12 em |
| Word spacing | ≥0.16 em |
| Line length | 50–75 characters |
| Justification | `text-align: left` (never `justify`) |

### Checklist

- [ ] No information re-asked in multi-step forms
- [ ] Password fields allow paste and autocomplete
- [ ] Help link in consistent position on all pages
- [ ] Body text at Flesch-Kincaid grade ≤8
- [ ] Session timeouts ≥20 h or offer extension dialog
- [ ] `prefers-reduced-motion` respected globally
- [ ] Line length constrained to 75ch max

> **Sources:** W3C WCAG 2.2 (2023); W3C Cognitive Accessibility Guidance (COGA); Brewer, J. — Making Content Usable for People with Cognitive Disabilities (W3C Note 2021); Rello & Baeza-Yates — Reading and Dyslexia (2016).

---

## BS. Content Security & XSS Prevention UX

### Content-Security-Policy Header

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'nonce-{random}';
  style-src 'self' 'nonce-{random}';
  img-src 'self' data: https://cdn.example.com;
  font-src 'self' https://fonts.gstatic.com;
  connect-src 'self' https://api.example.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
```

**UX Impact:** `style-src 'self'` blocks inline styles — breaks many WYSIWYG editors, charting libraries (they inject `<style>` tags), and CSS-in-JS with runtime injection. Solutions:
1. Use **nonces**: `<style nonce="abc123">` — your server generates a random nonce per request.
2. Use **hashes**: `style-src 'sha256-...'` for known static inline styles.

### DOMPurify for User HTML

```js
import DOMPurify from 'dompurify';

const clean = DOMPurify.sanitize(userHTML, {
  ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a', 'p', 'br', 'ul', 'ol', 'li'],
  ALLOWED_ATTR: ['href', 'title'],
  ALLOW_DATA_ATTR: false
});
```

Always sanitize on **both** server and client. Server-side is the authority; client-side is defense-in-depth.

### Markdown Rendering Safety

Libraries like `marked` or `markdown-it` can output raw HTML if configured to do so. Always:
- Set `sanitize: true` or pipe output through DOMPurify.
- Disable `html: true` option unless you explicitly need embedded HTML.
- Escape user-supplied link `href` values — reject `javascript:` protocol.

### Iframe Sandboxing

```html
<iframe src="https://embed.example.com"
        sandbox="allow-scripts allow-same-origin allow-popups"
        loading="lazy"
        referrerpolicy="no-referrer">
</iframe>
```

| `sandbox` value | Effect |
|-----------------|--------|
| (empty) | Maximum restriction: no scripts, no forms, no popups |
| `allow-scripts` | JS runs but no same-origin access |
| `allow-same-origin` | Treats content as same origin (combine with `allow-scripts` carefully) |
| `allow-popups` | Permits `window.open`, `target="_blank"` |
| `allow-forms` | Permits form submission |

**Never** combine `allow-scripts` + `allow-same-origin` for untrusted content — the iframe can remove its own sandbox.

### External Links

```html
<a href="https://external.com" target="_blank"
   rel="noopener noreferrer">External Link</a>
```

`noopener` prevents the opened page from accessing `window.opener`. Modern browsers apply this by default for `target="_blank"` (since Chrome 88, Firefox 79), but include it explicitly for older browser support.

### SVG Sanitization

SVGs can contain `<script>`, `<foreignObject>`, event handlers (`onload`), and `<use xlink:href="javascript:...">`. If accepting user SVGs:
- Strip all `<script>` and event attributes.
- Use DOMPurify with `{USE_PROFILES: {svg: true}}`.
- Serve user SVGs with `Content-Type: image/svg+xml` and `Content-Disposition: attachment` to prevent XSS on direct access.

### Trusted Types API

```js
// Enforce Trusted Types via CSP
// Content-Security-Policy: trusted-types myPolicy;

const policy = trustedTypes.createPolicy('myPolicy', {
  createHTML: (input) => DOMPurify.sanitize(input),
  createScriptURL: (input) => {
    if (new URL(input).origin === location.origin) return input;
    throw new Error('Blocked external script URL');
  }
});
```

Trusted Types prevent DOM XSS sinks (`innerHTML`, `eval`, `document.write`) from accepting raw strings. Supported in Chromium; polyfill available for Firefox/Safari.

### Gradual Rollout: Report-Only

```
Content-Security-Policy-Report-Only:
  default-src 'self';
  report-uri /csp-report;
  report-to csp-endpoint;
```

Deploy in `Report-Only` mode first. Monitor violations for 2–4 weeks. Fix third-party breakages. Then switch to enforcing mode.

### Anti-Patterns

- Using `unsafe-inline` and `unsafe-eval` just to make things work — defeats the entire purpose of CSP.
- Sanitizing only on the client (attacker bypasses JS entirely via API).
- Allowing user-uploaded `.svg` files to be served inline without sanitization.

> **Sources:** MDN — Content-Security-Policy; OWASP XSS Prevention Cheat Sheet (2024); DOMPurify GitHub docs; W3C Trusted Types spec; Google Web Security guidelines.

---

## BT. Web Components & Shadow DOM UX

### Custom Element Naming

Custom elements **must** contain a hyphen: `my-button`, `app-header`, `user-card`. Single-word names are reserved for future HTML elements.

```js
class MyButton extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
  }
  connectedCallback() {
    this.shadowRoot.innerHTML = `
      <style>
        :host { display: inline-flex; align-items: center; }
        :host([disabled]) { opacity: 0.4; pointer-events: none; }
        button { all: unset; padding: 8px 16px; border-radius: 4px;
                 background: var(--btn-bg, #0066cc); color: var(--btn-color, #fff);
                 font: inherit; cursor: pointer; }
        button:focus-visible { outline: 2px solid var(--focus-ring, #005fcc);
                               outline-offset: 2px; }
      </style>
      <button><slot></slot></button>
    `;
  }
}
customElements.define('my-button', MyButton);
```

### Slot Pattern for Composition

```html
<my-card>
  <img slot="avatar" src="user.jpg" alt="Profile photo">
  <span slot="title">Jane Doe</span>
  <p>Card body content goes into the default slot.</p>
</my-card>
```

Named slots (`slot="avatar"`) project specific child elements into designated locations. The default `<slot></slot>` catches all un-slotted children.

### Form-Associated Custom Elements

```js
class MyInput extends HTMLElement {
  static formAssociated = true;
  #internals;
  constructor() {
    super();
    this.#internals = this.attachInternals();
  }
  set value(v) {
    this.#internals.setFormValue(v);
  }
  get validity() { return this.#internals.validity; }
}
```

This lets `<my-input name="email">` participate in `<form>` submission, validation, and `FormData`. Essential for custom elements that replace native `<input>`.

### Accessibility in Shadow DOM

| Technique | Purpose |
|-----------|---------|
| `delegatesFocus: true` | `this.attachShadow({ mode: 'open', delegatesFocus: true })` — focus automatically moves to the first focusable element inside shadow DOM |
| `ElementInternals` ARIA | `this.#internals.role = 'slider'`; `this.#internals.ariaValueNow = '50'` — sets ARIA without polluting host attributes |
| `aria-label` on host | `<my-slider aria-label="Volume">` — works across shadow boundary |

**Key rule:** Screen readers can traverse shadow DOM, but `aria-labelledby` and `aria-describedby` references **cannot** cross shadow boundaries. Use `ElementInternals` or `aria-label` instead.

### CSS Custom Properties Crossing Shadow Boundary

CSS custom properties (`--var`) are the **only** CSS values that inherit into shadow DOM. Use them as your theming API:

```css
/* Light DOM (consumer) */
my-button {
  --btn-bg: #e91e63;
  --btn-color: #fff;
}
```

### `::part()` Selector

```js
// Inside shadow DOM:
// <button part="base">Click</button>

/* Outside — consumer styles */
my-button::part(base) {
  border-radius: 24px;
  font-weight: 600;
}
```

Expose `part` attributes on internal elements you want consumers to style. This is a controlled escape hatch — only explicitly exported parts are styleable.

### Event Propagation

Events dispatched inside shadow DOM are **retargeted**: outside listeners see the host element as `event.target`. To let events escape shadow DOM:

```js
this.shadowRoot.querySelector('button').dispatchEvent(
  new CustomEvent('my-click', { bubbles: true, composed: true })
);
```

`composed: true` is required for the event to cross the shadow boundary. Native events like `click` and `focus` are already composed.

### Anti-Patterns

- Shadow DOM for everything — don't wrap a simple `<div>` in shadow DOM; use it only when encapsulation is genuinely needed.
- Forgetting `delegatesFocus` — Tab key skips your component entirely.
- Using `::slotted()` with deep selectors (only direct children of the slot match).

> **Sources:** MDN — Web Components; W3C — Shadow DOM spec; Google Web Fundamentals — Custom Elements Best Practices; Nolan Lawson — "Shadow DOM and accessibility" (2023).

---

## BU. Multi-Device Continuity

### Cross-Device Session Handoff (QR Transfer)

```
Flow: Phone → Desktop
1. Desktop shows QR code containing a one-time token URL
   (e.g., https://app.com/handoff?token=abc123&exp=300)
2. Phone scans QR → server validates token, creates desktop session
3. Desktop polls /api/handoff/status every 2s (or uses WebSocket)
4. On confirmation, desktop redirects to authenticated state
5. Token expires in 300s; single-use only
```

Security: token is single-use, time-limited (5 min), and tied to the originating device's session. Show a **spinner with "Waiting for scan…"** on desktop, timeout after 5 min with a "Refresh code" button.

### Push-to-Device Notifications

"Continue on your phone" or "Send link to your device" — requires the user to have registered at least one other device.

```html
<button aria-label="Send this article to your phone">
  📲 Continue on phone
</button>
<!-- On click: POST /api/push-link { url, targetDeviceId } -->
```

Notification payload should deep-link to the exact scroll position or step. Use `ScrollRestoration` state or a fragment identifier (`#section-3`).

### Clipboard Sync UX

Browser-native clipboard sync (e.g., Apple Universal Clipboard, Windows clipboard history) is OS-level. For in-app clipboard sync:
- On copy: `POST /api/clipboard { text, timestamp, deviceId }`.
- On paste (other device): fetch latest clip from API, inject into focused field.
- Encrypt clipboard contents in transit and at rest (AES-256).
- Auto-expire clips after **5 minutes** for security.

### Responsive Deep Links

```
https://app.com/product/123
```

A single URL should work everywhere. On mobile, detect via `User-Agent` or feature detection and either:
1. **Redirect to app** via Universal Links (iOS) / App Links (Android).
2. **Serve responsive web** if app is not installed.
3. Show a **smart banner**: `<meta name="apple-itunes-app" content="app-id=123456">`.

### PWA Install Prompts

```js
let deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;
  showInstallButton(); // Show custom UI, not browser's default
});

installBtn.addEventListener('click', async () => {
  deferredPrompt.prompt();
  const { outcome } = await deferredPrompt.userChoice;
  // outcome: 'accepted' | 'dismissed'
  deferredPrompt = null;
});
```

Best practice: defer the prompt until a moment of high engagement (after 3rd visit, after completing a task) — not on first page load. Conversion rates improve **2–3×** with contextual prompts.

### Reading / Form Progress Sync

```js
// Save reading position every 10s
setInterval(() => {
  const progress = {
    scrollY: window.scrollY,
    maxScroll: document.body.scrollHeight,
    percentage: Math.round((scrollY / (document.body.scrollHeight - innerHeight)) * 100),
    timestamp: Date.now()
  };
  localStorage.setItem('reading_progress', JSON.stringify(progress));
  if (navigator.onLine) fetch('/api/sync/progress', {
    method: 'POST', body: JSON.stringify(progress)
  });
}, 10000);
```

On new device load: fetch `/api/sync/progress`, offer "Continue where you left off?" (don't auto-scroll without consent — it disorients users).

### Universal Login State (SSO)

- Use **OpenID Connect** for cross-device SSO with refresh tokens.
- Token refresh: access token TTL **15 min**, refresh token **30 days** (revocable).
- Show "Signed in on 3 devices" in account settings; allow remote sign-out.
- On new device login, send a push notification to existing devices: "New sign-in from Windows desktop. Was this you?"

### Anti-Patterns

- Auto-syncing clipboard without user awareness (massive privacy violation).
- QR handoff without token expiry (replay attack vector).
- Auto-scrolling to synced position without asking.

> **Sources:** Google — Web App Manifest & `beforeinstallprompt`; Apple — Universal Links docs; FIDO Alliance — Passkeys cross-device (2023); OWASP — Session Management Cheat Sheet.

---

## BV. Micro-Frontends UX Consistency

### Shared Design Token Distribution

```
Option A: npm package
  @org/design-tokens → exports CSS variables, JS constants, JSON
  Versioned (semver) → teams opt in to updates

Option B: CDN
  https://cdn.example.com/tokens/v2/tokens.css
  All micro-frontends link the same URL → instant global update
  Risk: breaking change affects everyone simultaneously
```

Recommended hybrid: **CDN for stable tokens** (colors, spacing scale), **npm for component library** (versioned, opt-in upgrades).

### Cross-Team Component Library Governance

| Role | Responsibility |
|------|---------------|
| Design System Team (2–4 people) | Maintains core components, reviews PRs, publishes releases |
| Consumer Teams | Submit component proposals via RFC, adopt within 2 sprints of release |
| UX Review Board | Monthly audit of visual consistency across micro-frontends |

Component promotion path: **Team-local → Shared proposal (RFC) → Design system core** (minimum 3 consumers before promoting).

### Consistent Loading States

All micro-frontends must use the **same skeleton/spinner** pattern from the shared library.

```css
/* Shared skeleton token */
.skeleton {
  background: linear-gradient(90deg,
    var(--skeleton-base, #e0e0e0) 25%,
    var(--skeleton-shine, #f5f5f5) 50%,
    var(--skeleton-base, #e0e0e0) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}
@keyframes shimmer { to { background-position: -200% 0; } }
```

The **app shell** renders immediately; each micro-frontend shows its own skeleton inside its container until loaded.

### Shared Authentication Shell

The **shell application** owns authentication state. Micro-frontends receive a user context object (via custom event, shared state, or module federation's shared scope):

```js
// Shell broadcasts auth state
window.dispatchEvent(new CustomEvent('auth-state', {
  detail: { userId: '123', roles: ['admin'], token: 'jwt...' }
}));
// Micro-frontend listens
window.addEventListener('auth-state', (e) => {
  setUser(e.detail);
});
```

Never let individual micro-frontends manage their own login flows.

### Navigation Consistency

The **shell manages routing**. Micro-frontends register their routes at mount:

```js
// Micro-frontend registers
shellRouter.register('/dashboard/*', () => import('dashboard/App'));
shellRouter.register('/settings/*', () => import('settings/App'));
```

Shared top-nav and breadcrumbs live in the shell. Active state highlighting is shell-controlled. Micro-frontends handle sub-routing internally.

### Error Boundaries

Each micro-frontend is wrapped in an error boundary. If one crashes, the shell shows a localized error message **without** taking down adjacent micro-frontends:

```html
<div class="mfe-container" data-app="dashboard">
  <!-- If dashboard crashes: -->
  <div class="mfe-error" role="alert">
    This section couldn't load. <button>Retry</button>
  </div>
</div>
```

### Performance Budgets

| Metric | Budget per Micro-Frontend |
|--------|--------------------------|
| JS bundle (compressed) | ≤170 KB |
| CSS | ≤30 KB |
| LCP contribution | ≤1.5 s |
| Total shared deps (React, etc.) | Loaded once via Module Federation `shared` |

Enforce via CI: `bundlesize` or `size-limit` checks on every PR.

### Module Federation / Import Maps

```js
// webpack.config.js — Module Federation
new ModuleFederationPlugin({
  name: 'dashboard',
  filename: 'remoteEntry.js',
  exposes: { './App': './src/App' },
  shared: { react: { singleton: true }, 'react-dom': { singleton: true } }
});
```

Alternative (native): **Import Maps** for ESM-based micro-frontends (no bundler required for the shell).

### Anti-Patterns

- Each micro-frontend shipping its own copy of React (50 KB × N).
- No shared loading pattern — one app uses a spinner, another a skeleton, a third a blank screen.
- Micro-frontends with their own `<header>` and `<nav>` competing with the shell.

> **Sources:** Cam Jackson — "Micro Frontends" (martinfowler.com, 2019); Webpack Module Federation docs; Luca Mezzalira — "Building Micro-Frontends" (O'Reilly, 2021); ThoughtWorks Technology Radar.

---

## BW. Drag & Drop Advanced Patterns

### Kanban Board UX

```
┌─ To Do (3) ──────┐  ┌─ In Progress (2/3) ┐  ┌─ Done ────────────┐
│ ┌──────────────┐  │  │ ┌──────────────┐   │  │ ┌──────────────┐  │
│ │ Task A       │  │  │ │ Task C       │   │  │ │ Task E       │  │
│ │ 👤 @alice    │  │  │ │ 👤 @bob      │   │  │ └──────────────┘  │
│ └──────────────┘  │  │ └──────────────┘   │  └───────────────────┘
```

- **WIP limits:** If a column has a max (e.g., 3), gray out the column header and show a warning on drop: "Column limit reached. Move an item out first." Visually: column header turns amber at limit, red when exceeded.
- **Card preview on drag:** Show a semi-transparent ghost (`opacity: 0.7`) at the card's original size. Placeholder in the source column: dashed border, same height as the card.
- **Drop indicator:** 2 px solid line (`#0066cc`) between cards at the target position.

### File Tree Drag

- **Indent levels:** Each nesting level indents `24px`. Drag ghost shows the file/folder name only (not the entire subtree).
- **Expand-on-hover:** When dragging over a collapsed folder, expand it after **500 ms** hover. Collapse it back if the user drags away before dropping.
- **Drop targets:** Highlight the target folder with a `2px` border and light background (`rgba(0, 102, 204, 0.08)`).
- **Invalid drops:** Files cannot be dropped onto themselves or their own descendants. Show `cursor: not-allowed`.

### Sortable List

```css
.drop-indicator {
  height: 2px;
  background: var(--brand-primary, #0066cc);
  border-radius: 1px;
  margin: -1px 0;
  transition: opacity 150ms;
}
```

- **Insertion line:** Horizontal 2 px bar spanning the list width, positioned between items at the nearest drop point.
- **Auto-scroll:** When the dragged item is within **40 px** of the container edge, scroll at **8 px/frame** (~480 px/s). Accelerate to **16 px/frame** within 20 px of the edge.
- **Keyboard alternative:** `Space` to pick up, `ArrowUp`/`ArrowDown` to move, `Space` to drop, `Escape` to cancel. Announce position via `aria-live`: "Item 3 of 7, moved to position 2."

### Multi-Select Drag

1. User selects multiple items (Ctrl+Click or Shift+Click).
2. On drag start, the ghost shows a **stack effect** (3 cards slightly offset) with a **badge count** (e.g., "4 items").
3. All selected items move together on drop.
4. `aria-live` announcement: "Dragging 4 items."

```css
.drag-ghost-stack {
  position: relative;
}
.drag-ghost-stack::before,
.drag-ghost-stack::after {
  content: '';
  position: absolute;
  inset: 0;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  background: var(--surface);
}
.drag-ghost-stack::before { transform: rotate(-2deg) translate(-3px, 3px); }
.drag-ghost-stack::after  { transform: rotate(1deg) translate(2px, -2px); }
.drag-badge {
  position: absolute; top: -8px; right: -8px;
  background: var(--brand-primary); color: #fff;
  border-radius: 50%; min-width: 24px; height: 24px;
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; font-weight: 600;
}
```

### Cross-Container Drag

Items draggable between different parent containers (e.g., two separate lists, or list → calendar). Implementation:
- Use a shared drag context (React DnD backend, or a global `dragData` store).
- Validate compatibility on `dragover`: does this container accept this item type?
- On drop in a new container: `POST /api/move { itemId, fromContainer, toContainer, position }`.

### Drag Constraints

```js
// Horizontal only (e.g., timeline slider)
onDrag(e) {
  const x = clamp(e.clientX - offset.x, minX, maxX);
  element.style.transform = `translateX(${x}px)`;
  // Y stays fixed
}
```

Use `cursor: ew-resize` for horizontal-only, `cursor: ns-resize` for vertical-only. Visual rails (subtle 1 px line along the axis) reinforce the constraint.

### Touch Drag

- **Activation:** Long-press **300 ms** to enter drag mode (avoids conflict with scrolling). Provide haptic feedback (`navigator.vibrate(50)`) on activation.
- **Visual cue:** Item scales to `1.05` and elevates (`box-shadow: 0 8px 24px rgba(0,0,0,0.15)`) on lift.
- **Scroll while dragging:** Same 40 px edge zone, but use `touch-action: none` on the drag container to prevent browser scroll interference.
- **Drop:** Release finger. If outside any valid target, animate item back to original position (200 ms `ease-out`).

### Undo After Drop

Every drag-and-drop action should be reversible:

```js
function onDrop(item, from, to) {
  applyMove(item, to);
  showToast(`Moved "${item.name}" to ${to.name}`, {
    action: { label: 'Undo', onClick: () => applyMove(item, from) },
    duration: 8000 // 8s to undo
  });
}
```

Toast with **"Undo"** action, visible for **8 seconds**. Also support `Ctrl+Z` to undo the last drag operation.

### Anti-Patterns

- No keyboard alternative for drag-and-drop (WCAG 2.1.1 failure).
- Drag ghost that obscures the drop target (keep ghost offset or semi-transparent).
- Touch drag activating instantly (conflicts with scroll — must use long-press).
- No undo mechanism (especially dangerous for cross-container moves).

> **Sources:** WAI-ARIA Authoring Practices — Drag & Drop; Atlassian — `@atlaskit/pragmatic-drag-and-drop` docs; React DnD documentation; Shopify Polaris — Drag & Drop guidelines; Apple HIG — Drag and Drop (adapted for web touch).

---

## BX. View Transitions API

### Overview

The View Transitions API provides a native mechanism for animated transitions between DOM states — both within a single page (SPA) and across full page navigations (MPA). Instead of manually orchestrating fade-outs, position interpolations, and fade-ins, the browser captures before/after snapshots and animates between them using CSS pseudo-elements. This dramatically reduces JavaScript complexity for page-to-page animations that previously required libraries like Barba.js or FLIP techniques.

### Same-Document Transitions (SPA)

```js
// Basic usage — wraps any DOM mutation in a transition
document.startViewTransition(() => {
  // Synchronous DOM update
  updateDOM();
});

// Async variant — wait for data before updating
document.startViewTransition(async () => {
  const data = await fetchNewContent();
  renderContent(data);
});
```

The browser:
1. Captures a screenshot of the current state (the "old" snapshot).
2. Runs your callback to mutate the DOM.
3. Captures the new state.
4. Animates from old to new using `::view-transition` pseudo-elements.

Default animation: **cross-fade** lasting **250 ms** (`ease` timing).

### Pseudo-Element Tree

```
::view-transition
  ::view-transition-group(root)
    ::view-transition-image-pair(root)
      ::view-transition-old(root)     /* screenshot of old state */
      ::view-transition-new(root)     /* live rendering of new state */
```

You can target these pseudo-elements in CSS to customize the animation:

```css
/* Fade + slide for the entire page */
::view-transition-old(root) {
  animation: 300ms ease-out both fade-out, 300ms ease-out both slide-to-left;
}
::view-transition-new(root) {
  animation: 300ms ease-out both fade-in, 300ms ease-out both slide-from-right;
}

@keyframes fade-out  { to { opacity: 0; } }
@keyframes fade-in   { from { opacity: 0; } }
@keyframes slide-to-left   { to { transform: translateX(-30px); } }
@keyframes slide-from-right { from { transform: translateX(30px); } }
```

### Named Transition Groups

Assign `view-transition-name` to elements that should animate independently (e.g., a hero image that "flies" from a list to a detail page):

```css
/* List page */
.card-thumbnail {
  view-transition-name: hero-image;
}

/* Detail page */
.detail-hero {
  view-transition-name: hero-image;
}
```

The browser matches elements with the same `view-transition-name` across states and interpolates their position, size, and transform. Each name must be **unique per page** — duplicates cause the transition to fail.

### Cross-Document Transitions (MPA)

Available in Chrome 126+. Opt in via a CSS declaration on **both** pages:

```css
@view-transition {
  navigation: auto;    /* enable for same-origin navigations */
}
```

No JavaScript required for basic cross-fades. For named groups, apply `view-transition-name` on both source and destination pages. The browser handles snapshot capture across the navigation boundary.

**Restrictions:**
- Same-origin only.
- Navigations triggered by user action (link clicks, form submissions). Not `window.location` assignments by default.
- The destination page must render within **4 seconds**, or the transition is aborted.

### Transition Lifecycle & Promises

```js
const transition = document.startViewTransition(updateDOM);

// Wait for the old snapshot to be captured
await transition.ready;
// At this point, pseudo-elements exist — you can run Web Animations API on them

// Wait for the transition animation to complete
await transition.finished;

// Skip the transition if needed (e.g., user navigated away)
transition.skipTransition();
```

### Performance Considerations

| Factor | Guideline |
|--------|-----------|
| Transition duration | Keep under **400 ms** (ideally 250–300 ms). Longer durations feel sluggish. |
| Named groups | Limit to **5–8** per transition. Each group creates additional composited layers. |
| GPU memory | Large screenshots (full-page on 4K displays) consume ~32 MB per snapshot. Two snapshots = ~64 MB. |
| `contain: paint` | Apply to transition targets to limit the capture region. |
| `will-change: view-transition-name` | Not needed — the browser handles compositing automatically. |
| Reduced motion | Respect `prefers-reduced-motion` — shorten or disable transitions. |

```css
@media (prefers-reduced-motion: reduce) {
  ::view-transition-group(*),
  ::view-transition-old(*),
  ::view-transition-new(*) {
    animation-duration: 0.01ms !important;
  }
}
```

### Checklist

- [ ] `document.startViewTransition()` wraps all DOM mutations that need animated transitions.
- [ ] Named `view-transition-name` values are unique per page — no duplicates.
- [ ] Transition duration stays under 400 ms (target 250–300 ms).
- [ ] `prefers-reduced-motion` disables or shortens all view transitions.
- [ ] MPA transitions use `@view-transition { navigation: auto; }` on both pages.
- [ ] Feature detection: `if (!document.startViewTransition) { updateDOM(); return; }`.
- [ ] Named groups limited to 5–8 to avoid GPU memory pressure.
- [ ] Fallback for unsupported browsers performs the DOM update without animation.

### Anti-Patterns

- Applying `view-transition-name` to hundreds of list items — each creates a separate composited layer, causing jank.
- Transitions longer than 500 ms that block user interaction (the page is non-interactive during the transition).
- No feature detection — calling `startViewTransition()` in Safari (unsupported as of early 2025) without a fallback crashes the update.
- Using view transitions for every minor DOM change (toggling a class, updating a counter) — reserve them for meaningful navigation-level state changes.
- Forgetting `view-transition-name` uniqueness — duplicates silently abort the transition.

> **Sources:** MDN — View Transitions API; Chrome Developers — "Smooth transitions with the View Transition API" (Jake Archibald, 2023); web.dev — "View Transitions"; W3C CSS View Transitions Module Level 1 spec; Chrome 126 release notes (cross-document transitions).

---

## BY. Popover API

### Overview

The HTML Popover API (`popover` attribute) provides a native mechanism for tooltips, menus, pickers, and non-modal dialogs — without JavaScript for show/hide logic. The browser handles light-dismiss (clicking outside), focus management, the top layer (no `z-index` wars), and accessibility semantics. Available in all major browsers since 2024 (Chrome 114+, Firefox 125+, Safari 17+).

### Basic Usage

```html
<!-- Invoker button (no JS required) -->
<button popovertarget="my-popover">Open Menu</button>

<!-- Popover element -->
<div id="my-popover" popover>
  <p>This is popover content.</p>
</div>
```

The `popover` attribute (equivalent to `popover="auto"`) gives the element:
- **Top layer rendering** — always above other content, no `z-index` needed.
- **Light dismiss** — clicking outside or pressing `Escape` closes it.
- **One-at-a-time** — opening a new `auto` popover closes any other open `auto` popover.

### Popover Types

| Type | Attribute | Light Dismiss | Stacking | Use Case |
|------|-----------|--------------|----------|----------|
| Auto | `popover` or `popover="auto"` | Yes | One-at-a-time (closes siblings) | Menus, date pickers, dropdowns |
| Manual | `popover="manual"` | No | Multiple can coexist | Toasts, persistent notifications |

### Invoker Buttons

```html
<!-- Toggle (default) -->
<button popovertarget="p1">Toggle</button>

<!-- Show only -->
<button popovertarget="p1" popovertargetaction="show">Open</button>

<!-- Hide only -->
<button popovertarget="p1" popovertargetaction="hide">Close</button>
```

No `addEventListener` needed for basic show/hide. The `popovertargetaction` attribute controls the behavior: `toggle` (default), `show`, or `hide`.

### JavaScript API

```js
const popover = document.querySelector('#my-popover');

popover.showPopover();    // Show
popover.hidePopover();    // Hide
popover.togglePopover();  // Toggle

// Events
popover.addEventListener('toggle', (e) => {
  console.log(e.newState); // 'open' or 'closed'
  console.log(e.oldState); // 'closed' or 'open'
});

// Check state
if (popover.matches(':popover-open')) {
  // currently visible
}
```

### Styling

```css
/* Default: popovers are hidden */
[popover] {
  /* browser default: display: none until opened */
  margin: auto;               /* centered in viewport by default */
  border: 1px solid #ccc;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.12);
  max-width: 320px;
}

/* Style when open */
[popover]:popover-open {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* Backdrop (top-layer backdrop) */
[popover]::backdrop {
  background: rgba(0, 0, 0, 0.15);
}
```

### Animation with @starting-style

```css
[popover] {
  opacity: 0;
  transform: translateY(-8px) scale(0.96);
  transition: opacity 200ms ease, transform 200ms ease,
              display 200ms allow-discrete;
}

[popover]:popover-open {
  opacity: 1;
  transform: translateY(0) scale(1);
}

/* Entry animation starting state */
@starting-style {
  [popover]:popover-open {
    opacity: 0;
    transform: translateY(-8px) scale(0.96);
  }
}
```

### Accessibility Built-In

The Popover API provides several accessibility features automatically:
- Focus moves into the popover on open (first focusable element, or the popover itself).
- `Escape` closes `auto` popovers.
- The invoker button gets an implicit `aria-expanded` state.
- The popover is removed from the accessibility tree when hidden.

**Manual enhancements still needed:**

| Element | Required ARIA |
|---------|---------------|
| Menu popover | `role="menu"` on popover, `role="menuitem"` on items |
| Listbox popover | `role="listbox"`, `aria-activedescendant` for keyboard navigation |
| Tooltip popover | `role="tooltip"`, `aria-describedby` on the trigger |

### Nested Popovers

Auto popovers support nesting — a popover opened from within another popover becomes its child. Closing the parent closes all descendants. The ancestry is determined by the DOM invoker chain:

```html
<button popovertarget="menu">Menu</button>
<div id="menu" popover>
  <button popovertarget="submenu">Submenu</button>
  <div id="submenu" popover>Nested content</div>
</div>
```

### Checklist

- [ ] Use `popover="auto"` for most overlays (menus, pickers) — get free light-dismiss and stacking.
- [ ] Use `popover="manual"` only for persistent UI (toasts, teaching tips) that should not auto-close.
- [ ] Connect invoker buttons via `popovertarget` — avoid manual JS for simple show/hide.
- [ ] Add appropriate ARIA roles (`menu`, `listbox`, `tooltip`) since `popover` is a behavior, not a role.
- [ ] Animate entry/exit with `@starting-style` and `transition: display allow-discrete`.
- [ ] Test keyboard: `Escape` closes, `Tab` stays trapped within popover content.
- [ ] Popover width: `max-width: 320px` for menus, `max-width: 240px` for tooltips.
- [ ] Provide a visible close mechanism for `manual` popovers (close button or timed auto-dismiss).

### Anti-Patterns

- Using `popover` for modal dialogs — use `<dialog>` with `.showModal()` instead (popovers lack inert background and focus trapping).
- Creating custom popover logic with `z-index` stacking when the native Popover API is available.
- Forgetting ARIA roles — `popover` provides the mechanics, not semantic meaning.
- Using `popover="manual"` for everything to avoid light-dismiss — defeats the purpose and creates dismiss-ability issues.
- Popover content wider than `90vw` on mobile — should stay within the viewport with at least `16px` margin.

> **Sources:** MDN — Popover API; Open UI — Popover proposal; Chrome Developers — "Introducing the Popover API" (Una Kravets, 2023); HTML spec — The `popover` attribute; Can I Use — Popover API.

---

## BZ. CSS Anchor Positioning

### Overview

CSS Anchor Positioning allows an element to position itself relative to one or more "anchor" elements anywhere in the DOM, without JavaScript. This replaces the need for Popper.js / Floating UI for tooltips, dropdown menus, combobox listboxes, and annotation pointers. Available in Chrome 125+ and Edge 125+; polyfills exist for other browsers.

### Establishing an Anchor

```css
/* The element that serves as the anchor */
.trigger {
  anchor-name: --my-anchor;
}

/* The positioned element that references the anchor */
.tooltip {
  position: fixed;              /* or absolute */
  position-anchor: --my-anchor; /* link to the anchor */

  /* Position the tooltip's top-left corner at the anchor's bottom-center */
  top: anchor(bottom);
  left: anchor(center);
  translate: -50% 8px;         /* center horizontally + 8px gap */
}
```

### The `anchor()` Function

`anchor()` takes a side keyword and returns the corresponding coordinate of the anchor element:

| Function | Returns |
|----------|---------|
| `anchor(top)` | Top edge Y coordinate |
| `anchor(bottom)` | Bottom edge Y coordinate |
| `anchor(left)` | Left edge X coordinate |
| `anchor(right)` | Right edge X coordinate |
| `anchor(center)` | Center of the anchor (horizontal or vertical depending on property) |
| `anchor(start)` / `anchor(end)` | Logical equivalents (respect writing mode) |

```css
/* Dropdown below the trigger, aligned to left edge */
.dropdown {
  position: fixed;
  position-anchor: --trigger;
  top: anchor(bottom);
  left: anchor(left);
  margin-top: 4px;
}

/* Tooltip to the right of the anchor */
.tooltip-right {
  position: fixed;
  position-anchor: --anchor;
  left: anchor(right);
  top: anchor(center);
  translate: 8px -50%;
}
```

### `anchor-size()` for Matching Dimensions

```css
.dropdown {
  /* Match the width of the trigger */
  width: anchor-size(width);

  /* Or set a minimum */
  min-width: anchor-size(width);
  max-width: 400px;
}
```

### Fallback Positioning with `@position-try`

When the preferred position would overflow the viewport, define fallback positions:

```css
.tooltip {
  position: fixed;
  position-anchor: --target;

  /* Preferred: below the anchor */
  top: anchor(bottom);
  left: anchor(center);
  translate: -50% 8px;

  /* Try these alternatives if preferred overflows */
  position-try-fallbacks: --above, --left, --right;
}

@position-try --above {
  bottom: anchor(top);
  left: anchor(center);
  translate: -50% -8px;
  top: auto;
}

@position-try --left {
  right: anchor(left);
  top: anchor(center);
  translate: -8px -50%;
  left: auto;
}

@position-try --right {
  left: anchor(right);
  top: anchor(center);
  translate: 8px -50%;
}
```

Built-in flip keywords as shorthand:

```css
.tooltip {
  position-try-fallbacks: flip-block, flip-inline, flip-block flip-inline;
}
```

- `flip-block` — flips top/bottom.
- `flip-inline` — flips left/right.

### `inset-area` Shorthand

A grid-based shorthand for common placements:

```css
.tooltip {
  position: fixed;
  position-anchor: --target;
  inset-area: bottom center;  /* below, centered */
}
/* Other values: top center, left center, right center,
   bottom left, top right, etc. */
```

### Practical Tooltip Pattern

```css
.anchor-button {
  anchor-name: --btn;
}

.tooltip {
  position: fixed;
  position-anchor: --btn;
  inset-area: top center;
  margin-bottom: 8px;
  max-width: 240px;
  padding: 8px 12px;
  border-radius: 6px;
  background: #1a1a2e;
  color: #fff;
  font-size: 13px;
  line-height: 1.4;
  position-try-fallbacks: flip-block;
  pointer-events: none;

  /* Arrow using ::after */
  &::after {
    content: '';
    position: absolute;
    top: 100%;
    left: 50%;
    translate: -50% 0;
    border: 6px solid transparent;
    border-top-color: #1a1a2e;
  }
}
```

### Progressive Enhancement

```css
/* Feature detection */
@supports (anchor-name: --a) {
  .tooltip {
    position: fixed;
    position-anchor: --trigger;
    top: anchor(bottom);
    left: anchor(center);
  }
}

/* Fallback for unsupported browsers */
@supports not (anchor-name: --a) {
  .tooltip {
    position: absolute;
    top: 100%;
    left: 50%;
    transform: translateX(-50%);
    margin-top: 8px;
  }
}
```

### Checklist

- [ ] Use `anchor-name` on the trigger and `position-anchor` on the positioned element.
- [ ] Always provide `position-try-fallbacks` (at minimum `flip-block`) to handle viewport edges.
- [ ] Maintain an `8px` gap between anchor and positioned element for readability.
- [ ] Tooltip `max-width: 240px`; dropdown `max-width: 400px`.
- [ ] Use `@supports (anchor-name: --a)` for progressive enhancement.
- [ ] Polyfill: include `@nichanank/css-anchor-positioning` polyfill (~6 KB) for Firefox/Safari.
- [ ] Each `anchor-name` must be unique on the page — duplicates cause undefined behavior.
- [ ] Test with zoom levels up to 400% — anchored elements must remain positioned correctly.

### Anti-Patterns

- Using JavaScript positioning libraries (Popper.js) when anchor positioning is sufficient and supported.
- Forgetting fallback positions — tooltip clipped by viewport edge on small screens.
- Applying `anchor-name` to elements inside `overflow: hidden` containers — the positioned element may be clipped by the ancestor's overflow.
- Not providing a CSS fallback — the positioned element renders at its static position in unsupported browsers, usually wrong.
- Using anchor positioning for layout (grid-like arrangements) — it is designed for overlay positioning, not document flow.

> **Sources:** MDN — CSS Anchor Positioning; Chrome Developers — "CSS anchor positioning" (Una Kravets, 2024); W3C CSS Anchor Positioning Module Level 1 spec; Chrome 125 release notes.

---

## CA. Speculation Rules API

### Overview

The Speculation Rules API allows developers to declaratively instruct the browser to **prefetch** or **prerender** future navigations before the user clicks. Unlike `<link rel="prefetch">`, speculation rules support document-level prerendering (loading and executing the entire page in a hidden tab), resulting in near-instant navigations. Available in Chrome 109+ (prefetch) and Chrome 121+ (document rules).

### JSON Syntax

Speculation rules are declared via a `<script type="speculationrules">` tag:

```html
<script type="speculationrules">
{
  "prefetch": [
    {
      "urls": ["/products", "/about", "/contact"]
    }
  ],
  "prerender": [
    {
      "urls": ["/dashboard"]
    }
  ]
}
</script>
```

### Document Rules (Automatic)

Instead of listing URLs manually, let the browser pick candidates from links in the page:

```html
<script type="speculationrules">
{
  "prerender": [
    {
      "where": {
        "and": [
          { "href_matches": "/*" },
          { "not": { "href_matches": "/logout" } },
          { "not": { "href_matches": "/api/*" } },
          { "not": { "selector_matches": ".no-prerender" } }
        ]
      },
      "eagerness": "moderate"
    }
  ]
}
</script>
```

### Eagerness Levels

| Level | Trigger | Use Case | Resource Impact |
|-------|---------|----------|-----------------|
| `immediate` | As soon as the rule is observed | High-confidence next page (e.g., search result #1) | High — loads immediately |
| `eager` | As soon as possible, slight delay | Likely navigations | High |
| `moderate` | On hover (desktop) or pointerdown (mobile) for **200 ms** | General links | Medium |
| `conservative` | On pointerdown / touchstart only | Low-confidence links | Low |

**Recommendation:** Use `moderate` for most links, `immediate` only for near-certain navigations (e.g., "Next" in a wizard).

### Prefetch vs Prerender

| Action | What Happens | Savings | Cost |
|--------|-------------|---------|------|
| `prefetch` | Fetches the HTML document (and optionally subresources) | Eliminates network latency (~200–800 ms) | ~50–200 KB per page |
| `prerender` | Fully loads and renders the page in a hidden tab | Near-instant navigation (0 ms perceived) | Full page cost: CPU, memory (~50–150 MB), bandwidth |

### Chrome DevTools Debugging

1. **Application panel > Speculative loads** — shows all speculation rules, their status, and which URLs are prefetched/prerendered.
2. **Network panel** — prefetched/prerendered requests show a "Speculative" badge.
3. **Performance panel** — prerendered navigations appear as separate traces.
4. **Console warnings** — Chrome logs reasons for speculation failures (e.g., cross-origin, unsupported features).

### Limits and Restrictions

| Limit | Value |
|-------|-------|
| Max concurrent prerenders (Chrome) | **2** for `moderate`/`conservative`, **10** total for `immediate`/`eager` |
| Max concurrent prefetches | **50** |
| Prerender page lifetime | **5 minutes** (evicted if unused) |
| Memory limit | Browser may evict prerenders under memory pressure |
| Cross-origin prerender | Not supported (prefetch only, with opt-in headers) |
| Pages with non-idempotent effects | Must not be prerendered (e.g., POST endpoints, analytics-heavy pages) |

### Activation and Analytics

Prerendered pages must handle activation carefully:

```js
// Defer analytics until the page is actually shown
document.addEventListener('prerenderingchange', () => {
  // Page was prerendered and is now being activated
  initializeAnalytics();
});

// Check if currently prerendering
if (document.prerendering) {
  document.addEventListener('prerenderingchange', initializeAnalytics, { once: true });
} else {
  initializeAnalytics();
}
```

### Performance Gains

| Metric | Without Speculation | With Prefetch | With Prerender |
|--------|-------------------|---------------|----------------|
| LCP | ~2,400 ms | ~1,600 ms (−33%) | ~200 ms (−92%) |
| TTFB | ~800 ms | ~100 ms (cached) | 0 ms (instant) |
| CLS | Unchanged | Unchanged | 0 (fully rendered) |

Data from Chrome team case studies on e-commerce sites.

### Checklist

- [ ] Use `moderate` eagerness for general links; `immediate` only for high-confidence targets.
- [ ] Exclude logout, API, and side-effect URLs via `"not": { "href_matches": "..." }`.
- [ ] Defer analytics initialization until `prerenderingchange` event fires.
- [ ] Monitor resource usage — prerender costs ~50–150 MB per page.
- [ ] Limit `immediate` prerender rules to 2–3 URLs maximum.
- [ ] Use prefetch (not prerender) for cross-origin links.
- [ ] Test in Chrome DevTools > Application > Speculative loads.
- [ ] Feature detection: `if (HTMLScriptElement.supports?.('speculationrules'))`.

### Anti-Patterns

- Prerendering every link on the page — wastes bandwidth and memory, may trigger server-side rate limits.
- Prerendering pages with side effects (e.g., "Mark as read", purchase confirmations).
- Firing analytics events during prerender — inflates pageview counts.
- Using `immediate` eagerness on low-confidence links — wastes resources on pages users never visit.
- No exclusion rules — accidentally prerendering logout pages or API endpoints.

> **Sources:** web.dev — "Speculation Rules API" (Barry Pollard, 2024); Chrome Developers — "Prerender pages in Chrome for instant navigations"; Chrome DevTools — Speculative loads documentation; WICG Speculation Rules spec.

---

## CB. CSS @starting-style

### Overview

`@starting-style` defines the initial style of an element when it first appears in the DOM — enabling CSS-only entry animations from `display: none`, for popovers, dialogs, and dynamically inserted elements. Before `@starting-style`, animating from `display: none` required JavaScript because the browser had no "before" state to transition from. Available in Chrome 117+, Safari 17.4+, Firefox 129+.

### Basic Entry Animation

```css
.alert {
  /* Final state (visible) */
  opacity: 1;
  transform: translateY(0);
  transition: opacity 300ms ease, transform 300ms ease;
}

/* Starting state (before the element is first rendered) */
@starting-style {
  .alert {
    opacity: 0;
    transform: translateY(-20px);
  }
}
```

When the `.alert` element is inserted into the DOM, it starts at `opacity: 0; translateY(-20px)` and transitions to its final state.

### Animating from `display: none`

The key use case: elements toggled with `display: none` / `display: block` (or popovers, dialogs):

```css
.modal {
  display: none;
  opacity: 1;
  transform: scale(1);
  transition: opacity 250ms ease, transform 250ms ease,
              display 250ms allow-discrete;
}

.modal.open {
  display: block;
}

/* Entry state */
@starting-style {
  .modal.open {
    opacity: 0;
    transform: scale(0.95);
  }
}
```

**Critical:** `transition: display 250ms allow-discrete` is required. The `allow-discrete` keyword tells the browser to keep `display: block` during the transition rather than snapping to `display: none` immediately.

### Exit Animations

`@starting-style` handles entry only. For exit animations, set the hidden state values directly:

```css
.modal {
  opacity: 1;
  transform: scale(1);
  transition: opacity 200ms ease, transform 200ms ease,
              display 200ms allow-discrete;
}

/* Exit: removing .open class transitions TO these values */
.modal:not(.open) {
  opacity: 0;
  transform: scale(0.95);
  display: none;
}

/* Entry: @starting-style defines the FROM state when .open is added */
@starting-style {
  .modal.open {
    opacity: 0;
    transform: scale(0.95);
  }
}
```

### Popover Animation

```css
[popover] {
  opacity: 0;
  transform: translateY(-8px);
  transition: opacity 200ms ease, transform 200ms ease,
              overlay 200ms allow-discrete,
              display 200ms allow-discrete;
}

[popover]:popover-open {
  opacity: 1;
  transform: translateY(0);
}

@starting-style {
  [popover]:popover-open {
    opacity: 0;
    transform: translateY(-8px);
  }
}
```

The `overlay` property transition ensures the element stays in the top layer during the exit animation.

### Dialog Animation

```css
dialog {
  opacity: 0;
  transform: translateY(16px);
  transition: opacity 300ms ease, transform 300ms ease,
              overlay 300ms allow-discrete,
              display 300ms allow-discrete;
}

dialog[open] {
  opacity: 1;
  transform: translateY(0);
}

@starting-style {
  dialog[open] {
    opacity: 1; /* Actually starts invisible, see below */
    opacity: 0;
    transform: translateY(16px);
  }
}

/* Backdrop animation */
dialog::backdrop {
  background: rgba(0, 0, 0, 0);
  transition: background 300ms ease, overlay 300ms allow-discrete;
}

dialog[open]::backdrop {
  background: rgba(0, 0, 0, 0.4);
}

@starting-style {
  dialog[open]::backdrop {
    background: rgba(0, 0, 0, 0);
  }
}
```

### Timing Guidelines

| Element Type | Entry Duration | Exit Duration | Easing |
|-------------|----------------|---------------|--------|
| Tooltip | 150 ms | 100 ms | `ease-out` |
| Popover / dropdown | 200 ms | 150 ms | `ease` |
| Modal dialog | 250–300 ms | 200 ms | `ease` |
| Toast / snackbar | 200 ms | 150 ms | `ease-out` |
| Full-page overlay | 300–400 ms | 250 ms | `ease-in-out` |

### Checklist

- [ ] Use `@starting-style` for all entry animations from `display: none` or top-layer elements.
- [ ] Include `display <duration> allow-discrete` in the transition shorthand.
- [ ] Include `overlay <duration> allow-discrete` for top-layer elements (popovers, dialogs).
- [ ] Define exit animations explicitly — `@starting-style` only handles entry.
- [ ] Keep entry animations under 300 ms, exit under 200 ms.
- [ ] Respect `prefers-reduced-motion`: `@media (prefers-reduced-motion: reduce) { * { transition-duration: 0.01ms !important; } }`
- [ ] Feature detection: `@supports (transition-behavior: allow-discrete)`.
- [ ] Test with slow motion in DevTools (Animations panel > 25% speed).

### Anti-Patterns

- Using `@keyframes` for simple entry effects that `@starting-style` + `transition` handle more simply.
- Forgetting `allow-discrete` — the display snaps immediately, making the transition invisible.
- Using `@starting-style` without providing exit animations — the element disappears abruptly.
- Overly long entry durations (>400 ms) that delay perceived interactivity.
- Not including `overlay` in the transition for top-layer elements — the element drops out of the top layer immediately on close, appearing behind other content.

> **Sources:** MDN — @starting-style; Chrome Developers — "Four new CSS features for entry and exit animations" (Una Kravets, 2023); W3C CSS Transitions Level 2 spec; Chrome 117 release notes.

---

## CC. CSS Cascade Layers (@layer)

### Overview

CSS Cascade Layers (`@layer`) give authors explicit control over the cascade order of their stylesheets, independent of specificity or source order. This solves the long-standing problem of specificity wars — especially with third-party CSS, utility frameworks, and component libraries. Instead of escalating specificity with ever-more-specific selectors or `!important`, layers establish a clear precedence hierarchy. Available in all modern browsers since March 2022 (Chrome 99+, Firefox 97+, Safari 15.4+).

### Layer Declaration and Order

```css
/* Declare layer order upfront — earliest = lowest priority */
@layer reset, base, components, utilities;

/* Later, populate each layer */
@layer reset {
  *, *::before, *::after {
    margin: 0; padding: 0; box-sizing: border-box;
  }
}

@layer base {
  body { font-family: system-ui; line-height: 1.5; color: #1a1a2e; }
  a { color: #0066cc; }
}

@layer components {
  .btn { padding: 8px 16px; border-radius: 4px; background: #0066cc; color: #fff; }
  .btn-danger { background: #dc2626; }
}

@layer utilities {
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); }
  .hidden { display: none !important; }
}
```

**Key rule:** The order in the `@layer` declaration determines priority. Later layers win over earlier layers, **regardless of specificity**. A `.btn` in `components` beats a `body > main > section > div > a.link` in `base`.

### Specificity vs Layers

| Scenario | Traditional CSS | With Layers |
|----------|----------------|-------------|
| Utility `.hidden` vs component `.modal { display: flex }` | Whoever has higher specificity or comes later wins | Utilities layer declared last → always wins |
| Third-party `.btn` vs your `.btn` | Source order / specificity battle | Your layer declared after third-party → your styles win |
| Reset vs component styles | Resets must use low specificity | Reset layer declared first → always lowest priority |

### Importing Third-Party CSS into Layers

```css
/* Isolate third-party CSS into its own layer */
@import url('bootstrap.min.css') layer(vendor);
@import url('leaflet.css') layer(vendor);

/* Your styles in a higher-priority layer */
@layer vendor, app;

@layer app {
  .btn { /* Override Bootstrap .btn without specificity hacks */ }
}
```

```html
<!-- HTML alternative using the media trick -->
<link rel="stylesheet" href="bootstrap.min.css"
      onload="this.media='all'" media="not all"
      data-layer="vendor">
```

### Nested Layers

```css
@layer components {
  @layer forms {
    .input { border: 1px solid #ccc; padding: 8px; }
  }
  @layer buttons {
    .btn { padding: 8px 16px; }
  }
}

/* Reference nested layers with dot notation */
@layer components.buttons {
  .btn-lg { padding: 12px 24px; }
}
```

### Interaction with `!important`

`!important` reverses the layer order:

| Declaration | Layer Priority |
|------------|----------------|
| Normal (no `!important`) | Last declared layer wins |
| `!important` | First declared layer wins |

This means `!important` in a reset layer beats `!important` in a utility layer — the inverse of normal order. This is intentional: it ensures resets and base defaults can set unbreakable foundations.

```css
@layer reset, components, utilities;

@layer reset {
  *, *::before, *::after {
    box-sizing: border-box !important; /* This !important beats all other layers' !important */
  }
}
```

### Unlayered Styles

Styles not assigned to any layer have the **highest** priority among normal declarations. This provides an escape hatch but should be used sparingly:

```css
@layer base, components;

@layer components { .alert { color: red; } }

/* Unlayered — highest priority */
.alert { color: blue; } /* This wins */
```

### Migration Strategy

1. **Audit existing CSS** — identify categories: resets, vendor, base, components, utilities, overrides.
2. **Declare layer order** at the top of your main stylesheet.
3. **Wrap existing files** in `@layer` blocks or use `@import ... layer()`.
4. **Remove specificity hacks** (`.parent .parent .target`, `#id` overrides, unnecessary `!important`).
5. **Test incrementally** — start with third-party isolation, then refactor internal styles.

### Checklist

- [ ] Declare all layers in a single `@layer` statement at the top of the stylesheet.
- [ ] Recommended order: `reset, vendor, base, components, utilities` (low to high priority).
- [ ] Import third-party CSS into a dedicated `vendor` layer using `@import url() layer(vendor)`.
- [ ] Avoid unlayered styles except for critical overrides — they beat all layers.
- [ ] Understand the `!important` reversal: lowest layer's `!important` wins.
- [ ] Use nested layers (`@layer components.forms`) for large component libraries.
- [ ] Remove specificity hacks (`!important`, deeply nested selectors) after migrating to layers.
- [ ] Browser support: all modern browsers since early 2022 (~96% global support).

### Anti-Patterns

- Using layers without declaring order — implicit ordering is based on first appearance, which is fragile and hard to reason about.
- Putting everything in one layer — defeats the purpose; you still have specificity battles within a single layer.
- Excessive use of unlayered styles — bypasses the layer system entirely, recreating specificity chaos.
- Not isolating third-party CSS — vendor styles compete with your own components.
- Mixing `!important` across layers without understanding the reversal — leads to confusing debugging.

> **Sources:** MDN — @layer; W3C CSS Cascading and Inheritance Level 5 spec; Miriam Suzanne — "A Complete Guide to CSS Cascade Layers" (CSS-Tricks, 2022); Bramus Van Damme — "CSS Cascade Layers" (web.dev, 2022); Can I Use — CSS Cascade Layers.

---

## CD. CSS :has() Selector

### Overview

The CSS `:has()` selector allows styling a parent element based on its descendants, or an element based on its siblings. Often called the "parent selector," it is the most powerful addition to CSS selectors in years. It eliminates entire categories of JavaScript-driven class toggling. Available in Chrome 105+, Safari 15.4+, Firefox 121+.

### Parent Selection

```css
/* Style a card differently if it contains an image */
.card:has(img) {
  grid-template-rows: 200px 1fr;
}

.card:not(:has(img)) {
  grid-template-rows: 1fr;
}

/* Form group with an invalid input gets a red border */
.form-group:has(:invalid) {
  border-left: 3px solid #dc2626;
}

/* Navigation item with an active link */
.nav-item:has(> a[aria-current="page"]) {
  background: var(--nav-active-bg, #e8f0fe);
  border-radius: 6px;
}
```

### Sibling Selection

`:has()` combined with sibling combinators lets you style elements based on what follows them:

```css
/* Style a heading if it's immediately followed by a subtitle */
h2:has(+ .subtitle) {
  margin-bottom: 4px; /* reduce gap when subtitle present */
}

/* Image followed by a caption gets rounded top corners only */
img:has(+ figcaption) {
  border-radius: 8px 8px 0 0;
}
```

### Form Validation Without JavaScript

```css
/* Change label color when its associated input is focused */
label:has(+ input:focus) {
  color: #0066cc;
  font-weight: 600;
}

/* Show helper text only when input is focused and empty */
.helper-text {
  display: none;
}
label:has(+ input:focus:placeholder-shown) ~ .helper-text {
  display: block;
}

/* Error state — label turns red when input is invalid and touched */
label:has(+ input:not(:placeholder-shown):invalid) {
  color: #dc2626;
}
```

### Responsive Components Without Media Queries

```css
/* A grid that adjusts based on content count */
.grid:has(> :nth-child(4)) {
  grid-template-columns: repeat(4, 1fr);
}

.grid:not(:has(> :nth-child(4))):has(> :nth-child(2)) {
  grid-template-columns: repeat(2, 1fr);
}

.grid:not(:has(> :nth-child(2))) {
  grid-template-columns: 1fr;
}
```

### Quantity Queries

```css
/* Style list items when there are more than 5 */
li:has(~ li:nth-of-type(5)) {
  font-size: 14px; /* smaller text for long lists */
}

/* Show "View all" link only when list has many items */
.list-container:has(> ul > li:nth-child(6)) .view-all {
  display: inline-flex;
}
```

### Dark Mode and Theme-Based Styling

```css
/* Apply dark mode based on a toggle within the page */
html:has(#dark-mode-toggle:checked) {
  --bg: #1a1a2e;
  --text: #e8e8e8;
  --surface: #2a2a3e;
  color-scheme: dark;
}
```

### Empty State Detection

```css
/* Show empty state message when container has no visible children */
.results:not(:has(> .result-item)) .empty-state {
  display: flex;
}

.results:has(> .result-item) .empty-state {
  display: none;
}
```

### Performance Considerations

`:has()` is computationally more expensive than standard selectors because it requires the browser to look "upward" and "forward" in the DOM:

| Pattern | Performance | Notes |
|---------|-------------|-------|
| `.parent:has(> .child)` | Good | Direct child — limited scope |
| `.parent:has(.descendant)` | Moderate | Must scan subtree |
| `:has(.foo) .bar` | Expensive | Potentially matches many elements |
| `*:has(.x)` | Very expensive | Checks every element on the page |

**Rule:** Scope `:has()` selectors as tightly as possible. Prefer `.specific-class:has(> .direct-child)` over broad matches.

### Progressive Enhancement

```css
/* Fallback for browsers without :has() — JavaScript adds a class */
.form-group.has-error { border-left: 3px solid #dc2626; }

/* Enhancement for browsers with :has() */
@supports selector(:has(*)) {
  .form-group:has(:invalid) { border-left: 3px solid #dc2626; }
  .form-group.has-error { border-left: none; } /* JS class no longer needed */
}
```

### Checklist

- [ ] Use `:has()` to eliminate JavaScript class-toggling for parent/sibling state styling.
- [ ] Prefer direct-child combinators (`:has(> .child)`) for performance.
- [ ] Avoid universal selectors with `:has()` — never write `*:has(...)`.
- [ ] Use `@supports selector(:has(*))` for progressive enhancement.
- [ ] Combine with `:not()` for inverse states: `.card:not(:has(img))`.
- [ ] Test performance in DevTools > Performance panel — watch for "Recalculate Style" spikes.
- [ ] Browser support: ~93% global (all modern browsers since late 2023).

### Anti-Patterns

- Using `:has()` where a simpler selector works — `:has()` for `.parent .child` styling is overkill if you can style `.child` directly.
- Deeply nested `:has()` selectors (`:has(:has(:has(...)))`) — extremely expensive and hard to debug.
- Relying on `:has()` for critical functionality without a JavaScript fallback for older browsers.
- Using `:has()` to replicate media queries — use `@container` queries for component-level responsive design instead.

> **Sources:** MDN — :has(); Jen Simmons (Apple) — ":has() is more than a parent selector" (WWDC, 2023); Ahmad Shadeed — "CSS :has() Interactive Guide" (ishadeed.com, 2023); Can I Use — :has() selector; W3C Selectors Level 4 spec.

---

## CE. CSS Nesting

### Overview

Native CSS nesting allows writing descendant, child, and pseudo-class selectors inside a parent rule block — the same pattern that made Sass/Less popular, now built into CSS. This reduces repetition, improves readability, and can simplify stylesheet organization. Available in Chrome 112+, Safari 17.2+, Firefox 117+.

### Basic Syntax

```css
/* Traditional CSS */
.card { padding: 16px; }
.card .title { font-size: 18px; font-weight: 600; }
.card .title:hover { color: #0066cc; }
.card .body { font-size: 14px; line-height: 1.5; }

/* Native CSS nesting */
.card {
  padding: 16px;

  .title {
    font-size: 18px;
    font-weight: 600;

    &:hover {
      color: #0066cc;
    }
  }

  .body {
    font-size: 14px;
    line-height: 1.5;
  }
}
```

### The `&` Selector

`&` represents the parent selector. It is **optional** for descendant selectors (`.parent { .child {} }`) but **required** for pseudo-classes, pseudo-elements, and compound selectors:

```css
.btn {
  background: #0066cc;
  color: #fff;

  /* & is optional here (descendant) */
  .icon { margin-right: 8px; }

  /* & required for pseudo-classes */
  &:hover { background: #0052a3; }
  &:focus-visible { outline: 2px solid #0066cc; outline-offset: 2px; }
  &:disabled { opacity: 0.4; cursor: not-allowed; }

  /* & required for pseudo-elements */
  &::after { content: ''; display: block; }

  /* & required for compound selectors */
  &.primary { background: #0066cc; }
  &.danger { background: #dc2626; }
}
```

### Nesting with Combinators

```css
.list {
  display: flex;
  flex-direction: column;

  /* Child combinator */
  > li {
    padding: 8px 12px;
    border-bottom: 1px solid #e5e5e5;
  }

  /* Adjacent sibling */
  > li + li {
    margin-top: 0; /* border-bottom handles separation */
  }

  /* General sibling */
  > li ~ li:last-child {
    border-bottom: none;
  }
}
```

### Nesting Media / Container Queries

```css
.sidebar {
  width: 280px;
  display: flex;

  @media (max-width: 768px) {
    width: 100%;
    position: fixed;
    inset: 0;
    transform: translateX(-100%);

    &.open {
      transform: translateX(0);
    }
  }
}
```

Media queries nested inside a rule are scoped to that rule's selector — the browser expands them as if the selector were inside the `@media` block.

### Specificity Behavior

Nested selectors have the same specificity as their expanded equivalent:

```css
/* This nested rule... */
.card {
  .title { color: blue; }
}

/* ...has the same specificity as: */
.card .title { color: blue; }
/* Specificity: (0, 2, 0) */
```

**Exception:** Using `&` in ways that create `:is()` wrappers:

```css
.card, .panel {
  .title { color: blue; }
}
/* Expands to: :is(.card, .panel) .title { color: blue; } */
/* Specificity: (0, 2, 0) — :is() takes the highest specificity of its arguments */
```

### Nesting Depth Guidelines

| Depth | Example | Recommendation |
|-------|---------|----------------|
| 1 level | `.card { .title {} }` | Ideal |
| 2 levels | `.card { .header { .title {} } }` | Acceptable |
| 3 levels | `.card { .header { .title { &:hover {} } } }` | Maximum recommended |
| 4+ levels | Deep nesting | Refactor — extract components |

The same **3-level max** rule from Sass applies to native nesting. Deep nesting generates high-specificity selectors and makes styles hard to override.

### Comparison with Sass

| Feature | Sass | Native CSS Nesting |
|---------|------|--------------------|
| Syntax | `{ }` nesting with `&` | Same (minor differences) |
| `&` in selectors | `&-suffix` creates `.parent-suffix` | Not supported — `&` is the full selector, not a string |
| Variables | `$var` | `var(--prop)` |
| Mixins | `@mixin` / `@include` | Not available (use custom properties + cascade layers) |
| Loops/conditionals | `@for`, `@if` | Not available |
| Output | Compiled to flat CSS | Native — no build step |

**Migration note:** Sass's `&-suffix` pattern (`&__element`, `&--modifier` in BEM) does not work in native nesting. You must write the full selector:

```css
/* Sass (works) */
.block { &__element { } &--modifier { } }

/* Native CSS (required alternative) */
.block {
  /* Cannot do &__element */
}
.block__element { /* Must be a separate rule */ }
.block--modifier { /* Must be a separate rule */ }
```

### Checklist

- [ ] Use nesting for related selectors (pseudo-classes, states, children of a component).
- [ ] Limit nesting depth to 3 levels maximum.
- [ ] Use `&` explicitly for pseudo-classes (`:hover`, `:focus`), pseudo-elements (`::before`), and compound selectors (`.class`).
- [ ] Nest `@media` queries inside component rules for colocation.
- [ ] Do not use `&`-suffix concatenation (not supported — break BEM patterns into separate rules).
- [ ] Browser support: ~92% global (2024). Use PostCSS nesting plugin for older browser support.
- [ ] Maintain the same specificity awareness as un-nested CSS — nesting does not change specificity.

### Anti-Patterns

- Nesting beyond 3 levels — creates overly specific selectors and hard-to-maintain stylesheets.
- Attempting `&__element` BEM patterns — fails silently or produces broken selectors in native CSS.
- Nesting everything — not every selector needs nesting. Unrelated styles in the same block reduce readability.
- Assuming nesting reduces specificity — it does not; `.a { .b {} }` is `(0,2,0)`, same as `.a .b`.
- Duplicating media queries inside every component instead of using a design token system for breakpoints.

> **Sources:** MDN — CSS Nesting; W3C CSS Nesting Module spec; Chrome Developers — "CSS Nesting" (Adam Argyle, 2023); Chrome 112 release notes; Can I Use — CSS Nesting.

---

## CF. List Virtualization & Windowing

### Overview

List virtualization (also called "windowing") renders only the visible portion of a large list or table, keeping DOM node count low. Without virtualization, a list of 10,000 items creates 10,000+ DOM nodes, causing slow initial render (>1 s), high memory usage (200+ MB), and janky scrolling. Virtualization typically reduces the DOM to 20–50 visible nodes plus a small overscan buffer. This is critical for data tables, infinite feeds, chat logs, and any list exceeding ~200 items.

### When to Virtualize

| List Size | Recommendation |
|-----------|---------------|
| < 100 items | No virtualization needed |
| 100–500 items | Consider virtualization if items are complex (images, interactive elements) |
| 500–5,000 items | Virtualize |
| 5,000+ items | Virtualize + pagination or infinite scroll |

### CSS `content-visibility` (Browser-Native)

Before reaching for a library, consider the CSS `content-visibility` property — a browser-native optimization:

```css
.list-item {
  content-visibility: auto;
  contain-intrinsic-size: auto 80px; /* estimated height */
}
```

| Property | Effect |
|----------|--------|
| `content-visibility: auto` | Browser skips rendering of off-screen items (layout, paint, style) |
| `contain-intrinsic-size: auto 80px` | Provides a placeholder height so scrollbar sizing is correct |

**Performance gains:** Up to **7x faster initial render** on long pages (Chrome team measurements on travel sites with 300+ sections). The `auto` keyword in `contain-intrinsic-size` remembers the real size once rendered, preventing layout shifts on re-scroll.

**Limitations:** No control over data fetching — all items must be in the DOM. For true virtualization (items not in DOM until scrolled into view), use a library.

### react-window (Lightweight)

```jsx
import { FixedSizeList } from 'react-window';

function VirtualList({ items }) {
  return (
    <FixedSizeList
      height={600}          // container height
      width="100%"
      itemCount={items.length}
      itemSize={48}         // row height in px
      overscanCount={5}     // render 5 extra items above/below viewport
    >
      {({ index, style }) => (
        <div style={style} className="list-item">
          {items[index].name}
        </div>
      )}
    </FixedSizeList>
  );
}
```

- **Bundle size:** ~6 KB gzipped (vs ~33 KB for react-virtualized).
- **Fixed vs Variable:** Use `FixedSizeList` for uniform heights, `VariableSizeList` for dynamic heights.

### @tanstack/react-virtual (Framework-Agnostic)

```jsx
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }) {
  const parentRef = useRef(null);

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 48,    // estimated row height
    overscan: 5,
  });

  return (
    <div ref={parentRef} style={{ height: 600, overflow: 'auto' }}>
      <div style={{ height: virtualizer.getTotalSize(), position: 'relative' }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.key}
            style={{
              position: 'absolute',
              top: 0,
              transform: `translateY(${virtualRow.start}px)`,
              height: virtualRow.size,
              width: '100%',
            }}
          >
            {items[virtualRow.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

- **Bundle size:** ~3 KB gzipped.
- **Framework support:** React, Vue, Svelte, Solid, vanilla JS.
- Supports horizontal and grid virtualization.

### Variable-Height Items

Variable heights require measuring each item after render:

```jsx
const virtualizer = useVirtualizer({
  count: items.length,
  getScrollElement: () => parentRef.current,
  estimateSize: () => 80,  // estimate — will be corrected after measurement
  measureElement: (el) => el.getBoundingClientRect().height,
});
```

**Key considerations:**
- Provide a reasonable `estimateSize` to avoid scrollbar jumping.
- Use `ResizeObserver` (built into TanStack Virtual) to handle dynamic content changes.
- **Scrollbar stability:** Bad estimates cause the scrollbar thumb to jump as items are measured. Target estimates within **20%** of actual size.

### Overscan Configuration

| Use Case | Overscan Count | Rationale |
|----------|---------------|-----------|
| Fast scrolling (feed) | 3–5 items | Minimal whitespace flicker |
| Slow scrolling (data table) | 5–10 items | Smooth keyboard navigation |
| Keyboard navigation heavy | 10+ items | Ensures focus targets are in DOM |

### Scroll Restoration

When navigating away and returning, the scroll position must be restored:

```js
// Save position before navigation
const savedPosition = scrollElement.scrollTop;

// Restore after re-mount
useEffect(() => {
  if (savedPosition) {
    scrollElement.scrollTop = savedPosition;
    // For virtualized lists, also restore the virtual offset
    virtualizer.scrollToOffset(savedPosition);
  }
}, []);
```

### Accessibility Considerations

Virtualization removes items from the DOM, which breaks screen reader expectations:

| Concern | Solution |
|---------|----------|
| Total count unknown | `aria-setsize` on each visible item, `aria-posinset` for position |
| Focus lost on scroll | Return focus to the container or the nearest visible item |
| `Ctrl+F` browser search | Does not find off-screen items — provide an in-app search |
| `role="feed"` | Use for infinite-scroll feeds — announces loading of new items |

```html
<div role="feed" aria-busy="false" aria-label="Search results">
  <article role="article" aria-setsize="1000" aria-posinset="1">...</article>
  <article role="article" aria-setsize="1000" aria-posinset="2">...</article>
  <!-- only visible items rendered -->
</div>
```

### Checklist

- [ ] Virtualize lists with 200+ items (or 100+ complex items).
- [ ] Try `content-visibility: auto` first — no library needed, ~7x faster render.
- [ ] Set `contain-intrinsic-size` with the `auto` keyword for accurate scroll sizing.
- [ ] Choose `estimateSize` within 20% of actual item height to prevent scrollbar jumping.
- [ ] Set `overscan` to 5 for general use; increase for keyboard-heavy UIs.
- [ ] Add `aria-setsize` and `aria-posinset` to virtualized items.
- [ ] Implement scroll restoration for back-navigation scenarios.
- [ ] Provide in-app search — browser `Ctrl+F` cannot find off-screen items.
- [ ] Test with screen readers — ensure focus management when items enter/leave the DOM.

### Anti-Patterns

- Virtualizing short lists (< 100 items) — adds complexity with negligible benefit.
- Not setting `contain-intrinsic-size` with `content-visibility: auto` — causes a 0-height collapsed layout and a tiny scrollbar.
- Overscan of 0 — visible white flashes during fast scrolling.
- Forgetting `aria-setsize` / `aria-posinset` — screen readers cannot convey list context.
- Using `position: absolute` without `will-change: transform` on rapidly scrolling containers — causes repaint storms.
- Mixing virtualization with CSS transitions on list items — transitions fire on every mount/unmount during scroll.

> **Sources:** web.dev — "content-visibility: the new CSS property that boosts rendering performance" (Una Kravets & Vladimir Levin, 2020); Addy Osmani — "Rendering large lists with react-window" (web.dev); TanStack Virtual documentation; MDN — content-visibility; WCAG 4.1.2 — Name, Role, Value.

---

## CG. Framework Rendering Patterns (SSR/SSG/ISR)

### Overview

Modern web frameworks offer multiple rendering strategies, each with different tradeoffs for performance (TTFB, FCP, TTI, LCP), SEO, infrastructure cost, and developer experience. Choosing the right pattern per page — not per application — is key to optimal web performance.

### Rendering Pattern Comparison

| Pattern | Render Time | HTML Delivery | JS Needed | Best For |
|---------|-------------|--------------|-----------|----------|
| **CSR** (Client-Side Rendering) | In browser | Empty shell | Yes, full bundle | Authenticated dashboards, SPAs |
| **SSR** (Server-Side Rendering) | Per request on server | Full HTML | Yes, hydration | Dynamic, personalized pages |
| **SSG** (Static Site Generation) | At build time | Full HTML from CDN | Optional | Blog posts, docs, marketing pages |
| **ISR** (Incremental Static Regeneration) | At build + revalidation | Full HTML from CDN, updated in background | Optional | Product pages, listings with periodic updates |
| **Streaming SSR** | Per request, progressive | Chunked HTML | Yes, selective hydration | Complex pages with mixed fast/slow data |
| **RSC** (React Server Components) | On server, component-level | Serialized component tree | Only for client components | Data-heavy pages with interactive islands |
| **Islands** | Static shell + isolated dynamic regions | Full HTML | Only for interactive islands | Content-heavy sites with few interactive areas |

### Performance Metrics by Pattern

| Pattern | TTFB | FCP | LCP | TTI | SEO |
|---------|------|-----|-----|-----|-----|
| CSR | Fast (~50 ms) | Slow (~1.5–3 s) | Slow (~2–4 s) | Slow (~3–5 s) | Poor (empty HTML) |
| SSR | Moderate (~200–800 ms) | Fast (~400–800 ms) | Fast (~800–1,500 ms) | Moderate (~1–2 s hydration) | Excellent |
| SSG | Very fast (~50 ms CDN) | Very fast (~100–300 ms) | Very fast (~300–600 ms) | Fast (~500 ms) | Excellent |
| ISR | Very fast (~50 ms CDN) | Very fast (~100–300 ms) | Very fast (~300–600 ms) | Fast (~500 ms) | Excellent |
| Streaming SSR | Fast (~100 ms first chunk) | Fast (~200–500 ms) | Moderate (depends on stream) | Progressive | Excellent |
| RSC | Fast (~100 ms) | Fast (~300–600 ms) | Fast (~500–1,000 ms) | Fast (less client JS) | Excellent |
| Islands | Very fast (~50 ms CDN) | Very fast (~100–300 ms) | Very fast (~300–600 ms) | Very fast (~200–500 ms) | Excellent |

### Server-Side Rendering (SSR)

```jsx
// Next.js App Router — SSR by default for server components
// app/products/[id]/page.tsx
export default async function ProductPage({ params }) {
  const product = await db.products.findUnique({ where: { id: params.id } });
  return (
    <main>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
      <AddToCartButton id={product.id} /> {/* Client component */}
    </main>
  );
}
```

**When to use:** Pages that need fresh data on every request (user-specific content, real-time inventory, search results with filters).

**Key tradeoff:** TTFB is slower than static (server must render), but content is always fresh.

### Static Site Generation (SSG)

```jsx
// Next.js — generateStaticParams for SSG
export async function generateStaticParams() {
  const posts = await getAllPosts();
  return posts.map((post) => ({ slug: post.slug }));
}

export default async function BlogPost({ params }) {
  const post = await getPost(params.slug);
  return <article dangerouslySetInnerHTML={{ __html: post.html }} />;
}
```

**When to use:** Content that changes infrequently (blog posts, documentation, marketing pages, legal pages).

**Build time concern:** 10,000 pages at 200 ms/page = 33 minutes build time. Use ISR for large catalogs.

### Incremental Static Regeneration (ISR)

```jsx
// Next.js App Router — revalidate every 60 seconds
export const revalidate = 60;

export default async function ProductPage({ params }) {
  const product = await getProduct(params.id);
  return <ProductDetail product={product} />;
}
```

Or on-demand revalidation:

```js
// app/api/revalidate/route.ts
import { revalidatePath } from 'next/cache';

export async function POST(request) {
  const { path } = await request.json();
  revalidatePath(path);
  return Response.json({ revalidated: true });
}
```

**When to use:** Product pages, user profiles, listings — content that is semi-static but needs periodic updates without full rebuilds.

### Streaming SSR

```jsx
// React 18 + Next.js — Suspense for streaming
import { Suspense } from 'react';

export default function DashboardPage() {
  return (
    <main>
      <h1>Dashboard</h1>
      {/* Header renders immediately */}
      <Suspense fallback={<SkeletonChart />}>
        <SlowAnalyticsChart /> {/* Streams in when data is ready */}
      </Suspense>
      <Suspense fallback={<SkeletonTable />}>
        <RecentOrdersTable /> {/* Streams independently */}
      </Suspense>
    </main>
  );
}
```

The server sends the HTML shell immediately (fast TTFB), then streams additional chunks as async data resolves. Each `<Suspense>` boundary can hydrate independently (selective hydration).

### Islands Architecture

```html
<!-- Astro example — static HTML with interactive islands -->
---
import Header from '../components/Header.astro';    // Static (no JS)
import ProductCarousel from '../components/ProductCarousel.tsx'; // Interactive
---
<html>
<body>
  <Header />                                          <!-- 0 KB JS -->
  <main>
    <article set:html={post.html} />                  <!-- 0 KB JS -->
    <ProductCarousel client:visible products={products} />  <!-- JS loaded on visibility -->
  </main>
</body>
</html>
```

**Hydration directives (Astro):**
- `client:load` — Hydrate immediately on page load.
- `client:idle` — Hydrate when browser is idle (`requestIdleCallback`).
- `client:visible` — Hydrate when element enters viewport (IntersectionObserver).
- `client:media="(max-width: 768px)"` — Hydrate only on matching media query.

### Decision Matrix

```
Is the page content personalized or user-specific?
├── Yes → Is real-time freshness critical?
│   ├── Yes → SSR (or Streaming SSR for complex pages)
│   └── No → SSR with short cache (Cache-Control: s-maxage=60)
└── No → Does the content change frequently?
    ├── Rarely (< 1x/week) → SSG
    ├── Sometimes (hourly/daily) → ISR
    └── Has interactive sections? → Islands Architecture
```

### Hydration Cost

Full-page hydration is the hidden cost of SSR:

| Bundle Size | Hydration Time (3G mobile) | Hydration Time (4G) |
|-------------|--------------------------|---------------------|
| 100 KB JS | ~800 ms | ~200 ms |
| 300 KB JS | ~2,400 ms | ~600 ms |
| 500 KB JS | ~4,000 ms | ~1,000 ms |

**Mitigation strategies:**
- Selective hydration (React 18 + Suspense).
- Islands architecture — only hydrate interactive components.
- React Server Components — zero client JS for data-fetching components.
- Progressive hydration — hydrate above-the-fold first, defer below-the-fold.

### Checklist

- [ ] Choose rendering pattern per page/route, not per application.
- [ ] SSG for content that changes < 1x/week; ISR for hourly/daily changes.
- [ ] SSR only when content is personalized or requires per-request freshness.
- [ ] Use Streaming SSR (Suspense boundaries) for pages with mixed fast/slow data.
- [ ] Measure hydration cost: keep client JS under 200 KB for sub-1s TTI on mobile.
- [ ] Islands architecture for content-heavy sites with few interactive areas.
- [ ] Set `Cache-Control: s-maxage` headers on SSR pages for CDN edge caching.
- [ ] Monitor TTFB, LCP, and TTI in RUM (see section CL) to validate pattern choices.

### Anti-Patterns

- CSR for public, SEO-critical pages — search engines see an empty shell.
- SSR everything when most pages are static — wastes server compute and increases TTFB.
- SSG for thousands of frequently changing pages — builds take 30+ minutes.
- Full-page hydration with 500 KB+ JS bundles — TTI exceeds 4 seconds on mobile.
- No `Cache-Control` headers on SSR pages — every request hits the origin server.
- Choosing a rendering pattern based on framework defaults rather than per-page requirements.

> **Sources:** web.dev — "Rendering on the Web" (Jason Miller & Addy Osmani); Patterns.dev — "Rendering Patterns" (Addy Osmani & Lydia Hallie); Vercel — Next.js App Router documentation; Astro documentation — Islands Architecture; React docs — Server Components.

---

## CH. Conflict Resolution & CRDT UX

### Overview

Collaborative and offline-first applications must handle concurrent edits by multiple users — or by the same user across devices. The UX challenge is not just the merge algorithm (OT vs CRDT) but how to communicate conflicts, presence, and sync state to users. Poor conflict UX leads to data loss, confusion, and distrust.

### Operational Transform vs CRDT

| Aspect | Operational Transform (OT) | CRDT (Conflict-free Replicated Data Type) |
|--------|---------------------------|------------------------------------------|
| Architecture | Requires central server to sequence operations | Peer-to-peer or server-relayed; no central ordering needed |
| Conflict resolution | Server resolves conflicts by transforming operations | Mathematically guaranteed convergence — no conflicts by design |
| Offline support | Limited — operations queue but require server to resolve | Full offline support — merge on reconnect |
| Complexity | Transform functions are hard to implement correctly | Data structure design is complex; merge is automatic |
| Examples | Google Docs (original), ShareDB | Automerge, Yjs, Figma, Linear |
| Latency sensitivity | High — depends on server round-trip | Low — local-first, sync eventually |

### Presence Awareness

Show who is viewing or editing the same document:

```
┌─────────────────────────────────────────┐
│ Document Title           👤 Alice (you) │
│                          👤 Bob         │
│                          👤 Carol       │
└─────────────────────────────────────────┘
```

**Implementation guidelines:**

| Element | Specification |
|---------|---------------|
| Avatar size | `28–32px` circle with 2px colored border |
| Color assignment | Assign each user a consistent color from a palette of 8–12 distinguishable hues |
| Max visible avatars | Show 3–4, then "+N" overflow badge |
| Idle timeout | Gray out avatar after **5 minutes** of inactivity; remove after **30 minutes** |
| Tooltip | Show user name + "Editing" / "Viewing" / "Idle" on hover |

### Cursor & Selection Sharing

For text editors and design tools:

```css
/* Remote user cursor */
.remote-cursor {
  position: absolute;
  width: 2px;
  height: 1.2em;
  animation: blink 1s step-end infinite;
}

/* Remote user selection */
.remote-selection {
  background: var(--user-color);
  opacity: 0.25;
  border-radius: 2px;
}

/* Cursor label */
.remote-cursor-label {
  position: absolute;
  top: -20px;
  left: 0;
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 4px;
  background: var(--user-color);
  color: #fff;
  white-space: nowrap;
  pointer-events: none;
}
```

**Guidelines:**
- Show cursor label for **3 seconds** after cursor moves, then fade to just the cursor line.
- Use the same color for cursor, selection highlight, and presence avatar.
- Debounce cursor position broadcasts to **50 ms** intervals to avoid network flooding.
- Hide own cursor label — only show remote users' labels.

### Conflict Indicators

When automatic merge is not possible (e.g., two users edit the same cell in a spreadsheet):

```
┌─────────────────────────────────┐
│ Cell B4: Revenue               │
│                                 │
│ ⚠ Conflict detected            │
│                                 │
│ ┌─ Your version ─────────────┐ │
│ │ $142,500                    │ │
│ └─────────────────────────────┘ │
│ ┌─ Bob's version (2 min ago) ┐ │
│ │ $145,000                    │ │
│ └─────────────────────────────┘ │
│                                 │
│ [Keep Yours] [Accept Bob's]     │
│ [View Diff]                     │
└─────────────────────────────────┘
```

**Rules:**
- Highlight conflicted fields with amber border (`#f59e0b`) and a warning icon.
- Show both versions with clear attribution (who, when).
- Default to "last write wins" only if the user has not made a choice within **30 seconds** (auto-resolve with undo option).
- Log all auto-resolved conflicts in a "Sync History" accessible from settings.

### Sync State Communication

Users must always know the sync status of their data:

| State | Visual Indicator | Copy |
|-------|-----------------|------|
| Synced | Green check (subtle, in status bar) | "All changes saved" |
| Syncing | Animated sync icon (spinning) | "Saving..." |
| Pending (offline) | Gray cloud with arrow | "Changes saved locally — will sync when online" |
| Conflict | Amber warning badge | "1 conflict needs your attention" |
| Error | Red exclamation | "Unable to save — Retry" |

Position the sync indicator in a **persistent, non-intrusive location** — typically the header bar or bottom status bar. Never use a modal for routine sync status.

### Offline-First Sync Pattern

```
Online: User edits → Local CRDT state → Broadcast to peers → UI reflects merged state
                                       → Persist to server

Offline: User edits → Local CRDT state → Persist to IndexedDB
                                        → Queue changes

Reconnect: Send queued CRDT operations → Server merges → Broadcast to peers
           ← Receive missed operations → Merge locally → UI updates
```

**UX requirements during offline:**
- All features should remain functional (read + write).
- Show offline indicator: banner at top or icon in header.
- On reconnect, show "Syncing X changes..." with progress.
- If conflicts arise during merge, show conflict resolution UI (see above).

### Merge Strategies for Different Data Types

| Data Type | Strategy | User Expectation |
|-----------|----------|-----------------|
| Rich text | Character-level CRDT (Yjs, Automerge) | Both users' edits appear — no lost characters |
| Spreadsheet cells | Last-write-wins per cell, with conflict UI for simultaneous edits | Clear winner, option to review |
| JSON/structured data | Field-level merge (merge non-conflicting field changes) | Only truly conflicting fields need resolution |
| Files / binary | Version history — cannot merge | "Bob uploaded a new version. Keep yours or use theirs?" |
| Drawing canvas | Operation-level CRDT (stroke/shape operations) | Both users' strokes appear |

### Yjs Integration Example

```js
import * as Y from 'yjs';
import { WebsocketProvider } from 'y-websocket';

const doc = new Y.Doc();
const provider = new WebsocketProvider('wss://sync.example.com', 'document-id', doc);
const yText = doc.getText('content');

// Awareness (presence)
const awareness = provider.awareness;
awareness.setLocalStateField('user', { name: 'Alice', color: '#e91e63' });

// Listen for remote presence
awareness.on('change', () => {
  const states = Array.from(awareness.getStates().values());
  updatePresenceUI(states);
});

// Sync status
provider.on('status', ({ status }) => {
  // status: 'connecting' | 'connected' | 'disconnected'
  updateSyncIndicator(status);
});
```

### Checklist

- [ ] Show presence indicators (avatars + colors) for all active users.
- [ ] Display sync state persistently: synced / syncing / offline / conflict / error.
- [ ] Implement cursor and selection sharing for real-time text editing.
- [ ] Auto-resolve simple conflicts (non-overlapping edits) silently; show UI for true conflicts.
- [ ] Provide version history / undo for auto-resolved conflicts.
- [ ] Debounce cursor broadcasts to 50 ms minimum interval.
- [ ] Support full offline editing with local persistence (IndexedDB).
- [ ] On reconnect, show merge progress and surface any conflicts.
- [ ] Log all conflict resolutions in a viewable "Sync History."
- [ ] Assign consistent, distinguishable colors to each user (8–12 hue palette).

### Anti-Patterns

- Silent data loss — one user's changes overwritten without notification.
- Blocking UI during sync — showing a loading overlay while merging changes.
- No offline capability in a collaborative app — users lose work when connectivity drops.
- Conflict resolution via modal interruptions — disrupts flow; use inline indicators instead.
- Showing technical CRDT/merge details to users ("Vector clock mismatch") — use human-readable language.
- No presence awareness — users unknowingly edit the same section simultaneously.

> **Sources:** Martin Kleppmann — "Automerge: A JSON-like data structure for building collaborative applications" (automerge.org); Yjs documentation (yjs.dev); Figma Engineering — "How Figma's multiplayer technology works" (Evan Wallace, 2019); Ink & Switch — "Local-first software" (2019); Kevin Jahns — "Are CRDTs suitable for shared editing?" (2020).

---

## CI. Navigation API

### Overview

The Navigation API is a modern replacement for the History API (`history.pushState`, `popstate` events) designed specifically for single-page application (SPA) navigation. It provides a single event (`navigate`) for all navigation types, built-in scroll restoration, transition tracking, and the ability to intercept and transform navigations declaratively. Available in Chrome 102+, Edge 102+. Polyfills exist for other browsers.

### Problems with the History API

| Issue | History API | Navigation API |
|-------|-------------|---------------|
| Event model | `popstate` fires only for back/forward, not `pushState` | `navigate` fires for all navigations |
| Current URL | Must manually track with `location.href` | `navigation.currentEntry.url` |
| Scroll restoration | `history.scrollRestoration` is all-or-nothing | Per-entry scroll restoration via `intercept({ scroll: 'after-transition' })` |
| Transition state | No built-in concept of "navigation in progress" | `navigation.transition` tracks pending navigations |
| Entries list | `history.length` only — no access to actual entries | `navigation.entries()` returns all entries with state |

### Basic Navigation Interception

```js
navigation.addEventListener('navigate', (event) => {
  // Only handle same-origin, non-anchor navigations
  if (!event.canIntercept || event.hashChange) return;

  const url = new URL(event.destination.url);

  // Route matching
  if (url.pathname.startsWith('/products/')) {
    event.intercept({
      async handler() {
        const productId = url.pathname.split('/')[2];
        const product = await fetchProduct(productId);
        renderProductPage(product);
      },
      focusReset: 'after-transition',  // reset focus after render
      scroll: 'after-transition',       // restore scroll after render
    });
  }
});
```

### NavigateEvent Properties

| Property | Type | Description |
|----------|------|-------------|
| `event.navigationType` | `'push'` / `'replace'` / `'reload'` / `'traverse'` | What kind of navigation |
| `event.destination.url` | `string` | Target URL |
| `event.destination.getState()` | `any` | State associated with the destination entry |
| `event.canIntercept` | `boolean` | `true` if the navigation can be intercepted (same-origin, not cross-document) |
| `event.hashChange` | `boolean` | `true` if only the hash changed |
| `event.formData` | `FormData` or `null` | Non-null for form submissions |
| `event.downloadRequest` | `string` or `null` | Non-null for download links |
| `event.signal` | `AbortSignal` | Aborted if navigation is cancelled (e.g., user clicks another link) |

### Programmatic Navigation

```js
// Navigate (push)
navigation.navigate('/products/42');

// Navigate with state
navigation.navigate('/products/42', {
  state: { fromSearch: true, query: 'blue widget' },
});

// Replace current entry
navigation.navigate('/products/42', { history: 'replace' });

// Back / Forward
navigation.back();
navigation.forward();

// Traverse to a specific entry
const entries = navigation.entries();
navigation.traverseTo(entries[2].key);
```

### Transition Tracking

```js
navigation.addEventListener('navigate', (event) => {
  event.intercept({
    async handler() {
      showLoadingIndicator();
      try {
        const data = await fetchData(event.destination.url);
        renderPage(data);
      } finally {
        hideLoadingIndicator();
      }
    }
  });
});

// Global transition tracking
navigation.addEventListener('navigatesuccess', () => {
  console.log('Navigation complete');
});

navigation.addEventListener('navigateerror', (event) => {
  console.error('Navigation failed:', event.error);
  showErrorPage(event.error);
});
```

### Abort Signal for Cancelled Navigations

```js
navigation.addEventListener('navigate', (event) => {
  event.intercept({
    async handler() {
      // Pass the signal to fetch — automatically cancelled if user navigates away
      const response = await fetch(`/api${event.destination.url}`, {
        signal: event.signal,
      });
      const data = await response.json();
      renderPage(data);
    }
  });
});
```

This eliminates the common SPA bug of rendering stale data when a user clicks multiple links quickly — only the latest navigation's fetch completes.

### Navigation Entries

```js
const entries = navigation.entries();
// Returns: NavigationHistoryEntry[]
// Each entry has: .url, .key, .id, .index, .getState(), .sameDocument

// Current entry
const current = navigation.currentEntry;
console.log(current.url, current.getState());

// Update current entry's state without navigation
navigation.updateCurrentEntry({ state: { scrollY: window.scrollY } });
```

### Progressive Enhancement

```js
if ('navigation' in window) {
  // Use Navigation API
  navigation.addEventListener('navigate', handleNavigate);
} else {
  // Fallback to History API
  window.addEventListener('popstate', handlePopState);
  document.addEventListener('click', (e) => {
    const link = e.target.closest('a');
    if (link && link.origin === location.origin) {
      e.preventDefault();
      history.pushState(null, '', link.href);
      handleRouteChange(link.href);
    }
  });
}
```

### Checklist

- [ ] Use `navigation.addEventListener('navigate', ...)` instead of multiple History API listeners.
- [ ] Check `event.canIntercept` before calling `event.intercept()` — cross-origin navigations cannot be intercepted.
- [ ] Pass `event.signal` to all `fetch()` calls to automatically abort on navigation cancellation.
- [ ] Use `scroll: 'after-transition'` for automatic scroll restoration.
- [ ] Use `focusReset: 'after-transition'` to move focus to the new content after render.
- [ ] Handle `navigateerror` for failed navigations — show an error page, not a blank screen.
- [ ] Feature detection: `if ('navigation' in window)` with History API fallback.
- [ ] Use `navigation.updateCurrentEntry()` to persist scroll position or form state.

### Anti-Patterns

- Ignoring `event.signal` — leads to race conditions where stale data renders over the current page.
- Intercepting download links (`event.downloadRequest !== null`) — let them proceed natively.
- Intercepting cross-origin navigations — `canIntercept` is `false`, but not checking causes errors.
- Mixing History API and Navigation API in the same codebase — use one or the other, with feature detection.
- Not providing a loading indicator during `handler()` — users see no feedback for slow navigations.

> **Sources:** MDN — Navigation API; WICG Navigation API spec; Chrome Developers — "Modern client-side routing: the Navigation API" (Jake Archibald, 2022); Chrome 102 release notes.

---

## CJ. Third-Party Script Performance

### Overview

Third-party scripts (analytics, ads, chat widgets, social embeds, A/B testing, consent managers) are the largest contributor to web performance degradation for most sites. Studies show third-party code accounts for **57% of JavaScript execution time** on the median website (HTTP Archive, 2024). Careful loading strategies can reduce Total Blocking Time (TBT) by 50–80% without losing functionality.

### Script Loading Strategies

```html
<!-- Blocks HTML parsing — avoid for 3P scripts -->
<script src="https://example.com/widget.js"></script>

<!-- Async: downloads in parallel, executes ASAP (blocks parsing briefly on execute) -->
<script async src="https://example.com/analytics.js"></script>

<!-- Defer: downloads in parallel, executes after HTML parsing, in order -->
<script defer src="https://example.com/non-critical.js"></script>

<!-- Module: deferred by default, strict mode -->
<script type="module" src="https://example.com/modern.js"></script>
```

| Strategy | Download | Execution | Order Preserved | Use For |
|----------|----------|-----------|-----------------|---------|
| (none) | Blocking | Blocking | Yes | Never for 3P |
| `async` | Parallel | ASAP | No | Analytics, ads |
| `defer` | Parallel | After parse | Yes | Non-critical, order-dependent |
| `module` | Parallel | After parse | Yes | Modern 3P with ESM |

### Loading Priority Decision Tree

```
Is the script needed for above-the-fold content?
├── Yes → <script defer> in <head> (or inline critical portion)
└── No → Is it needed on page load at all?
    ├── Yes → <script async> or requestIdleCallback
    └── No → Is it triggered by user interaction?
        ├── Yes → Load on interaction (facade pattern)
        └── No → Load after page is fully interactive (setTimeout or idle)
```

### Consent-Gated Loading

GDPR/CCPA compliance requires delaying analytics and ad scripts until consent:

```js
// Only load after user grants consent
function onConsentGranted(categories) {
  if (categories.includes('analytics')) {
    const script = document.createElement('script');
    script.src = 'https://www.googletagmanager.com/gtag/js?id=G-XXXXXXX';
    script.async = true;
    document.head.appendChild(script);
  }
  if (categories.includes('marketing')) {
    loadFacebookPixel();
    loadLinkedInInsight();
  }
}
```

**Performance benefit:** Users who decline cookies never download tracking scripts (~200–500 KB savings).

### Facade Pattern for Embeds

Replace heavy embeds with lightweight placeholders that load the real embed on interaction:

```html
<!-- Instead of loading the full YouTube embed (1.3 MB) -->
<!-- Use a facade: static thumbnail + play button -->
<div class="youtube-facade" data-video-id="dQw4w9WgXcQ"
     role="button" aria-label="Play video: Title Here"
     tabindex="0">
  <img src="https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg"
       alt="Video thumbnail" loading="lazy" width="480" height="360">
  <button class="play-btn" aria-hidden="true">▶</button>
</div>
```

```js
document.querySelectorAll('.youtube-facade').forEach(facade => {
  const load = () => {
    const iframe = document.createElement('iframe');
    iframe.src = `https://www.youtube.com/embed/${facade.dataset.videoId}?autoplay=1`;
    iframe.allow = 'autoplay; encrypted-media';
    iframe.allowFullscreen = true;
    iframe.width = 480;
    iframe.height = 360;
    facade.replaceWith(iframe);
  };
  facade.addEventListener('click', load, { once: true });
  facade.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' || e.key === ' ') load();
  }, { once: true });
});
```

**Savings by embed type:**

| Embed | Full Load Cost | Facade Cost | Savings |
|-------|---------------|-------------|---------|
| YouTube | ~1.3 MB, 32 requests | ~15 KB (thumbnail) | 98.8% |
| Google Maps | ~800 KB, 25 requests | ~20 KB (static map image) | 97.5% |
| Twitter/X embed | ~1.1 MB, 15 requests | ~5 KB (quoted text + link) | 99.5% |
| Intercom chat | ~400 KB, 8 requests | ~2 KB (chat icon SVG) | 99.5% |

### Partytown (Web Worker Offloading)

Partytown moves third-party scripts to a web worker, freeing the main thread:

```html
<!-- In <head> -->
<script src="/~partytown/partytown.js"></script>

<!-- Third-party script runs in web worker instead of main thread -->
<script type="text/partytown" src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXX"></script>
```

| Metric | Without Partytown | With Partytown | Improvement |
|--------|------------------|----------------|-------------|
| Total Blocking Time | ~1,200 ms | ~200 ms | −83% |
| Main thread JS time | ~3,500 ms | ~800 ms | −77% |
| TTI | ~4,200 ms | ~1,800 ms | −57% |

**Limitations:**
- Scripts that access DOM directly (e.g., chat widgets that inject UI) require proxying and may not work correctly.
- `document.cookie` access is async in the worker — some scripts break.
- Best for analytics, tracking pixels, and non-UI scripts.

### Performance Budgets for Third-Party Scripts

| Metric | Budget | Measurement |
|--------|--------|-------------|
| Total 3P JavaScript | < 100 KB compressed | `Performance.getEntriesByType('resource').filter(r => !r.name.includes(location.host))` |
| 3P execution time | < 500 ms on mobile 3G | Chrome DevTools > Performance > Bottom-Up > Group by Domain |
| 3P requests | < 10 origins | DevTools > Network > Group by Domain |
| TBT contribution from 3P | < 200 ms | Lighthouse > Treemap > Third-party code |
| DNS lookups for 3P | Preconnect top 3 origins | `<link rel="preconnect" href="https://...">` |

```html
<!-- Preconnect to critical third-party origins -->
<link rel="preconnect" href="https://www.googletagmanager.com">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="dns-prefetch" href="https://cdn.example-analytics.com">
```

### Monitoring and Auditing

```js
// PerformanceObserver for long tasks caused by 3P
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) { // Long task (>50ms)
      const attribution = entry.attribution?.[0];
      console.warn(`Long task: ${entry.duration}ms`,
        attribution?.containerSrc || 'inline script');
    }
  }
});
observer.observe({ type: 'longtask', buffered: true });
```

### Checklist

- [ ] Never use blocking `<script>` for third-party code — always `async` or `defer`.
- [ ] Apply facade pattern to heavy embeds (YouTube, Maps, chat widgets).
- [ ] Set a 3P JS budget: < 100 KB compressed, < 500 ms execution time.
- [ ] Preconnect to top 3 third-party origins: `<link rel="preconnect">`.
- [ ] Gate analytics/marketing scripts behind cookie consent.
- [ ] Consider Partytown for analytics scripts that don't need DOM access.
- [ ] Audit 3P impact quarterly: Lighthouse > Treemap > Third-party code.
- [ ] Monitor long tasks with `PerformanceObserver` — flag 3P scripts exceeding 50 ms.
- [ ] Lazy-load below-the-fold social embeds with `loading="lazy"` on iframes.
- [ ] Remove unused 3P scripts — audit with Chrome DevTools Coverage panel.

### Anti-Patterns

- Loading all 3P scripts synchronously in `<head>` — blocks page render entirely.
- Multiple analytics providers tracking the same events — redundant load (~100–300 KB each).
- Chat widgets loading on every page when only used on support pages — load conditionally.
- No `rel="preconnect"` for critical 3P origins — adds 100–300 ms DNS+TLS per origin.
- A/B testing scripts that block rendering while fetching experiment config — use edge-side A/B instead.
- Not auditing 3P scripts after initial integration — they grow over time (tag managers accumulate tags).

> **Sources:** web.dev — "Loading Third-Party JavaScript" (Addy Osmani & Arthur Evans); Lighthouse documentation — "Reduce the impact of third-party code"; Harry Roberts (csswizardry) — "Third-Party Performance" (2023); HTTP Archive — Web Almanac, Third Parties chapter (2024); Partytown documentation (builder.io).

---

## CK. Permissions Policy Headers

### Overview

Permissions Policy (formerly Feature Policy) is an HTTP response header and HTML attribute that allows a site to control which browser features can be used by its own code and by embedded third-party iframes. It provides defense-in-depth against malicious or misbehaving third-party scripts and enforces least-privilege access to sensitive APIs (camera, microphone, geolocation, payment). Supported in Chrome 88+, Edge 88+, Firefox 74+ (partial), Safari 15.4+ (partial).

### Header Syntax

```http
Permissions-Policy: camera=(), microphone=(), geolocation=(self), payment=(self "https://checkout.stripe.com"), fullscreen=(self)
```

| Directive | Value | Meaning |
|-----------|-------|---------|
| `camera=()` | Empty | Disabled for all — no page or iframe can access camera |
| `microphone=()` | Empty | Disabled for all |
| `geolocation=(self)` | `self` | Allowed for same-origin only |
| `payment=(self "https://checkout.stripe.com")` | Origins | Allowed for same-origin and specified third-party |
| `fullscreen=(self)` | `self` | Allowed for same-origin only |
| `autoplay=(self)` | `self` | Autoplay allowed only for same-origin |

### Recommended Default Policy

```http
Permissions-Policy: accelerometer=(), ambient-light-sensor=(), autoplay=(self), battery=(), camera=(), cross-origin-isolated=(), display-capture=(), document-domain=(), encrypted-media=(self), execution-while-not-rendered=(), execution-while-out-of-viewport=(), fullscreen=(self), gamepad=(), geolocation=(), gyroscope=(), hid=(), identity-credentials-get=(), idle-detection=(), local-fonts=(), magnetometer=(), microphone=(), midi=(), otp-credentials=(), payment=(), picture-in-picture=(self), publickey-credentials-create=(), publickey-credentials-get=(), screen-wake-lock=(), serial=(), speaker-selection=(), storage-access=(), usb=(), web-share=(self), xr-spatial-tracking=()
```

**Principle:** Deny everything by default, then allow specific features as needed. This is the "allowlist" approach.

### Iframe Sandboxing with `allow`

```html
<!-- Third-party iframe with minimal permissions -->
<iframe
  src="https://maps.example.com/embed"
  allow="geolocation 'self'"
  sandbox="allow-scripts allow-same-origin"
  loading="lazy"
  width="600" height="400"
  title="Interactive map"
></iframe>

<!-- Payment iframe with specific permissions -->
<iframe
  src="https://checkout.stripe.com/pay"
  allow="payment 'src'"
  sandbox="allow-scripts allow-forms allow-same-origin allow-popups"
  title="Checkout form"
></iframe>
```

The `allow` attribute on iframes restricts what features the embedded content can use, independent of the parent page's Permissions Policy.

### Common Feature Policies

| Feature | Recommended Policy | Reason |
|---------|-------------------|--------|
| `camera` | `()` unless video app | Prevents drive-by camera access |
| `microphone` | `()` unless voice/audio app | Prevents silent recording |
| `geolocation` | `(self)` or `()` | Location access should be first-party only |
| `autoplay` | `(self)` | Prevents 3P ads from autoplaying audio |
| `payment` | `(self "https://trusted-psp.com")` | Restricts Payment Request API to trusted processors |
| `fullscreen` | `(self)` | Prevents 3P iframes from going fullscreen without permission |
| `document-domain` | `()` | Deprecated feature — disable entirely |
| `display-capture` | `()` unless screen-sharing app | Prevents screen capture |
| `serial`, `usb`, `hid`, `bluetooth` | `()` | Hardware APIs rarely needed in web apps |

### Reporting Violations

```http
Permissions-Policy: camera=()
Reporting-Endpoints: permissions="https://reporting.example.com/permissions"

<!-- Alternative: Report-To header (older API) -->
Report-To: {"group":"permissions","max_age":86400,"endpoints":[{"url":"https://reporting.example.com/permissions"}]}
```

```js
// Client-side detection of policy violations
document.addEventListener('securitypolicyviolation', (e) => {
  if (e.disposition === 'enforce') {
    console.warn(`Permissions Policy violation: ${e.violatedDirective}`);
    // Optionally show user-facing message:
    // "Camera access is not available on this page."
  }
});
```

### UX When a Feature is Blocked

When a permissions policy blocks a feature, the browser throws an error (e.g., `NotAllowedError` from `getUserMedia`). Your UI should handle this gracefully:

```js
async function requestCamera() {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true });
    showVideoPreview(stream);
  } catch (error) {
    if (error.name === 'NotAllowedError') {
      // Could be permissions policy OR user denied
      showMessage(
        'Camera access is not available.',
        'This may be due to your browser settings or site policy. ' +
        'Please check your browser permissions.'
      );
    }
  }
}
```

### Security-by-Default Patterns

**1. New project template:**

```
# .htaccess or nginx config
Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=(), usb=(), serial=(), bluetooth=(), display-capture=(), document-domain=()
```

Start with everything denied. Add permissions as features are developed.

**2. Feature flag integration:**

```js
// Only request permission if the feature is both policy-allowed and feature-flagged
if (featureFlags.videoChat && document.featurePolicy?.allowsFeature('camera')) {
  showVideoChatButton();
}
```

**3. CSP + Permissions Policy together:**

```http
Content-Security-Policy: default-src 'self'; script-src 'self' https://cdn.example.com
Permissions-Policy: camera=(), microphone=(), geolocation=(self)
```

CSP controls what code can run; Permissions Policy controls what APIs that code can access. Use both.

### Checklist

- [ ] Set a `Permissions-Policy` header on all responses — deny unused features by default.
- [ ] Use `allow` attribute on all third-party iframes with minimum required permissions.
- [ ] Combine `sandbox` + `allow` on iframes for defense-in-depth.
- [ ] Handle `NotAllowedError` gracefully in UI — explain why the feature is unavailable.
- [ ] Disable `document-domain` (`document-domain=()`) — it is deprecated and a security risk.
- [ ] Set up violation reporting with `Reporting-Endpoints` header.
- [ ] Audit permissions quarterly — remove permissions for features no longer in use.
- [ ] Use `document.featurePolicy.allowsFeature()` to check before requesting access.
- [ ] Disable hardware APIs (`serial`, `usb`, `hid`, `bluetooth`) unless specifically needed.

### Anti-Patterns

- No `Permissions-Policy` header — every embedded iframe has full access to all browser APIs by default.
- Allowing `camera` and `microphone` globally when only one page needs them — over-permissive.
- Using only `sandbox` without `allow` on iframes — `sandbox` blocks scripts by default but does not control individual APIs.
- Not testing after policy changes — a new restriction can break existing features silently.
- Permissions Policy without CSP — controls API access but not script execution; use both.

> **Sources:** MDN — Permissions Policy; W3C Permissions Policy spec; Chrome Developers — "Permissions Policy" documentation; OWASP — Security Headers; Scott Helme — "securityheaders.com" analysis.

---

## CL. Web Vitals RUM Implementation

### Overview

Real User Monitoring (RUM) captures performance metrics from actual users in the field — complementing lab tools like Lighthouse. The three Core Web Vitals (LCP, INP, CLS) are Google's ranking signals and the primary metrics for user-perceived performance. A robust RUM pipeline includes: client-side collection via the `web-vitals` library, server-side aggregation at the 75th percentile (p75), dashboards for analysis, and attribution data for debugging regressions.

### Core Web Vitals Targets (2024+)

| Metric | Good | Needs Improvement | Poor | What It Measures |
|--------|------|--------------------|------|-----------------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5 s | 2.5–4.0 s | > 4.0 s | Loading — when the largest visible element renders |
| **INP** (Interaction to Next Paint) | ≤ 200 ms | 200–500 ms | > 500 ms | Responsiveness — worst-case input delay across all interactions |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | 0.1–0.25 | > 0.25 | Visual stability — unexpected layout movements |

**p75 rule:** Google evaluates the **75th percentile** of all page loads, not the median. Your site must meet "Good" thresholds at p75 to pass Core Web Vitals assessment.

### web-vitals Library Setup

```bash
npm install web-vitals
```

```js
// Basic collection
import { onLCP, onINP, onCLS, onFCP, onTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  const body = JSON.stringify({
    name: metric.name,
    value: metric.value,
    rating: metric.rating,   // 'good', 'needs-improvement', 'poor'
    delta: metric.delta,
    id: metric.id,           // unique per page load
    navigationType: metric.navigationType, // 'navigate', 'reload', 'back-forward', etc.
    url: location.href,
    timestamp: Date.now(),
  });

  // Use sendBeacon for reliability (fires even on page unload)
  if (navigator.sendBeacon) {
    navigator.sendBeacon('/api/vitals', body);
  } else {
    fetch('/api/vitals', { body, method: 'POST', keepalive: true });
  }
}

onLCP(sendToAnalytics);
onINP(sendToAnalytics);
onCLS(sendToAnalytics);
onFCP(sendToAnalytics);
onTTFB(sendToAnalytics);
```

### Attribution Builds for Debugging

The `web-vitals/attribution` build includes detailed diagnostic data for each metric:

```js
import { onLCP, onINP, onCLS } from 'web-vitals/attribution';

onLCP((metric) => {
  console.log('LCP element:', metric.attribution.element);           // e.g., 'img.hero'
  console.log('LCP resource URL:', metric.attribution.url);          // e.g., '/images/hero.webp'
  console.log('Time to first byte:', metric.attribution.timeToFirstByte);
  console.log('Resource load delay:', metric.attribution.resourceLoadDelay);
  console.log('Resource load time:', metric.attribution.resourceLoadDuration);
  console.log('Element render delay:', metric.attribution.elementRenderDelay);
});

onINP((metric) => {
  console.log('INP event type:', metric.attribution.eventType);      // e.g., 'pointerup'
  console.log('INP target:', metric.attribution.eventTarget);         // e.g., 'button#submit'
  console.log('Input delay:', metric.attribution.inputDelay);         // ms before handler runs
  console.log('Processing time:', metric.attribution.processingDuration); // handler execution
  console.log('Presentation delay:', metric.attribution.presentationDelay); // paint after handler
});

onCLS((metric) => {
  console.log('Largest shift target:', metric.attribution.largestShiftTarget); // e.g., 'div.ad-slot'
  console.log('Largest shift value:', metric.attribution.largestShiftValue);
  console.log('Largest shift time:', metric.attribution.largestShiftTime);
});
```

**Bundle size:** Base library ~1.5 KB gzipped; attribution build ~3 KB gzipped.

### CrUX API (Chrome User Experience Report)

CrUX provides aggregated field data from Chrome users (28-day rolling window):

```js
// Query CrUX API
async function getCruxData(url) {
  const response = await fetch(
    `https://chromeuxreport.googleapis.com/v1/records:queryRecord?key=${API_KEY}`,
    {
      method: 'POST',
      body: JSON.stringify({
        url: url,
        metrics: [
          'largest_contentful_paint',
          'interaction_to_next_paint',
          'cumulative_layout_shift',
          'experimental_time_to_first_byte',
        ],
      }),
    }
  );
  return response.json();
}

// Response includes histogram buckets and p75 values:
// { record: { metrics: { largest_contentful_paint: { percentiles: { p75: 2400 } } } } }
```

**CrUX vs RUM:**

| Aspect | CrUX | Custom RUM |
|--------|------|------------|
| Data source | Chrome users only (~65% market share) | All browsers |
| Granularity | Origin-level or URL-level (if sufficient traffic) | Per-session, per-user |
| Freshness | 28-day rolling average | Real-time |
| Custom dimensions | None | Page type, user segment, A/B variant, etc. |
| Cost | Free (API + BigQuery) | Infrastructure cost for ingestion + storage |

### PerformanceObserver Patterns

For custom metrics beyond Core Web Vitals:

```js
// Long Tasks (>50ms main thread blocks)
const longTaskObserver = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    sendToAnalytics({
      name: 'long-task',
      value: entry.duration,
      attribution: entry.attribution?.[0]?.containerSrc || 'self',
    });
  }
});
longTaskObserver.observe({ type: 'longtask', buffered: true });

// Resource Timing (slow resources)
const resourceObserver = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 1000) { // Resources taking >1s
      sendToAnalytics({
        name: 'slow-resource',
        value: entry.duration,
        url: entry.name,
        type: entry.initiatorType,
      });
    }
  }
});
resourceObserver.observe({ type: 'resource', buffered: true });

// Element Timing (custom LCP-like tracking for specific elements)
const elementObserver = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    sendToAnalytics({
      name: `element-${entry.identifier}`,
      value: entry.renderTime || entry.loadTime,
    });
  }
});
elementObserver.observe({ type: 'element', buffered: true });
```

```html
<!-- Mark specific elements for Element Timing -->
<img elementtiming="hero-image" src="/hero.webp" alt="Hero">
<h1 elementtiming="main-heading">Welcome</h1>
```

### Dashboard Design

Structure your RUM dashboard around these views:

**1. Overview (executive):**
- p75 LCP, INP, CLS — current values with trend arrows (7-day / 30-day).
- % of page loads in "Good" threshold for each metric.
- Traffic-weighted overall score.

**2. Breakdown (debugging):**
- Metrics by page type (homepage, PDP, checkout, search results).
- Metrics by device (mobile / desktop / tablet).
- Metrics by connection type (4G, 3G, slow-2G).
- Metrics by geography (country-level).
- Metrics by browser (Chrome, Safari, Firefox).

**3. Regressions (alerting):**
- Alert when p75 crosses from "Good" to "Needs Improvement" for 2+ consecutive days.
- Show deployment markers on timeline charts.
- Drill down from regression to attribution data (which element, which resource).

**4. A/B test correlation:**
- Web Vitals by experiment variant.
- Conversion rate overlaid with performance metrics.

### Data Pipeline Architecture

```
Browser                    Server                      Dashboard
┌──────────┐    beacon    ┌──────────────┐   ETL      ┌──────────┐
│web-vitals├──────────────►│ /api/vitals  ├───────────►│ BigQuery │
│ library  │              │ (edge fn)    │            │ or       │
└──────────┘              └──────┬───────┘            │ ClickHouse│
                                 │                     └────┬─────┘
                                 │ buffer + batch            │
                                 ▼                           ▼
                          ┌──────────────┐            ┌──────────┐
                          │ Message Queue│            │ Grafana / │
                          │ (Kafka/SQS)  │            │ Looker    │
                          └──────────────┘            └──────────┘
```

**Key decisions:**
- Use `navigator.sendBeacon()` for reliable delivery on page unload.
- Batch writes: buffer client events for 5–10 seconds before flushing (reduces server load).
- Sample at high traffic: collect 100% up to 10K daily page loads, then sample 10–25% above that.
- Store raw events for 90 days; aggregated p75 values indefinitely.

### Sampling Strategy

| Daily Page Views | Recommended Sample Rate | Estimated Monthly Storage |
|-----------------|------------------------|--------------------------|
| < 10,000 | 100% | ~50 MB |
| 10,000–100,000 | 25% | ~125 MB |
| 100,000–1,000,000 | 10% | ~500 MB |
| > 1,000,000 | 1–5% | ~1 GB |

```js
// Client-side sampling
const SAMPLE_RATE = 0.1; // 10%

function sendToAnalytics(metric) {
  if (Math.random() > SAMPLE_RATE) return;
  // ... send metric
}
```

### Checklist

- [ ] Install `web-vitals` library and report LCP, INP, CLS, FCP, TTFB.
- [ ] Use the `/attribution` build in staging/debugging; base build in production if bundle size matters.
- [ ] Send metrics via `navigator.sendBeacon()` for reliable delivery.
- [ ] Evaluate at **p75** — not median, not average.
- [ ] Targets: LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 at p75.
- [ ] Segment by device type, connection speed, page type, and geography.
- [ ] Set up alerts for p75 regressions crossing "Good" → "Needs Improvement."
- [ ] Add deployment markers to timeline charts for regression correlation.
- [ ] Use `elementtiming` attribute on key above-the-fold elements.
- [ ] Monitor long tasks with `PerformanceObserver({ type: 'longtask' })`.
- [ ] Implement sampling for sites with > 10K daily page views.
- [ ] Cross-reference CrUX data with your RUM for validation.
- [ ] Include `navigationType` in reports — distinguish between navigations, reloads, and back-forward.

### Anti-Patterns

- Reporting only averages — outliers (p95, p99) skew averages; p75 is the standard for Core Web Vitals.
- Using `fetch()` without `keepalive: true` on page unload — request is cancelled by the browser.
- Collecting RUM data but never acting on it — dashboards without alert thresholds are vanity metrics.
- Not segmenting by device — desktop p75 may be "Good" while mobile is "Poor."
- Sampling at 1% on low-traffic sites — insufficient data for meaningful p75 calculations (need ~200+ samples per segment).
- Ignoring `navigationType` — back-forward navigations from bfcache have near-zero LCP, skewing data downward.
- Alerting on daily fluctuations — use 2-day or 7-day rolling p75 to avoid noise.

---
## CM. Flexbox & Layout Patterns

Professional CSS layout patterns every web developer needs, with exact copy-paste-ready code.

### Centering — The 3 Canonical Methods

**Method 1 — Flexbox (most common):**

```css
.center-flex {
  display: flex;
  justify-content: center;   /* horizontal */
  align-items: center;        /* vertical */
  min-height: 100vh;          /* or any defined height */
}
```

**Method 2 — Grid (most concise):**

```css
.center-grid {
  display: grid;
  place-items: center;
  min-height: 100vh;
}
```

**Method 3 — Absolute + Transform (legacy-friendly):**

```css
.center-absolute {
  position: relative;
}
.center-absolute > .child {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

### Sticky Footer

The page footer sticks to the bottom even when content is short.

```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  margin: 0;
}
main {
  flex-grow: 1;   /* pushes footer down */
}
footer {
  flex-shrink: 0;
}
```

### Navbar Pattern

Logo left, navigation center, action buttons right.

```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  height: 64px;
}
.navbar__logo {
  flex-shrink: 0;
}
.navbar__nav {
  display: flex;
  gap: 24px;
  /* centering trick — give logo and actions equal width */
}
.navbar__actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}
```

Alternatively, use `margin-left: auto` on `.navbar__actions` if exact centering of nav is not required.

### Equal-Height Cards

All cards in a row stretch to the height of the tallest card, with the card body filling remaining space.

```css
.card-grid {
  display: flex;
  gap: 24px;
  flex-wrap: wrap;
}
.card {
  display: flex;
  flex-direction: column;
  flex: 1 1 300px;            /* grow, shrink, min-width */
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  overflow: hidden;
}
.card__body {
  flex: 1;                    /* fills remaining height */
  padding: 16px;
}
.card__actions {
  padding: 8px 16px 16px;
  margin-top: auto;           /* pushes actions to bottom */
}
```

### Holy Grail Layout

Header, footer, main content with left and right sidebars.

```css
.holy-grail {
  display: grid;
  grid-template-areas:
    "header  header  header"
    "left    main    right"
    "footer  footer  footer";
  grid-template-columns: 240px 1fr 240px;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
}
.header  { grid-area: header; }
.left    { grid-area: left; }
.main    { grid-area: main; }
.right   { grid-area: right; }
.footer  { grid-area: footer; }

/* Responsive: stack on mobile */
@media (max-width: 768px) {
  .holy-grail {
    grid-template-areas:
      "header"
      "main"
      "left"
      "right"
      "footer";
    grid-template-columns: 1fr;
  }
}
```

### Aspect Ratio Boxes

**Modern method (widely supported since 2021):**

```css
.aspect-box {
  aspect-ratio: 16 / 9;
  width: 100%;
  object-fit: cover;          /* for img/video */
}
```

**Fallback — padding hack (for older browsers):**

```css
.aspect-box-fallback {
  position: relative;
  width: 100%;
  padding-top: 56.25%;        /* 9/16 = 0.5625 = 56.25% */
}
.aspect-box-fallback > * {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  object-fit: cover;
}
```

Common ratios: `16/9` (video), `4/3` (classic), `1/1` (square/avatar), `3/2` (photo), `21/9` (ultrawide hero).

### CSS Grid: auto-fill vs auto-fit with minmax

**`auto-fill`** — creates as many tracks as fit, even if empty (columns stay fixed width):

```css
.grid-auto-fill {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}
```

**`auto-fit`** — collapses empty tracks, so items stretch to fill the row:

```css
.grid-auto-fit {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}
```

**When to use which:**
- `auto-fill`: when you want consistent column widths regardless of item count (e.g., product grids).
- `auto-fit`: when you have few items and want them to stretch to fill available space (e.g., dashboard widgets).

### Checklist

- [ ] Use flexbox for 1D layouts (rows or columns), grid for 2D layouts.
- [ ] Always set `min-height: 0` on flex children that contain overflow content (prevents flex blowout).
- [ ] Use `gap` instead of margin hacks for spacing between flex/grid children.
- [ ] Test layouts at 320px, 768px, 1024px, 1440px breakpoints minimum.
- [ ] Use `flex-wrap: wrap` on card grids to handle overflow gracefully.
- [ ] Prefer `aspect-ratio` over padding hack for new projects (95%+ browser support).
- [ ] Set `margin: 0` on body for sticky footer pattern to work correctly.

---
## CN. Input Field States Deep Dive

Complete input field state matrix with exact CSS values for every state, transition, and variant.

### CSS Custom Properties for Theming

```css
:root {
  /* Input base tokens */
  --input-border: #d1d5db;
  --input-border-hover: #9ca3af;
  --input-border-focus: #3b82f6;
  --input-border-error: #ef4444;
  --input-border-disabled: #e5e7eb;

  --input-bg: #ffffff;
  --input-bg-hover: #fafbfc;
  --input-bg-disabled: #f9fafb;
  --input-bg-readonly: #f3f4f6;

  --input-text: #111827;
  --input-text-placeholder: #9ca3af;
  --input-text-disabled: #9ca3af;

  --input-ring-focus: rgba(59, 130, 246, 0.3);
  --input-ring-error: rgba(239, 68, 68, 0.3);

  --input-radius: 4px;
  --input-height-sm: 32px;
  --input-height-md: 36px;
  --input-height-lg: 40px;

  --input-font-size: 14px;
  --input-line-height: 20px;

  --input-helper-color: #6b7280;
  --input-helper-error: #ef4444;
  --input-helper-size: 12px;

  --input-transition: 150ms ease;
}
```

### Default State

```css
.input {
  width: 100%;
  height: var(--input-height-md);
  padding: 10px 14px;
  border: 1px solid var(--input-border);       /* #d1d5db */
  border-radius: var(--input-radius);          /* 4px */
  background: var(--input-bg);                 /* #fff */
  color: var(--input-text);                    /* #111827 */
  font-size: var(--input-font-size);           /* 14px */
  line-height: var(--input-line-height);       /* 20px */
  outline: none;
  transition: border-color var(--input-transition),
              box-shadow var(--input-transition),
              background-color var(--input-transition);
}
.input::placeholder {
  color: var(--input-text-placeholder);        /* #9ca3af */
}
```

### Hover State

```css
.input:hover:not(:focus):not(:disabled):not([readonly]) {
  border-color: var(--input-border-hover);     /* #9ca3af */
  background: var(--input-bg-hover);           /* #fafbfc subtle */
}
```

### Focus State

```css
.input:focus {
  border-color: var(--input-border-focus);     /* #3b82f6 */
  box-shadow: 0 0 0 3px var(--input-ring-focus); /* rgba(59,130,246,0.3) */
  outline: none;
}
```

### Filled State

```css
/* Same as default — no special styling needed.
   The text color remains --input-text (#111827).
   Border reverts to default after blur. */
```

### Error State

```css
.input--error,
.input[aria-invalid="true"] {
  border-color: var(--input-border-error);     /* #ef4444 */
}
.input--error:focus,
.input[aria-invalid="true"]:focus {
  box-shadow: 0 0 0 3px var(--input-ring-error); /* rgba(239,68,68,0.3) */
}
```

### Disabled State

```css
.input:disabled {
  background: var(--input-bg-disabled);        /* #f9fafb */
  border-color: var(--input-border-disabled);  /* #e5e7eb */
  color: var(--input-text-disabled);           /* #9ca3af */
  cursor: not-allowed;
  opacity: 0.6;
  /* Do NOT use pointer-events:none — user should see the not-allowed cursor */
}
```

### Read-Only State

```css
.input[readonly] {
  background: var(--input-bg-readonly);        /* #f3f4f6 */
  cursor: default;
  /* Border stays at default — read-only is still selectable/copyable */
}
```

### Floating Label

```css
.field {
  position: relative;
}
.field__label {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  font-size: var(--input-font-size);           /* 14px */
  color: var(--input-text-placeholder);
  pointer-events: none;
  transition: transform var(--input-transition),
              font-size var(--input-transition),
              color var(--input-transition);
  transform-origin: left center;
  background: var(--input-bg);
  padding: 0 4px;
}
/* Float up when focused or filled */
.field__input:focus + .field__label,
.field__input:not(:placeholder-shown) + .field__label {
  transform: translateY(-130%);
  font-size: 11px;
  color: var(--input-border-focus);            /* #3b82f6 on focus */
}
.field__input:not(:focus):not(:placeholder-shown) + .field__label {
  color: var(--input-helper-color);            /* #6b7280 when filled but not focused */
}
```

### Helper Text

```css
.field__helper {
  font-size: var(--input-helper-size);         /* 12px */
  color: var(--input-helper-color);            /* #6b7280 */
  margin-top: 4px;
  line-height: 16px;
}
.field--error .field__helper {
  color: var(--input-helper-error);            /* #ef4444 */
}
```

### Icon Placement

```css
/* Left icon */
.input--icon-left {
  padding-left: 40px;
}
.field__icon--left {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  color: #9ca3af;
  pointer-events: none;
}

/* Right icon */
.input--icon-right {
  padding-right: 40px;
}
.field__icon--right {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  color: #9ca3af;
}
```

### Character Counter

```css
.field__counter {
  font-size: 12px;
  color: var(--input-helper-color);            /* #6b7280 */
  text-align: right;
  margin-top: 4px;
}
.field__counter--limit {
  color: var(--input-helper-error);            /* #ef4444 — at or over limit */
  font-weight: 500;
}
```

### Textarea

```css
.textarea {
  /* Inherits all .input styles, plus: */
  resize: vertical;
  min-height: 80px;
  height: auto;
  padding: 10px 14px;
  line-height: 1.5;
}
```

### Error State with Icon

```css
.field--error .field__icon--right {
  color: var(--input-border-error);            /* #ef4444 */
}
/* Use a warning/exclamation icon on error;
   replace any existing right icon (e.g., search) with the error icon */
```

### Input Sizes

```css
.input--sm {
  height: var(--input-height-sm);              /* 32px */
  padding: 6px 10px;
  font-size: 13px;
}
.input--md {
  height: var(--input-height-md);              /* 36px — default */
  padding: 8px 14px;
  font-size: 14px;
}
.input--lg {
  height: var(--input-height-lg);              /* 40px */
  padding: 10px 16px;
  font-size: 15px;
}
```

### Checklist

- [ ] Every input has a visible label (floating or static) — never rely on placeholder alone.
- [ ] Error messages use `aria-describedby` linking to the helper text element.
- [ ] Error inputs use `aria-invalid="true"`.
- [ ] Focus ring is visible for keyboard users — never remove outline without replacement.
- [ ] Disabled inputs are excluded from tab order (native `disabled` attribute handles this).
- [ ] Read-only inputs remain in tab order and are copyable.
- [ ] Transition all state changes (border, shadow, background) for 150ms smoothness.
- [ ] Test color contrast of placeholder text (minimum 3:1 ratio per WCAG).
- [ ] Character counter updates live with `aria-live="polite"`.

---
## CO. Border Radius System

A systematic scale for border-radius values with clear usage guidance, CSS custom properties, and consistency rules.

### CSS Custom Properties

```css
:root {
  --radius-none: 0px;
  --radius-sm: 2px;
  --radius: 4px;
  --radius-md: 6px;
  --radius-lg: 8px;
  --radius-xl: 12px;
  --radius-2xl: 16px;
  --radius-full: 9999px;
}
```

### 0px — Sharp / None

```css
border-radius: var(--radius-none);   /* 0px */
```

**Use for:** data tables, table cells, code blocks (`<pre>`, `<code>` inline with parent), horizontal rules, full-bleed sections, dividers, and elements that need to tile flush against each other.

### 2px — Subtle

```css
border-radius: var(--radius-sm);     /* 2px */
```

**Use for:** badges, tags, inline code snippets, small chips, status indicators, keyboard shortcut hints (`<kbd>`), and tiny UI elements where sharp feels too harsh but rounded is too much.

### 4px — Default

```css
border-radius: var(--radius);        /* 4px */
```

**Use for:** buttons (primary default), text inputs, selects, textareas, small cards, tooltips, checkboxes (subtle rounding), toggle containers, and most interactive elements. This is the workhorse value — when in doubt, use 4px.

### 6px — Medium

```css
border-radius: var(--radius-md);     /* 6px */
```

**Use for:** medium cards, dropdown menus, alert banners, notification toasts, popover containers, and inline callout boxes. A step up from default that signals "container" rather than "interactive element."

### 8px — Large

```css
border-radius: var(--radius-lg);     /* 8px */
```

**Use for:** large cards, modals, dialog boxes, sidebar panels, image containers, and any prominent surface that needs to feel friendly and approachable. The most common card radius in modern design systems.

### 12px — Extra Large

```css
border-radius: var(--radius-xl);     /* 12px */
```

**Use for:** feature cards, hero sections, large promotional panels, pricing cards, onboarding cards, and high-emphasis containers. Signals importance and visual warmth.

### 16px — Pill-Adjacent

```css
border-radius: var(--radius-2xl);    /* 16px */
```

**Use for:** pill-shaped buttons, search bars, floating action containers, chat bubbles, and elements that need to feel soft and modern. Also used for large floating elements like cookie banners.

### 9999px — Full / Circle

```css
border-radius: var(--radius-full);   /* 9999px */
```

**Use for:** avatars (with equal width and height), status dots, circular icon buttons, progress indicators, and any element that must be perfectly round. The `9999px` value ensures a circle regardless of element size.

### Consistency Rules

1. **All interactive elements share one radius.** Buttons, inputs, selects, and textareas should all use the same `--radius` value (e.g., 4px). Mixing 4px buttons with 8px inputs looks inconsistent.

2. **All cards share one radius.** Every card-like surface on the page (content cards, modal, dropdown, alert) should use the same radius. Pick one: 6px, 8px, or 12px.

3. **Never mix more than 3 radius values on one page.** A typical system uses:
   - Small (2-4px) for interactive elements and small UI
   - Medium (6-8px) for containers and cards
   - Full (9999px) for avatars and circular elements

4. **Nested radius rule:** Inner elements should have a smaller radius than their parent. If a card has 12px radius, inner elements should use 8px or less. The formula: `inner-radius = outer-radius - padding`. If the card has 12px radius and 16px padding, the inner radius should be ~8px maximum.

5. **Images inside rounded containers:** Use `overflow: hidden` on the container, or apply the same border-radius to the image. Never let image corners poke out of a rounded container.

```css
.card {
  border-radius: var(--radius-lg);   /* 8px */
  overflow: hidden;                   /* clips child images */
}
.card__inner {
  border-radius: calc(var(--radius-lg) - 4px); /* 4px inner */
}
```

### Design System Integration

| Component        | Radius Token      | Value  |
|-----------------|-------------------|--------|
| Button          | `--radius`        | 4px    |
| Input / Select  | `--radius`        | 4px    |
| Tooltip         | `--radius`        | 4px    |
| Badge / Tag     | `--radius-sm`     | 2px    |
| Dropdown        | `--radius-md`     | 6px    |
| Card            | `--radius-lg`     | 8px    |
| Modal / Dialog  | `--radius-lg`     | 8px    |
| Alert / Toast   | `--radius-md`     | 6px    |
| Feature Card    | `--radius-xl`     | 12px   |
| Search Bar      | `--radius-2xl`    | 16px   |
| Pill Button     | `--radius-full`   | 9999px |
| Avatar          | `--radius-full`   | 9999px |
| Checkbox        | `--radius-sm`     | 2px    |
| Toggle Track    | `--radius-full`   | 9999px |

### Sources

- Tailwind CSS border-radius scale (`rounded-none` through `rounded-full`)
- Radix UI Themes radius system
- Shadcn/ui component defaults
- Apple Human Interface Guidelines corner radius guidance
- Material Design shape system (small, medium, large, extra-large)

---
## CP. Color Palette Construction (60-30-10)

Building a complete, production-ready color system from a single brand color.

### The 60-30-10 Rule

| Proportion | Role                        | Examples                                |
|-----------|-----------------------------|-----------------------------------------|
| **60%**   | Dominant (background)       | Page background, large surfaces, white space |
| **30%**   | Secondary (supporting)      | Cards, sidebars, section backgrounds, secondary text |
| **10%**   | Accent (emphasis)           | CTAs, links, active states, icons, highlights |

This ratio creates visual harmony. The eye rests on the 60%, scans the 30%, and is drawn to the 10%.

### Starting from ONE Brand Color

Given a single brand color, generate a full palette using HSL manipulation.

**Step 1 — Define the primary:**

```css
/* Example brand color: a vibrant blue */
--color-primary-500: hsl(220, 90%, 56%);
```

**Step 2 — Generate primary variants (lighten/darken):**

```css
:root {
  --color-primary-50:  hsl(220, 90%, 97%);   /* tinted background */
  --color-primary-100: hsl(220, 90%, 93%);   /* light highlight */
  --color-primary-200: hsl(220, 85%, 85%);   /* light border */
  --color-primary-300: hsl(220, 80%, 72%);   /* disabled / muted */
  --color-primary-400: hsl(220, 85%, 64%);   /* hover state */
  --color-primary-500: hsl(220, 90%, 56%);   /* BASE — buttons, links */
  --color-primary-600: hsl(220, 85%, 48%);   /* hover (on light bg) */
  --color-primary-700: hsl(220, 80%, 40%);   /* active / pressed */
  --color-primary-800: hsl(220, 75%, 32%);   /* heavy emphasis */
  --color-primary-900: hsl(220, 70%, 24%);   /* dark text on light */
  --color-primary-950: hsl(220, 65%, 15%);   /* near-black accent */
}
```

**Pattern:** As lightness increases, slightly decrease saturation to avoid neon tones. As lightness decreases, decrease saturation to avoid muddy darks.

**Step 3 — Choose a secondary color:**

```
Complementary:  hue ± 180° → hsl(40, 90%, 56%)  — high contrast, bold
Analogous:      hue ± 30°  → hsl(250, 90%, 56%) — harmonious, subtle
Split-comp:     hue ± 150° → hsl(70, 90%, 56%)  — balanced contrast
Triadic:        hue ± 120° → hsl(340, 90%, 56%) — vibrant, diverse
```

For most apps, analogous (±30°) is safest. Complementary works for marketing sites.

**Step 4 — Build the neutral scale:**

Use the same hue as your primary color with very low saturation (5-10%) for a cohesive feel. Pure grays (#737373) feel disconnected from colored UIs.

```css
:root {
  /* Neutral scale — tinted with primary hue (220°) */
  --color-neutral-50:  hsl(220, 8%, 98%);    /* #fafafa — page bg */
  --color-neutral-100: hsl(220, 7%, 96%);    /* #f5f5f5 — subtle bg */
  --color-neutral-200: hsl(220, 6%, 90%);    /* #e5e5e5 — borders */
  --color-neutral-300: hsl(220, 5%, 83%);    /* #d4d4d4 — disabled border */
  --color-neutral-400: hsl(220, 4%, 64%);    /* #a3a3a3 — placeholder */
  --color-neutral-500: hsl(220, 4%, 45%);    /* #737373 — secondary text */
  --color-neutral-600: hsl(220, 5%, 32%);    /* #525252 — body text */
  --color-neutral-700: hsl(220, 6%, 25%);    /* #404040 — headings */
  --color-neutral-800: hsl(220, 7%, 15%);    /* #262626 — strong text */
  --color-neutral-900: hsl(220, 8%, 9%);     /* #171717 — near-black */
  --color-neutral-950: hsl(220, 10%, 4%);    /* #0a0a0a — true dark */
}
```

**Step 5 — Semantic colors:**

```css
:root {
  /* Success — green */
  --color-success-50:  hsl(142, 70%, 95%);
  --color-success-100: hsl(142, 65%, 87%);
  --color-success-500: #22c55e;               /* primary green */
  --color-success-600: #16a34a;               /* hover */
  --color-success-700: #15803d;               /* active */

  /* Warning — amber */
  --color-warning-50:  hsl(48, 96%, 95%);
  --color-warning-100: hsl(48, 90%, 85%);
  --color-warning-500: #f59e0b;               /* primary amber */
  --color-warning-600: #d97706;               /* hover */
  --color-warning-700: #b45309;               /* active */

  /* Error / Destructive — red */
  --color-error-50:  hsl(0, 86%, 97%);
  --color-error-100: hsl(0, 80%, 90%);
  --color-error-500: #ef4444;                 /* primary red */
  --color-error-600: #dc2626;                 /* hover */
  --color-error-700: #b91c1c;                 /* active */

  /* Info — blue (can share primary if primary is blue) */
  --color-info-50:  hsl(210, 80%, 96%);
  --color-info-100: hsl(210, 75%, 88%);
  --color-info-500: #3b82f6;                  /* primary blue */
  --color-info-600: #2563eb;                  /* hover */
  --color-info-700: #1d4ed8;                  /* active */
}
```

**Semantic variant pattern — background, border, and text from one semantic color:**

```css
/* Error alert example */
.alert--error {
  background: var(--color-error-50);           /* 10% opacity feel */
  border: 1px solid hsl(0, 80%, 80%);         /* 30% opacity feel */
  color: var(--color-error-700);               /* full-strength text */
}
```

### Dark Mode

**Do NOT invert.** Remap instead:

| Light Mode Token         | Light Value          | Dark Value               |
|--------------------------|----------------------|--------------------------|
| `--bg-page`              | `--neutral-50`  (white-ish) | `--neutral-900` (near-black) |
| `--bg-surface`           | `#ffffff`            | `--neutral-800`          |
| `--bg-surface-raised`    | `--neutral-50`       | `--neutral-700`          |
| `--text-primary`         | `--neutral-900`      | `--neutral-50`           |
| `--text-secondary`       | `--neutral-600`      | `--neutral-400`          |
| `--border-default`       | `--neutral-200`      | `--neutral-700`          |
| `--color-primary-500`    | `hsl(220,90%,56%)`   | `hsl(220,80%,65%)` — slightly desaturated and lighter |

```css
@media (prefers-color-scheme: dark) {
  :root {
    --bg-page: var(--color-neutral-900);
    --bg-surface: var(--color-neutral-800);
    --text-primary: var(--color-neutral-50);
    --text-secondary: var(--color-neutral-400);
    --border-default: var(--color-neutral-700);
    /* Accent colors: slightly desaturate and increase lightness by ~10% */
  }
}
```

### Contrast Requirements

| Level | Ratio   | Applies To                      |
|-------|---------|---------------------------------|
| AA    | 4.5:1   | Normal text (< 18px / < 14px bold) |
| AA    | 3:1     | Large text (≥ 18px / ≥ 14px bold), UI components, graphical objects |
| AAA   | 7:1     | Normal text (enhanced)          |
| AAA   | 4.5:1   | Large text (enhanced)           |

**Tools for checking:** Chrome DevTools contrast picker, WebAIM Contrast Checker, Stark plugin (Figma), `axe-core` automated testing.

### Checklist

- [ ] Define one brand color, then derive the full palette from HSL manipulation.
- [ ] Create a 10-step neutral scale tinted with the brand hue (never pure gray).
- [ ] Define semantic colors (success, warning, error, info) with at least 50/500/600/700 variants.
- [ ] Verify AA contrast (4.5:1) for all text/background combinations.
- [ ] Dark mode remaps tokens — never simple CSS `filter: invert()`.
- [ ] Test with color blindness simulators (protanopia, deuteranopia, tritanopia).
- [ ] Never rely on color alone — pair with icons, text labels, or patterns.
- [ ] Document palette in a shared design token file (JSON, CSS, or SCSS).

### Sources

- Refactoring UI by Adam Wathan & Steve Schoger — palette construction methodology
- Material Design 3 color system — tonal palettes and dynamic color
- Tailwind CSS color palette — neutral/slate/gray/zinc scale conventions
- WCAG 2.2 — contrast ratio requirements (1.4.3, 1.4.6, 1.4.11)

---
## CQ. Spacing Applied Rules

When to use margin vs padding vs gap, with exact pixel values for every common component.

### The 8px Grid

ALL spacing values should be multiples of 8px (with 4px for fine adjustments). This creates a consistent visual rhythm across the entire interface.

```
4px   — micro (icon-to-text in tight spaces)
8px   — xs (tight gaps, small padding)
12px  — sm (compact spacing)
16px  — md (default spacing)
20px  — md+ (comfortable spacing)
24px  — lg (section spacing, generous padding)
32px  — xl (large gaps, section padding)
40px  — 2xl
48px  — 3xl (section vertical padding)
64px  — 4xl (large section padding)
96px  — 5xl (hero/section vertical padding)
```

### PADDING — Space INSIDE an Element

Padding creates breathing room between content and its container edges.

**Buttons:**

```css
.btn--sm  { padding: 8px 16px; }     /* 32px height */
.btn--md  { padding: 10px 20px; }    /* 36-40px height */
.btn--lg  { padding: 12px 24px; }    /* 44-48px height */
```

**Cards:**

```css
.card--compact   { padding: 16px; }
.card--default   { padding: 20px; }
.card--spacious  { padding: 24px; }
```

**Sections (vertical padding for page sections):**

```css
.section--sm  { padding: 48px 0; }
.section--md  { padding: 64px 0; }
.section--lg  { padding: 96px 0; }
```

**Inputs:**

```css
.input--sm  { padding: 8px 12px; }
.input--md  { padding: 10px 14px; }
.input--lg  { padding: 12px 16px; }
```

**Modals:**

```css
.modal__header  { padding: 20px 24px; }
.modal__body    { padding: 0 24px 20px; }
.modal__footer  { padding: 16px 24px; }
```

### MARGIN — Space BETWEEN Sibling Elements

Use margin when elements are siblings and flexbox/grid `gap` is not available.

**Typography:**

```css
h1, h2, h3, h4, h5, h6 {
  margin-top: 1.5em;       /* space above heading = 1.5x its own font size */
  margin-bottom: 0.5em;    /* space below heading = 0.5x its own font size */
}
h1:first-child,
h2:first-child,
h3:first-child {
  margin-top: 0;           /* no top margin when first in container */
}
p {
  margin-top: 0;
  margin-bottom: 1em;      /* 16px at default font size */
}
p:last-child {
  margin-bottom: 0;        /* prevent double spacing at container bottom */
}
```

**Form fields (vertical stack without flex):**

```css
.form-group {
  margin-bottom: 20px;     /* 16px compact, 20px default, 24px spacious */
}
.form-group:last-child {
  margin-bottom: 0;
}
```

**Anti-pattern: margin on first/last child.** Always zero out margin-top on first-child and margin-bottom on last-child to prevent spacing leaks:

```css
.container > :first-child { margin-top: 0; }
.container > :last-child  { margin-bottom: 0; }
```

### GAP — Preferred for Flex/Grid Layouts

`gap` is the modern, preferred way to space items in flex and grid containers. It does NOT add space before the first or after the last item.

**Icon + Text:**

```css
.btn-with-icon {
  display: inline-flex;
  align-items: center;
  gap: 8px;                 /* between icon and label */
}
```

**Button Group:**

```css
.btn-group {
  display: flex;
  gap: 8px;                 /* 8px compact, 12px default */
}
```

**Card Grid:**

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;                /* 16px compact, 24px default, 32px spacious */
}
```

**Vertical Stack:**

```css
.stack--tight    { display: flex; flex-direction: column; gap: 8px; }
.stack--default  { display: flex; flex-direction: column; gap: 12px; }
.stack--loose    { display: flex; flex-direction: column; gap: 16px; }
```

**Form Fields (in flex container):**

```css
.form-stack {
  display: flex;
  flex-direction: column;
  gap: 16px;                /* consistent spacing, no margin needed */
}
```

**Navigation Items:**

```css
.nav {
  display: flex;
  gap: 24px;                /* horizontal nav links */
}
```

### Content-to-Edge (Page Margins)

```css
.container {
  width: 100%;
  max-width: 1200px;        /* or 1280px, 1440px */
  margin: 0 auto;
  padding-left: 16px;       /* mobile */
  padding-right: 16px;
}

@media (min-width: 768px) {
  .container {
    padding-left: 24px;     /* tablet */
    padding-right: 24px;
  }
}

@media (min-width: 1024px) {
  .container {
    padding-left: 32px;     /* desktop */
    padding-right: 32px;
  }
}
```

### Decision Tree

```
Need space INSIDE a box (between content and edges)?
  → Use PADDING

Need space BETWEEN siblings in a flex/grid container?
  → Use GAP

Need space BETWEEN siblings in flow layout (no flex/grid)?
  → Use MARGIN (margin-bottom on each, zero on :last-child)

Need space BETWEEN a page edge and content?
  → Use PADDING on the container (not margin on children)
```

### Checklist

- [ ] All spacing values are multiples of 8px (or 4px for fine adjustments).
- [ ] Prefer `gap` over margin for flex/grid layouts.
- [ ] Zero out margin-top on `:first-child` and margin-bottom on `:last-child`.
- [ ] Page margins: 16px mobile, 24px tablet, 32px desktop.
- [ ] Section vertical padding: 48-96px depending on visual weight.
- [ ] Button padding is horizontal-heavy (px > py) for comfortable click targets.
- [ ] Card padding is consistent within a page (pick 16, 20, or 24 — not all three).
- [ ] Test spacing at mobile breakpoints — reduce section padding and card gaps.

### Sources

- Material Design spacing system — 4dp/8dp grid
- Tailwind CSS spacing scale — `space-x`, `gap`, padding/margin utilities
- Nathan Curtis, "Space in Design Systems" (Medium) — spacing taxonomy
- Every Layout (Heydon Pickering & Andy Bell) — compositional spacing patterns

---
## CR. Button Hierarchy Visual Specs

Complete button variant system with exact CSS values for primary, secondary, tertiary, destructive, and link-style buttons.

### CSS Custom Properties

```css
:root {
  /* Button base tokens */
  --btn-radius: 4px;
  --btn-font-weight: 500;
  --btn-transition: 150ms ease;
  --btn-focus-ring: 0 0 0 2px #fff, 0 0 0 4px var(--color-primary-500);

  /* Sizes */
  --btn-h-sm: 32px;
  --btn-h-md: 36px;
  --btn-h-lg: 40px;
  --btn-h-xl: 48px;
}
```

### Primary Button

The main call-to-action. Use ONE per logical section.

```css
.btn-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: var(--btn-h-md);
  padding: 0 16px;
  font-size: 14px;
  font-weight: var(--btn-font-weight);
  line-height: 1;
  color: #ffffff;
  background: #3b82f6;
  border: none;
  border-radius: var(--btn-radius);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  transition: background var(--btn-transition),
              box-shadow var(--btn-transition),
              transform var(--btn-transition);
}
.btn-primary:hover {
  background: #2563eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}
.btn-primary:active {
  background: #1d4ed8;
  box-shadow: none;
  transform: translateY(1px);
}
.btn-primary:focus-visible {
  outline: none;
  box-shadow: var(--btn-focus-ring);
}
.btn-primary:disabled {
  background: #93c5fd;
  cursor: not-allowed;
  box-shadow: none;
  transform: none;
}
```

### Secondary Button

Supporting action alongside primary. "Cancel," "Back," "Save as Draft."

```css
.btn-secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: var(--btn-h-md);
  padding: 0 16px;
  font-size: 14px;
  font-weight: var(--btn-font-weight);
  line-height: 1;
  color: #374151;
  background: #ffffff;
  border: 1px solid #d1d5db;
  border-radius: var(--btn-radius);
  cursor: pointer;
  transition: background var(--btn-transition),
              border-color var(--btn-transition);
}
.btn-secondary:hover {
  background: #f9fafb;
  border-color: #9ca3af;
}
.btn-secondary:active {
  background: #f3f4f6;
}
.btn-secondary:focus-visible {
  outline: none;
  box-shadow: var(--btn-focus-ring);
}
.btn-secondary:disabled {
  background: #f9fafb;
  color: #d1d5db;
  border-color: #e5e7eb;
  cursor: not-allowed;
}
```

### Tertiary / Ghost Button

Low-emphasis action. "Learn more," "View all," toolbar actions.

```css
.btn-ghost {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: var(--btn-h-md);
  padding: 0 16px;
  font-size: 14px;
  font-weight: var(--btn-font-weight);
  line-height: 1;
  color: #3b82f6;
  background: transparent;
  border: none;
  border-radius: var(--btn-radius);
  cursor: pointer;
  transition: background var(--btn-transition);
}
.btn-ghost:hover {
  background: rgba(59, 130, 246, 0.08);
}
.btn-ghost:active {
  background: rgba(59, 130, 246, 0.12);
}
.btn-ghost:focus-visible {
  outline: none;
  box-shadow: var(--btn-focus-ring);
}
.btn-ghost:disabled {
  color: #93c5fd;
  background: transparent;
  cursor: not-allowed;
}
```

### Destructive Button

**ONLY for irreversible actions:** delete account, remove permanently, revoke access.

```css
.btn-destructive {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: var(--btn-h-md);
  padding: 0 16px;
  font-size: 14px;
  font-weight: var(--btn-font-weight);
  line-height: 1;
  color: #ffffff;
  background: #ef4444;
  border: none;
  border-radius: var(--btn-radius);
  cursor: pointer;
  transition: background var(--btn-transition);
}
.btn-destructive:hover {
  background: #dc2626;
}
.btn-destructive:active {
  background: #b91c1c;
}
.btn-destructive:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px #fff, 0 0 0 4px #ef4444;
}
.btn-destructive:disabled {
  background: #fca5a5;
  cursor: not-allowed;
}
```

### Link-Style Button

Looks like a hyperlink but behaves as a button. For inline actions within text or low-chrome UIs.

```css
.btn-link {
  display: inline;
  padding: 0;
  font-size: inherit;
  font-weight: var(--btn-font-weight);
  color: #3b82f6;
  background: none;
  border: none;
  text-decoration: none;
  cursor: pointer;
  transition: color var(--btn-transition);
}
.btn-link:hover {
  text-decoration: underline;
  color: #2563eb;
}
.btn-link:active {
  color: #1d4ed8;
}
.btn-link:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
  border-radius: 2px;
}
.btn-link:disabled {
  color: #93c5fd;
  text-decoration: none;
  cursor: not-allowed;
}
```

### Button Sizes

```css
.btn--sm {
  height: var(--btn-h-sm);   /* 32px */
  padding: 0 12px;
  font-size: 13px;
}
.btn--md {
  height: var(--btn-h-md);   /* 36px — default */
  padding: 0 16px;
  font-size: 14px;
}
.btn--lg {
  height: var(--btn-h-lg);   /* 40px */
  padding: 0 20px;
  font-size: 15px;
}
.btn--xl {
  height: var(--btn-h-xl);   /* 48px */
  padding: 0 24px;
  font-size: 16px;
}
```

### Icon Buttons

Square buttons with only an icon — equal width and height.

```css
.btn-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: var(--btn-h-md);    /* square: width = height */
  height: var(--btn-h-md);
  padding: 0;
  border-radius: var(--btn-radius);
}
.btn-icon svg {
  width: 18px;
  height: 18px;
}
/* Always provide aria-label for icon-only buttons */
```

### Loading State

```css
.btn--loading {
  position: relative;
  color: transparent;        /* hide text */
  pointer-events: none;      /* prevent clicks */
}
.btn--loading::after {
  content: "";
  position: absolute;
  width: 16px;
  height: 16px;
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: btn-spin 600ms linear infinite;
}
@keyframes btn-spin {
  to { transform: rotate(360deg); }
}
/* Alternative: replace left icon with spinner, keep text visible */
```

### Focus Ring (Keyboard Navigation)

```css
/* Applied via :focus-visible — does NOT show on mouse click */
.btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px #ffffff,          /* white gap */
              0 0 0 4px var(--color-primary-500); /* colored ring */
}
```

### Minimum Touch Target

```css
/* Even if a button is visually 32px tall, ensure 44x44px touch area */
.btn--sm {
  position: relative;
}
.btn--sm::before {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 44px;
  height: 44px;
  /* invisible, but expands touch area */
}
```

### Checklist

- [ ] ONE primary button per section/viewport. Multiple primaries = no hierarchy.
- [ ] Destructive buttons require confirmation (modal or inline "Are you sure?").
- [ ] All buttons have `:focus-visible` styling for keyboard navigation.
- [ ] Disabled buttons have `cursor: not-allowed` and reduced opacity.
- [ ] Loading state disables interaction (`pointer-events: none`).
- [ ] Icon-only buttons have `aria-label` for screen readers.
- [ ] Minimum 44x44px touch target on all buttons (WCAG 2.5.5).
- [ ] Button text uses sentence case ("Save changes"), not all-caps.
- [ ] Never use `<div>` or `<span>` as a button — use `<button>` or `<a>`.

### Sources

- Radix UI Primitives — button patterns and accessibility
- Shadcn/ui — button component variants
- Tailwind UI — button design patterns
- WCAG 2.2 SC 2.5.5 — Target Size (Enhanced)

---
## CS. Shadow & Elevation System

Complete box-shadow scale with CSS values, dark mode handling, and usage guidelines.

### CSS Custom Properties

```css
:root {
  --shadow-none: none;
  --shadow-sm:  0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow:     0 1px 3px rgba(0, 0, 0, 0.1),
                0 1px 2px rgba(0, 0, 0, 0.06);
  --shadow-md:  0 4px 6px rgba(0, 0, 0, 0.07),
                0 2px 4px rgba(0, 0, 0, 0.06);
  --shadow-lg:  0 10px 15px rgba(0, 0, 0, 0.1),
                0 4px 6px rgba(0, 0, 0, 0.05);
  --shadow-xl:  0 20px 25px rgba(0, 0, 0, 0.1),
                0 8px 10px rgba(0, 0, 0, 0.04);
  --shadow-2xl: 0 25px 50px rgba(0, 0, 0, 0.25);

  --shadow-inner: inset 0 2px 4px rgba(0, 0, 0, 0.06);
  --shadow-ring:  0 0 0 3px rgba(59, 130, 246, 0.4);
}
```

### Level 0 — Flat (none)

```css
box-shadow: var(--shadow-none);   /* none */
```

**Use for:** default state of most elements, flat design surfaces, elements distinguished by background color or border rather than elevation. Tables, inline elements, text blocks.

### Level 1 — Raised (sm)

```css
box-shadow: var(--shadow-sm);
/* 0 1px 2px rgba(0, 0, 0, 0.05) */
```

**Use for:** cards at rest, buttons at rest, static containers, subtle separation from background. The lightest perceptible shadow — adds depth without drawing attention.

### Level 2 — Elevated (default)

```css
box-shadow: var(--shadow);
/* 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06) */
```

**Use for:** card hover state, dropdown menus, autocomplete suggestions, small floating elements. A clear but modest lift — signals interactivity or temporary surfaces.

### Level 3 — Floating (md)

```css
box-shadow: var(--shadow-md);
/* 0 4px 6px rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.06) */
```

**Use for:** popovers, tooltips, sticky elements, floating toolbars, context menus. Clearly elevated above the main content plane.

### Level 4 — Overlay (lg)

```css
box-shadow: var(--shadow-lg);
/* 0 10px 15px rgba(0, 0, 0, 0.1), 0 4px 6px rgba(0, 0, 0, 0.05) */
```

**Use for:** modals, drawers, side panels, dialog boxes. High elevation — these surfaces demand attention and sit above a backdrop.

### Level 5 — Supreme (xl)

```css
box-shadow: var(--shadow-xl);
/* 0 20px 25px rgba(0, 0, 0, 0.1), 0 8px 10px rgba(0, 0, 0, 0.04) */
```

**Use for:** toast notifications, floating action buttons, snackbars, elevated bottom sheets. The highest elevation for persistent floating UI elements.

### Level 6 — Dramatic (2xl)

```css
box-shadow: var(--shadow-2xl);
/* 0 25px 50px rgba(0, 0, 0, 0.25) */
```

**Use for:** full-screen overlays, image lightboxes, photo viewers, hero card with dramatic hover effect. Use sparingly — this is a statement shadow.

### Ring Shadow (Focus)

```css
box-shadow: var(--shadow-ring);
/* 0 0 0 3px rgba(59, 130, 246, 0.4) */
```

**Use for:** focus states on interactive elements. Always pair with `outline: none`. Can combine with other shadows:

```css
.card:focus-visible {
  box-shadow: var(--shadow-sm), var(--shadow-ring);
  outline: none;
}
```

### Inset Shadow

```css
box-shadow: var(--shadow-inner);
/* inset 0 2px 4px rgba(0, 0, 0, 0.06) */
```

**Use for:** pressed button states, active toggle backgrounds, input inner glow, well/sunken containers, and elements that should feel recessed rather than elevated.

### Dark Mode Shadows

Shadows on dark backgrounds are nearly invisible since there is no contrast between the shadow and the dark surface. Instead:

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* Reduce shadow opacity by ~50% */
    --shadow-sm:  0 1px 2px rgba(0, 0, 0, 0.3);
    --shadow:     0 1px 3px rgba(0, 0, 0, 0.4),
                  0 1px 2px rgba(0, 0, 0, 0.3);
    --shadow-md:  0 4px 6px rgba(0, 0, 0, 0.35),
                  0 2px 4px rgba(0, 0, 0, 0.3);
    --shadow-lg:  0 10px 15px rgba(0, 0, 0, 0.4),
                  0 4px 6px rgba(0, 0, 0, 0.3);
    --shadow-xl:  0 20px 25px rgba(0, 0, 0, 0.45),
                  0 8px 10px rgba(0, 0, 0, 0.3);
    --shadow-2xl: 0 25px 50px rgba(0, 0, 0, 0.5);
  }

  /* Add subtle luminous border to replace shadow perception */
  .card, .dropdown, .modal {
    border: 1px solid rgba(255, 255, 255, 0.05);
  }
}
```

**Key insight:** In dark mode, elevation is communicated more by surface lightness than by shadows. Higher surfaces = lighter background color.

### Transition

Always animate shadow changes for smooth elevation transitions:

```css
.card {
  box-shadow: var(--shadow-sm);
  transition: box-shadow 150ms ease;
}
.card:hover {
  box-shadow: var(--shadow);
}
```

**Performance note:** `box-shadow` transitions do not trigger layout. They do trigger paint, but the performance cost is negligible in modern browsers. For absolute maximum performance on many simultaneous animating elements, consider using `filter: drop-shadow()` which can be GPU-accelerated.

### Elevation Mapping Table

| Component           | Resting Shadow  | Hover Shadow   | Active Shadow   |
|---------------------|----------------|----------------|-----------------|
| Button              | `--shadow-sm`  | `--shadow`     | `none`          |
| Card                | `--shadow-sm`  | `--shadow`     | `--shadow-sm`   |
| Dropdown / Select   | —              | —              | `--shadow`      |
| Tooltip             | `--shadow-md`  | —              | —               |
| Popover             | `--shadow-md`  | —              | —               |
| Modal               | `--shadow-lg`  | —              | —               |
| Drawer              | `--shadow-lg`  | —              | —               |
| Toast / Snackbar    | `--shadow-xl`  | —              | —               |
| Lightbox            | `--shadow-2xl` | —              | —               |
| Input (focus)       | —              | —              | `--shadow-ring` |

### Checklist

- [ ] Define shadow scale as CSS custom properties for consistency.
- [ ] Use `--shadow-sm` as default card shadow, `--shadow` for hover.
- [ ] Always `transition: box-shadow 150ms ease` on elements that change shadow.
- [ ] In dark mode, rely on surface color hierarchy more than shadows.
- [ ] Add `border: 1px solid rgba(255,255,255,0.05)` to dark mode elevated surfaces.
- [ ] Combine ring shadow with existing shadow on focus: `box-shadow: var(--shadow-sm), var(--shadow-ring)`.
- [ ] Never use more than 2 elevation levels difference on hover (e.g., sm → default, not none → lg).
- [ ] Test shadows on both white and off-white backgrounds — too-subtle shadows disappear on #f5f5f5.

### Sources

- Tailwind CSS shadow scale (`shadow-sm` through `shadow-2xl`)
- Material Design elevation system — 6 levels (0dp through 24dp)
- Josh Comeau, "Designing Beautiful Shadows" — layered shadow technique
- CSS Tricks, "Getting Deep into Shadows" — performance considerations

---
## CT. Card Component Deep Anatomy

Professional card component specification covering structure, every sub-element, interactive states, variants, and skeleton loading.

### Card Structure

```
<article class="card">
  <div class="card__header">         <!-- optional -->
    <img class="card__avatar" />
    <div class="card__header-text">
      <span class="card__title">…</span>
      <span class="card__subtitle">…</span>
    </div>
    <button class="card__menu">⋯</button>
  </div>
  <div class="card__media">          <!-- optional -->
    <img src="…" alt="…" />
  </div>
  <div class="card__body">
    <h3 class="card__body-title">…</h3>
    <p class="card__body-desc">…</p>
    <div class="card__body-meta">…</div>
  </div>
  <div class="card__actions">        <!-- optional -->
    <button class="btn-primary">…</button>
    <button class="btn-ghost">…</button>
  </div>
</article>
```

### Container

```css
.card {
  display: flex;
  flex-direction: column;
  background: #ffffff;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  /* OR use shadow instead of border: */
  /* box-shadow: 0 1px 2px rgba(0,0,0,0.05); */
  overflow: hidden;
  transition: box-shadow 150ms ease,
              border-color 150ms ease,
              transform 150ms ease;
}
```

**Note:** Use border OR shadow for elevation — not both. Border is crisper at small sizes; shadow feels more modern.

### Header

```css
.card__header {
  display: flex;
  align-items: center;
  padding: 16px 16px 0;
  gap: 12px;
}
.card__avatar {
  width: 40px;
  height: 40px;
  border-radius: 9999px;
  object-fit: cover;
  flex-shrink: 0;
}
.card__header-text {
  flex: 1;
  min-width: 0;             /* prevents text overflow from breaking flex */
}
.card__title {
  display: block;
  font-weight: 600;
  font-size: 14px;
  line-height: 20px;
  color: #111827;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.card__subtitle {
  display: block;
  font-size: 13px;
  line-height: 18px;
  color: #6b7280;
}
.card__menu {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;              /* 44px touch target */
  height: 44px;
  margin: -12px -12px -12px auto;  /* visually align, expand touch area */
  background: none;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  color: #6b7280;
  font-size: 20px;
}
.card__menu:hover {
  background: #f3f4f6;
}
```

### Media

```css
.card__media {
  width: 100%;
  overflow: hidden;
}
.card__media img,
.card__media video {
  width: 100%;
  aspect-ratio: 16 / 9;     /* or 4/3, 1/1 — choose one per card type */
  object-fit: cover;
  display: block;            /* removes bottom gap from inline img */
}
```

### Body

```css
.card__body {
  flex: 1;                   /* fills remaining vertical space */
  padding: 16px;
}
.card__body-title {
  font-size: 16px;
  font-weight: 600;
  line-height: 24px;
  color: #111827;
  margin: 0 0 4px;
  /* Clamp to 2 lines */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.card__body-desc {
  font-size: 14px;
  line-height: 20px;
  color: #4b5563;
  margin: 0;
  /* Clamp to 3 lines */
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.card__body-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  font-size: 12px;
  color: #9ca3af;
}
```

### Actions

```css
.card__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px 16px;
  justify-content: flex-end;
  /* Or use space-between for left+right alignment */
}
```

### Clickable Card

When the entire card is a clickable link.

```css
/* Approach 1: Wrap in <a> */
a.card {
  text-decoration: none;
  color: inherit;
}

/* Approach 2: Pseudo-element stretch link */
.card--clickable {
  position: relative;
  cursor: pointer;
}
.card--clickable .card__body-title a {
  text-decoration: none;
  color: inherit;
}
.card--clickable .card__body-title a::after {
  content: "";
  position: absolute;
  inset: 0;                  /* stretches link over entire card */
}
/* Inner links (tags, author) need to sit above the stretched link */
.card--clickable .card__body-meta a,
.card--clickable .card__actions button {
  position: relative;
  z-index: 1;
}
```

**Hover state:**

```css
.card--clickable:hover {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1),
              0 1px 2px rgba(0, 0, 0, 0.06);  /* shadow level 2 */
  border-color: #d1d5db;
}
```

**Pressed/Active state:**

```css
.card--clickable:active {
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);  /* shadow level 1 */
  transform: scale(0.99);
}
```

**Focus state (keyboard navigation):**

```css
.card--clickable:focus-visible,
.card--clickable:has(a:focus-visible) {
  outline: none;
  box-shadow: 0 0 0 2px #ffffff,
              0 0 0 4px #3b82f6;
}
```

### Horizontal Card

Card with media on the left and content on the right, side by side.

```css
.card--horizontal {
  flex-direction: row;
}
.card--horizontal .card__media {
  width: 33%;                /* or 40% — adjust to taste */
  flex-shrink: 0;
}
.card--horizontal .card__media img {
  height: 100%;
  aspect-ratio: auto;        /* fill available height */
}
.card--horizontal .card__body {
  flex: 1;
}

/* Stack on small screens */
@media (max-width: 480px) {
  .card--horizontal {
    flex-direction: column;
  }
  .card--horizontal .card__media {
    width: 100%;
  }
  .card--horizontal .card__media img {
    aspect-ratio: 16 / 9;
  }
}
```

### Skeleton Loading

Placeholder card shown while data is loading.

```css
.card--skeleton .card__avatar,
.card--skeleton .card__media,
.card--skeleton .card__body-title,
.card--skeleton .card__body-desc,
.card--skeleton .card__body-meta {
  background: #f3f4f6;
  border-radius: 4px;
  color: transparent;
  overflow: hidden;
  position: relative;
}

/* Shimmer animation */
.card--skeleton .card__avatar::after,
.card--skeleton .card__media::after,
.card--skeleton .card__body-title::after,
.card--skeleton .card__body-desc::after,
.card--skeleton .card__body-meta::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.4) 50%,
    transparent 100%
  );
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0%   { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

/* Skeleton placeholder sizes */
.card--skeleton .card__body-title {
  height: 20px;
  width: 70%;
  margin-bottom: 8px;
}
.card--skeleton .card__body-desc {
  height: 16px;
  width: 100%;
  margin-bottom: 4px;
}
.card--skeleton .card__body-desc:last-child {
  width: 60%;
}
.card--skeleton .card__body-meta {
  height: 14px;
  width: 40%;
  margin-top: 12px;
}
```

Use `aria-busy="true"` and `aria-label="Loading"` on skeleton cards for screen readers. Replace with real content once loaded.

### Dark Mode Card

```css
@media (prefers-color-scheme: dark) {
  .card {
    background: #1f2937;                     /* neutral-800 */
    border-color: rgba(255, 255, 255, 0.08);
  }
  .card__title,
  .card__body-title {
    color: #f9fafb;                          /* neutral-50 */
  }
  .card__subtitle,
  .card__body-desc {
    color: #9ca3af;                          /* neutral-400 */
  }
  .card__body-meta {
    color: #6b7280;                          /* neutral-500 */
  }
  .card--skeleton .card__avatar::after,
  .card--skeleton .card__media::after,
  .card--skeleton .card__body-title::after,
  .card--skeleton .card__body-desc::after {
    background: linear-gradient(
      90deg,
      transparent 0%,
      rgba(255, 255, 255, 0.08) 50%,
      transparent 100%
    );
  }
}
```

### Checklist

- [ ] Card uses semantic HTML (`<article>`, `<h3>`, `<p>`, `<a>`).
- [ ] Clickable cards have a clear hover state (shadow change or border change).
- [ ] Inner links within clickable cards use `position: relative; z-index: 1` to stay clickable.
- [ ] Images use `object-fit: cover` and a defined `aspect-ratio` to prevent layout shift.
- [ ] Text truncation uses `-webkit-line-clamp` for multi-line clamping.
- [ ] Skeleton loading uses `aria-busy="true"` and shimmer animation.
- [ ] Cards in a grid use `flex: 1` on body so actions align at the bottom.
- [ ] `overflow: hidden` on the container clips media to the card's border-radius.
- [ ] Horizontal cards stack to vertical below 480px.
- [ ] Focus-visible ring is visible for keyboard navigation on clickable cards.
- [ ] Set `min-width: 0` on flex children containing text to prevent overflow.
- [ ] Test card with no image, no header, no actions — each section is optional.

### Sources

- Material Design 3 — Card component specification
- Ant Design — Card component documentation
- Apple Human Interface Guidelines — Content views and cards
- Inclusive Components (Heydon Pickering) — Card accessibility patterns
- Shadcn/ui — Card component implementation

> **Sources:** web.dev — "Web Vitals" (Philip Walton); web-vitals library documentation (GitHub); Chrome UX Report (CrUX) documentation; web.dev — "Best practices for measuring Web Vitals in the field"; Google Search Central — Core Web Vitals & ranking; Philip Walton — "Fixing INP" (web.dev, 2024).

---

## CU. New CSS Features 2025-2026

> Modern CSS capabilities that shipped in major browsers between 2024-2026, replacing JavaScript workarounds and preprocessor dependencies with native platform features.

### CSS @scope

Native CSS scoping limits style reach to a subtree of the DOM without requiring BEM naming, CSS Modules, or Shadow DOM.

**Basic scoping — styles only apply inside `.card`:**

```css
@scope (.card) {
  :scope {
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 1.5rem;
  }

  h2 {
    font-size: 1.2em;
    margin-bottom: 0.5rem;
  }

  p {
    color: var(--text-secondary);
    line-height: 1.6;
  }

  a {
    color: var(--primary);
    text-decoration: underline;
  }
}
```

**Donut scope — style the outer region but exclude inner content:**

```css
/* Styles apply inside .card but NOT inside .card__content */
@scope (.card) to (.card__content) {
  :scope {
    background: var(--surface);
    padding: 1rem;
  }

  /* This targets .card > header, .card > footer, etc. */
  /* but NOT anything inside .card__content */
  span {
    font-size: 0.85rem;
    color: var(--text-muted);
  }
}
```

**Component library isolation — prevent style leakage between widgets:**

```css
/* Third-party widget scoping */
@scope (.widget-datepicker) {
  :scope {
    font-family: system-ui, sans-serif;
    font-size: 14px;
  }

  button {
    /* These button styles won't leak outside .widget-datepicker */
    all: unset;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 4px;
  }

  button:hover {
    background: var(--hover-bg, rgba(0, 0, 0, 0.06));
  }
}

/* Nested scope — sidebar nav vs. main nav */
@scope (.sidebar) {
  nav a {
    display: block;
    padding: 0.5rem 1rem;
  }
}

@scope (.main-content) {
  nav a {
    display: inline-flex;
    padding: 0.25rem 0.75rem;
  }
}
```

**Proximity wins over specificity** — when two `@scope` rules match, the closer ancestor scope takes precedence, which is a more intuitive cascade behavior than specificity counting.

**Browser support (early 2026):** Chrome 118+, Edge 118+, Safari 17.4+, Firefox behind flag (expected stable mid-2026).

**When to use:** Component libraries, CMS content isolation, third-party embed sandboxing, replacing BEM `.block__element--modifier` naming conventions.

### CSS color-mix()

Native color manipulation directly in CSS, replacing Sass `lighten()`, `darken()`, and `rgba()` workarounds.

**Basic usage — lighten and darken:**

```css
:root {
  --primary: #3b82f6;
  --primary-light: color-mix(in srgb, var(--primary), white 20%);
  --primary-dark: color-mix(in srgb, var(--primary), black 20%);
  --primary-subtle: color-mix(in srgb, var(--primary), white 85%);
}
```

**Dynamic hover and active states:**

```css
.btn-primary {
  background: var(--primary);
  color: white;
}

.btn-primary:hover {
  /* Lighten by mixing 15% white */
  background: color-mix(in srgb, var(--primary), white 15%);
}

.btn-primary:active {
  /* Darken by mixing 20% black */
  background: color-mix(in srgb, var(--primary), black 20%);
}
```

**Alpha/transparency manipulation:**

```css
.overlay {
  /* 50% opacity of primary color */
  background: color-mix(in srgb, var(--primary) 50%, transparent);
}

.focus-ring {
  /* 30% opacity ring */
  outline: 3px solid color-mix(in srgb, var(--primary) 30%, transparent);
  outline-offset: 2px;
}

.border-subtle {
  border: 1px solid color-mix(in srgb, currentColor 12%, transparent);
}
```

**oklch vs srgb — perceptual uniformity:**

```css
:root {
  --primary: oklch(0.6 0.2 250);

  /* oklch produces more perceptually uniform lightness steps */
  --primary-100: color-mix(in oklch, var(--primary), white 90%);
  --primary-200: color-mix(in oklch, var(--primary), white 70%);
  --primary-300: color-mix(in oklch, var(--primary), white 50%);
  --primary-400: color-mix(in oklch, var(--primary), white 25%);
  --primary-500: var(--primary);
  --primary-600: color-mix(in oklch, var(--primary), black 20%);
  --primary-700: color-mix(in oklch, var(--primary), black 40%);
  --primary-800: color-mix(in oklch, var(--primary), black 60%);
  --primary-900: color-mix(in oklch, var(--primary), black 80%);
}

/* srgb can produce muddy mid-tones; oklch keeps hue/chroma consistent */
```

**Theming with a single custom property:**

```css
[data-theme="blue"]  { --accent: #3b82f6; }
[data-theme="green"] { --accent: #22c55e; }
[data-theme="red"]   { --accent: #ef4444; }

/* All derived colors update automatically */
.card {
  background: color-mix(in oklch, var(--accent), white 92%);
  border: 1px solid color-mix(in oklch, var(--accent), white 70%);
}

.card:hover {
  border-color: color-mix(in oklch, var(--accent), white 40%);
}
```

**Browser support (early 2026):** Baseline 2023 — Chrome 111+, Firefox 113+, Safari 16.2+, Edge 111+. Safe to use in production.

### CSS text-wrap: balance / pretty

Typography refinement that previously required JavaScript or manual `<br>` insertion.

```css
/* balance: equalizes line lengths — ideal for headings */
h1, h2, h3, h4, h5, h6,
.heading,
blockquote {
  text-wrap: balance;
}

/* pretty: prevents orphans on last line — ideal for paragraphs */
p, li, dd, figcaption {
  text-wrap: pretty;
}

/* stable: prevents reflow during editing — ideal for editable content */
[contenteditable],
.live-preview,
textarea {
  text-wrap: stable;
}
```

**Visual difference:**

```
/* Without text-wrap: balance (default) */
This is a heading that wraps to
two lines unevenly

/* With text-wrap: balance */
This is a heading that
wraps to two lines evenly
```

**Performance considerations:**

- `balance` is computationally expensive above 6 lines — the browser may silently ignore it on long blocks. Use only on short text (headings, captions, pull quotes).
- `pretty` is lightweight and safe on any length — it only adjusts the last line.
- `stable` prevents layout shift during live editing — small performance cost.

**Browser support (early 2026):** Baseline 2024 — Chrome 114+, Firefox 121+, Safari 17.4+, Edge 114+. Safe to use in production (graceful degradation — browsers that do not support it simply use default wrapping).

### CSS field-sizing

Auto-sizing form controls based on their content, replacing JavaScript resize hacks.

```css
/* Textarea grows with content */
textarea {
  field-sizing: content;
  min-height: 3lh;   /* at least 3 lines */
  max-height: 10lh;  /* cap at 10 lines */
  padding: 0.75rem;
  border: 1px solid var(--border);
  border-radius: 8px;
  resize: vertical;  /* still allow manual resize */
}

/* Input widens to fit value */
input[type="text"].auto-width {
  field-sizing: content;
  min-width: 8ch;    /* at least 8 characters wide */
  max-width: 40ch;
  padding: 0.5rem 0.75rem;
}

/* Select adjusts to longest visible option */
select.auto-width {
  field-sizing: content;
  min-width: 10ch;
}
```

**The `lh` unit** — represents the computed line-height of the element, making it natural to set height bounds relative to lines of text:

```css
.comment-box {
  field-sizing: content;
  min-height: 2lh;   /* 2 lines minimum */
  max-height: 15lh;  /* 15 lines maximum, then scroll */
  overflow-y: auto;
}
```

**Before (JavaScript hack this replaces):**

```javascript
// No longer needed with field-sizing: content
textarea.addEventListener('input', () => {
  textarea.style.height = 'auto';
  textarea.style.height = textarea.scrollHeight + 'px';
});
```

**Browser support (early 2026):** Chrome 123+, Edge 123+, Firefox 132+, Safari experimental (behind flag). Use with progressive enhancement — set a fixed height as fallback.

```css
textarea {
  /* Fallback for browsers without field-sizing */
  height: 120px;
  resize: vertical;
}

@supports (field-sizing: content) {
  textarea {
    field-sizing: content;
    height: auto;
    min-height: 3lh;
    max-height: 10lh;
  }
}
```

### Exclusive Accordion (details name="")

Native HTML-only accordion groups — no JavaScript, no ARIA manual wiring.

```html
<!-- Only one <details> open at a time within the same name group -->
<details name="faq">
  <summary>What is your return policy?</summary>
  <p>You can return items within 30 days of purchase.</p>
</details>

<details name="faq">
  <summary>How long does shipping take?</summary>
  <p>Standard shipping takes 3-5 business days.</p>
</details>

<details name="faq" open>
  <summary>Do you offer international shipping?</summary>
  <p>Yes, we ship to over 50 countries worldwide.</p>
</details>
```

**Animated open/close with `::details-content`:**

```css
details {
  border: 1px solid var(--border);
  border-radius: 8px;
  margin-bottom: 0.5rem;
  overflow: hidden;
}

details summary {
  padding: 1rem;
  cursor: pointer;
  font-weight: 600;
  list-style: none;
}

details summary::marker {
  display: none;
}

details summary::after {
  content: '+';
  float: right;
  font-size: 1.25rem;
  transition: transform 200ms ease;
}

details[open] summary::after {
  content: '−';
}

/* Animate the content panel */
details::details-content {
  block-size: 0;
  overflow: hidden;
  transition: block-size 300ms ease, content-visibility 300ms ease allow-discrete;
}

details[open]::details-content {
  block-size: max-content;
}

details > :not(summary) {
  padding: 0 1rem 1rem;
}
```

**Browser support (early 2026):** Chrome 120+, Safari 17.2+, Firefox 130+, Edge 120+. The `name` attribute for exclusive behavior and `::details-content` for animation are both well-supported.

### Dialog Element Improvements

Declarative dialog control without JavaScript event listeners.

**The `closedby` attribute — control how the dialog can be dismissed:**

```html
<!-- Light dismiss: click outside, Escape, or close button all work -->
<dialog id="settings-panel" closedby="any">
  <h2>Settings</h2>
  <form method="dialog">
    <!-- ... -->
    <button>Save & Close</button>
  </form>
</dialog>

<!-- Only Escape key or explicit close button (no click-outside) -->
<dialog id="confirm-delete" closedby="closerequest">
  <h2>Delete this item?</h2>
  <p>This action cannot be undone.</p>
  <button commandfor="confirm-delete" command="close">Cancel</button>
  <button onclick="deleteItem()">Delete</button>
</dialog>

<!-- Only closeable programmatically (forced flow) -->
<dialog id="onboarding-wizard" closedby="none">
  <h2>Welcome! Let's set up your account.</h2>
  <!-- User must complete all steps -->
</dialog>
```

**Declarative open/close with `command` and `commandfor`:**

```html
<!-- Open a modal — no JavaScript needed -->
<button commandfor="my-dialog" command="show-modal">Open Settings</button>

<!-- The dialog with a declarative close button -->
<dialog id="my-dialog" closedby="any">
  <h2>Settings</h2>
  <p>Configure your preferences.</p>

  <!-- Closes parent dialog without JS -->
  <button commandfor="my-dialog" command="close">Done</button>
</dialog>
```

**`requestClose()` — allows prevention of closing:**

```javascript
const dialog = document.getElementById('unsaved-changes');

dialog.addEventListener('cancel', (event) => {
  if (hasUnsavedChanges()) {
    event.preventDefault();
    showConfirmation('Discard unsaved changes?');
  }
});

// requestClose() fires the cancel event first (unlike .close() which is immediate)
document.getElementById('close-btn').addEventListener('click', () => {
  dialog.requestClose();
});
```

**Styling best practices:**

```css
dialog {
  border: none;
  border-radius: 12px;
  padding: 2rem;
  max-width: min(90vw, 480px);
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

dialog::backdrop {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

/* Entry animation */
dialog[open] {
  animation: dialog-in 200ms ease-out;
}

@keyframes dialog-in {
  from {
    opacity: 0;
    transform: translateY(-10px) scale(0.97);
  }
}
```

**Browser support (early 2026):** `closedby` — Chrome 131+, Edge 131+; `command`/`commandfor` — Chrome 131+; Firefox and Safari are implementing both, expected stable mid-2026. The base `<dialog>` element and `::backdrop` are Baseline 2022 and universally supported.

### Checklist

- [ ] Use `@scope` for component-level style isolation instead of BEM or CSS Modules where appropriate.
- [ ] Replace Sass `lighten()`/`darken()` with `color-mix()` — prefer `oklch` color space for perceptual uniformity.
- [ ] Apply `text-wrap: balance` to headings and `text-wrap: pretty` to body text.
- [ ] Use `field-sizing: content` with `min-height`/`max-height` bounds on textareas — wrap in `@supports` for fallback.
- [ ] Use `<details name="group">` for simple exclusive accordions before reaching for a JS component.
- [ ] Use `closedby` and `commandfor` attributes on dialogs to reduce JavaScript for open/close logic.
- [ ] Verify browser support for each feature and provide graceful fallbacks.

### Sources

- Chrome for Developers — "CSS @scope" (2024)
- MDN Web Docs — `color-mix()`, `text-wrap`, `field-sizing`, `::details-content`, `closedby`
- web.dev — "New CSS features in 2024-2025" (Una Kravets, Adam Argyle)
- Can I Use — browser support tables for each feature
- W3C CSS Scoping Module Level 2 specification
- Open UI — Dialog and Invoker commands explainer

---

## CV. Privacy Sandbox & Post-Cookie Web

> The web is transitioning away from third-party cookies. Safari and Firefox already block them by default. Chrome adopted a user-choice model instead of blanket deprecation. This section covers the replacement APIs and practical migration steps.

### Third-Party Cookie Deprecation Timeline

**Current status (early 2026):**

| Browser | Third-party cookie status |
|---------|--------------------------|
| Safari  | Blocked by default since 2020 (ITP — Intelligent Tracking Prevention) |
| Firefox | Blocked by default since 2023 (ETP — Enhanced Tracking Protection, Strict mode) |
| Chrome  | User-choice model: users can opt to block 3P cookies; not blanket-deprecated |
| Edge    | Follows Chromium behavior, tracking prevention levels (Basic/Balanced/Strict) |

**What broke when 3P cookies disappeared:**

- Cross-site analytics (e.g., GA tracking across subdomains without config)
- Ad conversion measurement (click on site A, convert on site B)
- Remarketing audiences (show ads on site B based on site A visit)
- Embedded auth widgets (SSO iframes, social login buttons)
- Embedded comment systems, chat widgets, payment iframes
- Federated login flows relying on cookie-based session sharing

### Topics API (Replaces FLoC)

Interest-based advertising without tracking individual users.

**How it works:**

1. Browser locally observes sites a user visits.
2. Each site is mapped to one of ~470 standardized topics (taxonomy v2).
3. Per epoch (1 week), the browser selects top 5 topics from browsing.
4. When a site calls the API, it receives up to 3 topics (one per recent epoch).
5. 5% of the time, a random topic is returned (differential privacy noise).

**Implementation:**

```javascript
// JavaScript API
const topics = await document.browsingTopics();
// Returns array: [{ topic: 57, taxonomyVersion: '2', modelVersion: '4', ... }]

// Send topics to ad server for targeting
fetch('https://ads.example.com/bid', {
  method: 'POST',
  body: JSON.stringify({ topics }),
});
```

```
// HTTP header approach — topic observation happens automatically
// Response header from ad server:
Observe-Browsing-Topics: ?1

// Request header sent by browser to ad server:
Sec-Browsing-Topics: (57);v=chrome.2:4:10, (123);v=chrome.2:4:10
```

**Privacy guarantees:**

- Topics are coarse-grained (470 categories, not fine-grained interests).
- Only 3 weeks of history, then topics age out.
- Users can view and remove topics in `chrome://settings/adPrivacy`.
- No cross-site identity linking — topics are the same regardless of which site calls the API.
- 5% noise ensures plausible deniability for any single topic.

### Attribution Reporting API

Measures ad conversions without cross-site user tracking.

**Event-level reports (click/view to conversion):**

```html
<!-- On the ad-serving page -->
<a href="https://shop.example.com/product"
   attributionsrc="https://adtech.example.com/register-source">
  Buy Now
</a>
```

```
// Ad tech server registers the source via response header:
Attribution-Reporting-Register-Source: {
  "destination": "https://shop.example.com",
  "source_event_id": "843756",
  "expiry": "604800"
}
```

```javascript
// On the conversion page (shop.example.com/thank-you):
// Register the trigger (conversion event)
fetch('https://adtech.example.com/register-trigger', {
  method: 'POST',
  headers: {
    'Attribution-Reporting-Eligible': 'trigger'
  }
});
```

```
// Ad tech server responds with:
Attribution-Reporting-Register-Trigger: {
  "event_trigger_data": [{
    "trigger_data": "1",
    "priority": "100"
  }]
}
```

**Event-level vs summary reports:**

| Aspect | Event-level | Summary (aggregated) |
|--------|------------|---------------------|
| Data | Limited (3 bits for click, 1 bit for view) | Rich (histograms with noise) |
| Delay | 2 days to 30 days (randomized) | ~1 hour with aggregation service |
| Privacy | Low entropy per report | Differential privacy (noise added) |
| Use case | Basic "did they convert?" | Revenue attribution, demographic breakdowns |

**Summary reports** use an aggregation service (Trusted Execution Environment) that adds calibrated noise before returning results, preventing any single-user extraction.

### Protected Audience API (Formerly FLEDGE)

On-device ad auctions for remarketing/retargeting without server-side tracking.

**Workflow:**

```javascript
// 1. Advertiser adds user to interest group (on advertiser's site)
await navigator.joinAdInterestGroup({
  owner: 'https://dsp.example.com',
  name: 'running-shoes-viewers',
  biddingLogicUrl: 'https://dsp.example.com/bid.js',
  ads: [{
    renderUrl: 'https://dsp.example.com/ads/shoes-ad.html',
    metadata: { campaign: 'spring-sale' }
  }],
  // Interest group expires after 30 days
  lifetimeMs: 30 * 24 * 3600 * 1000,
}, 30 * 24 * 3600 * 1000);
```

```javascript
// 2. Publisher runs on-device auction (on publisher's site)
const auctionConfig = {
  seller: 'https://ssp.example.com',
  decisionLogicUrl: 'https://ssp.example.com/score-ad.js',
  interestGroupBuyers: ['https://dsp.example.com'],
  auctionSignals: { pageContext: 'sports-news' },
};

const adFrame = await navigator.runAdAuction(auctionConfig);
// Returns a Fenced Frame config — ad renders in isolation
document.getElementById('ad-slot').config = adFrame;
```

**Key privacy properties:**

- Interest groups stored locally on user's device, not on servers.
- Bidding and scoring logic runs in isolated worklets (no network during auction).
- Winning ad renders in a Fenced Frame (cannot communicate with embedding page).
- Users can view/clear interest groups at `chrome://settings/adPrivacy`.

### Storage Access API

Allows embedded third-party content to request cookie access with user consent.

```javascript
// Check if storage access is already granted
const hasAccess = await document.hasStorageAccess();

if (!hasAccess) {
  try {
    // Prompts user for permission (must be called from user gesture)
    await document.requestStorageAccess();
    // Now this iframe can read/write its first-party cookies
    console.log('Storage access granted');
  } catch (err) {
    console.log('Storage access denied — use alternative auth flow');
    // Fallback: redirect-based auth, postMessage, etc.
  }
}

// After access is granted, cookies work normally in this iframe
const response = await fetch('https://auth.example.com/session', {
  credentials: 'include',
});
```

**When you need it:**

- Embedded social login widgets (Google, Facebook sign-in buttons in iframes)
- Embedded comment systems (Disqus, embedded discussion widgets)
- Embedded payment flows (PayPal, Stripe checkout in iframes)
- Any third-party iframe that needs its own cookies

**Behavior:**

- Requires a user gesture (click/tap) to call `requestStorageAccess()`.
- Prompt shown once per embedded-site / top-level-site pair.
- Permission persists for 30 days (browser-dependent).
- Safari pioneered this API; now Baseline 2023 in all major browsers.

### Related Website Sets (Formerly First-Party Sets)

Declare that multiple domains belong to the same organization for limited cookie sharing.

**Declaration file (hosted at each domain):**

```json
// https://primary.example.com/.well-known/related-website-set.json
{
  "primary": "https://primary.example.com",
  "associatedSites": [
    "https://shop.example.com",
    "https://blog.example.com",
    "https://support.example.com"
  ],
  "serviceSites": [
    "https://cdn.example-assets.com"
  ]
}
```

**Constraints:**

- Maximum 5 associated sites (plus unlimited service sites and ccTLD variants).
- Must be submitted to the Related Website Sets list (public GitHub repo, reviewed by browser vendors).
- Each domain can only appear in one set.
- Use with `requestStorageAccessFor()` to access cookies across set members:

```javascript
// On primary.example.com, request access to shop.example.com cookies
await document.requestStorageAccessFor('https://shop.example.com');
```

### CHIPS (Cookies Having Independent Partitioned State)

For cookies that need to exist cross-site but should be partitioned (isolated per top-level site).

```
// Server sets a partitioned cookie:
Set-Cookie: __Host-session=abc123;
  Secure;
  Path=/;
  SameSite=None;
  Partitioned;
```

**Use case:** An embedded widget (chat, analytics) needs to remember state per embedding site, but that state should not be shared across different embedding sites. The cookie is keyed to (top-level site, embedded site) pair.

### Practical Migration Checklist

**Testing your site without 3P cookies:**

1. Chrome: Settings > Privacy > Third-party cookies > Block third-party cookies.
2. Or launch Chrome with `--test-third-party-cookie-phaseout` flag.
3. DevTools > Application > Cookies — look for blocked cookies (yellow warning icon).
4. DevTools > Issues tab — shows specific cookie issues with remediation advice.

**Migration steps by use case:**

| Current approach | Replacement | API |
|-----------------|-------------|-----|
| Cross-site tracking cookies | Interest-based targeting | Topics API |
| Conversion pixels (3P cookies) | Privacy-preserving attribution | Attribution Reporting API |
| Remarketing cookies | On-device ad auctions | Protected Audience API |
| Embedded widget cookies | User-granted access | Storage Access API |
| Cross-domain login cookies | Organizational cookie sharing | Related Website Sets |
| Embedded state cookies | Partitioned cookies | CHIPS (`Partitioned` attribute) |

**Server-side changes:**

```
# Add Partitioned to cross-site cookies that need to work
Set-Cookie: widget_session=xyz; SameSite=None; Secure; Partitioned

# Migrate to first-party data collection
# Use server-side tagging (GTM server container) instead of client-side 3P scripts

# Set proper cookie attributes
Set-Cookie: session=abc; SameSite=Lax; Secure; HttpOnly; Path=/
```

**Analytics migration:**

```javascript
// Before: relied on 3P cookies for cross-site tracking
// After: use first-party data + server-side measurement

// First-party cookie for analytics (unaffected by 3P cookie changes)
document.cookie = '_analytics_id=uuid; max-age=63072000; SameSite=Lax; Secure; path=/';

// Server-side event forwarding (replaces client-side 3P pixels)
fetch('/api/analytics/event', {
  method: 'POST',
  body: JSON.stringify({
    event: 'purchase',
    value: 49.99,
    // Server forwards to GA4, Meta CAPI, etc.
  }),
});
```

### Checklist

- [ ] Test site with third-party cookies blocked in Chrome, Safari, and Firefox.
- [ ] Audit all `Set-Cookie` headers — add `Partitioned` to legitimate cross-site cookies.
- [ ] Replace cross-site conversion tracking with Attribution Reporting API or server-side CAPI.
- [ ] Implement Storage Access API for embedded widgets that need their own cookies.
- [ ] Register Related Website Sets if you operate multiple domains sharing auth state.
- [ ] Move analytics to first-party data collection + server-side forwarding.
- [ ] Add `SameSite=Lax` (or `Strict`) to all first-party cookies that do not need cross-site access.
- [ ] Review DevTools Issues tab for cookie-related deprecation warnings.

### Sources

- Chrome Privacy Sandbox documentation (privacysandbox.com)
- W3C Privacy Community Group — Storage Access API specification
- MDN Web Docs — Related Website Sets, CHIPS, Storage Access API
- WebKit blog — "Intelligent Tracking Prevention" (John Wilander)
- Mozilla wiki — Enhanced Tracking Protection documentation
- Google Developers — Attribution Reporting API, Topics API, Protected Audience API

---

## CW. WebNN & Browser AI/ML

> On-device machine learning is becoming a browser-native capability. WebNN provides hardware-accelerated inference, Chrome ships a built-in small language model (Gemini Nano), and specialized AI APIs (Writer, Rewriter, Translator) are emerging. This section covers practical implementation patterns for AI-powered web experiences.

### WebNN API (Web Neural Network)

Hardware-accelerated ML inference in the browser using GPU, NPU, or CPU backends.

**Core architecture — graph-based computation:**

```javascript
// 1. Create ML context targeting specific hardware
const context = await navigator.ml.createContext({ deviceType: 'gpu' });
// deviceType options: 'cpu', 'gpu', 'npu' (Neural Processing Unit)

const builder = new MLGraphBuilder(context);

// 2. Define computation graph (simple example: linear regression y = mx + b)
const x = builder.input('x', { dataType: 'float32', shape: [1, 4] });
const m = builder.constant(
  { dataType: 'float32', shape: [4, 1] },
  new Float32Array([0.5, -0.3, 0.8, 0.1])
);
const b = builder.constant(
  { dataType: 'float32', shape: [1] },
  new Float32Array([0.2])
);

const product = builder.matmul(x, m);
const y = builder.add(product, b);

// 3. Compile the graph (optimized for target hardware)
const graph = await builder.build({ y });

// 4. Run inference
const inputBuffer = new Float32Array([1.0, 2.0, 3.0, 4.0]);
const outputBuffer = new Float32Array(1);

const inputs = { x: inputBuffer };
const outputs = { y: outputBuffer };

await context.compute(graph, inputs, outputs);
console.log('Prediction:', outputs.y[0]);
```

**Image classification example:**

```javascript
async function classifyImage(imageElement) {
  const context = await navigator.ml.createContext({ deviceType: 'gpu' });
  const builder = new MLGraphBuilder(context);

  // Load pre-trained model (e.g., MobileNet)
  // Typically loaded from an ONNX or TFLite model converted for WebNN
  const modelUrl = '/models/mobilenet-v2.onnx';
  const modelBuffer = await (await fetch(modelUrl)).arrayBuffer();

  // Use a helper library to load ONNX into WebNN graph
  // (ONNX Runtime Web with WebNN backend)
  const session = await ort.InferenceSession.create(modelBuffer, {
    executionProviders: ['webnn'],
    webnn: { deviceType: 'gpu' },
  });

  // Preprocess image to tensor
  const canvas = document.createElement('canvas');
  canvas.width = 224;
  canvas.height = 224;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(imageElement, 0, 0, 224, 224);

  const imageData = ctx.getImageData(0, 0, 224, 224);
  const float32Data = new Float32Array(3 * 224 * 224);

  // Normalize pixel values to [0, 1] and convert HWC to CHW
  for (let i = 0; i < 224 * 224; i++) {
    float32Data[i]                 = imageData.data[i * 4]     / 255.0; // R
    float32Data[i + 224 * 224]     = imageData.data[i * 4 + 1] / 255.0; // G
    float32Data[i + 2 * 224 * 224] = imageData.data[i * 4 + 2] / 255.0; // B
  }

  const inputTensor = new ort.Tensor('float32', float32Data, [1, 3, 224, 224]);
  const results = await session.run({ input: inputTensor });

  return results.output.data; // Class probabilities
}
```

**Supported backends (early 2026):**

| Platform | Backend | Hardware |
|----------|---------|----------|
| Windows  | DirectML | GPU (any), NPU (Intel, Qualcomm) |
| macOS    | CoreML   | GPU (Metal), Apple Neural Engine |
| Linux    | XNNPACK  | CPU (optimized SIMD) |
| Android  | NNAPI    | GPU, DSP, NPU |

**Browser support:** Chrome 124+ (Origin Trial graduated), Edge 124+. Firefox and Safari in active development.

**WebNN vs TensorFlow.js:**

| Aspect | WebNN | TensorFlow.js |
|--------|-------|---------------|
| Backend | OS-native (DirectML, CoreML) | WebGL, WebGPU, WASM |
| Performance | Faster for supported ops (hardware-optimized) | Wider op coverage, more models |
| Model format | ONNX (via ONNX Runtime Web) | TF SavedModel, TFLite, TFJS |
| NPU support | Yes (where available) | No |
| Bundle size | Minimal (browser-native API) | 100KB-1MB+ library |

### On-Device LLM (Gemini Nano in Chrome)

Chrome ships a built-in small language model accessible via the Prompt API.

**Basic usage:**

```javascript
// Check availability
const capabilities = await ai.languageModel.capabilities();

if (capabilities.available === 'readily') {
  // Model is downloaded and ready
  const session = await ai.languageModel.create();

  const result = await session.prompt('Summarize in one sentence: ' + articleText);
  console.log(result);

  // Session tracks conversation history
  const followUp = await session.prompt('Make it shorter.');
  console.log(followUp);

  // Clean up when done
  session.destroy();

} else if (capabilities.available === 'after-download') {
  // Model needs to be downloaded (~1.5GB)
  const session = await ai.languageModel.create({
    monitor: (monitor) => {
      monitor.addEventListener('downloadprogress', (e) => {
        console.log(`Download: ${Math.round(e.loaded / e.total * 100)}%`);
      });
    },
  });
} else {
  // 'no' — device doesn't meet requirements (needs 8GB+ RAM)
  console.log('On-device AI not available, falling back to server API');
}
```

**Streaming responses:**

```javascript
const session = await ai.languageModel.create();

const stream = await session.promptStreaming('Write a haiku about the web.');

const outputEl = document.getElementById('ai-output');
outputEl.textContent = '';

for await (const chunk of stream) {
  outputEl.textContent = chunk; // Each chunk is the full response so far
}
```

**System prompt and configuration:**

```javascript
const session = await ai.languageModel.create({
  systemPrompt: `You are a helpful assistant for an e-commerce site.
    You help users find products and answer questions about orders.
    Keep responses concise (under 100 words).
    Never discuss competitors.`,
  temperature: 0.7,    // 0.0 = deterministic, 1.0 = creative
  topK: 40,            // Top-K sampling
});
```

**Token counting:**

```javascript
const session = await ai.languageModel.create();

// Check remaining context window
console.log('Max tokens:', session.maxTokens);
console.log('Tokens used:', session.tokensSoFar);
console.log('Tokens remaining:', session.tokensLeft);

// Count tokens before sending
const tokenCount = await session.countPromptTokens('Your long prompt here...');
if (tokenCount > session.tokensLeft) {
  // Truncate or summarize input before sending
}
```

### Specialized AI APIs (Writer, Rewriter, Translator)

Chrome also exposes purpose-built AI APIs for common tasks.

**Writer API — generate text from instructions:**

```javascript
const writer = await ai.writer.create({
  tone: 'formal',            // 'formal', 'neutral', 'casual'
  format: 'plain-text',      // 'plain-text', 'markdown'
  length: 'medium',          // 'short', 'medium', 'long'
  sharedContext: 'Product reviews for an electronics store.',
});

const review = await writer.write(
  'Write a review for wireless noise-canceling headphones, mentioning comfort and battery life.'
);

// Streaming
const stream = await writer.writeStreaming('Write a product description for...');
for await (const chunk of stream) {
  outputEl.textContent = chunk;
}
```

**Rewriter API — transform existing text:**

```javascript
const rewriter = await ai.rewriter.create({
  tone: 'more-casual',       // 'as-is', 'more-formal', 'more-casual'
  format: 'as-is',
  length: 'shorter',         // 'as-is', 'shorter', 'longer'
  sharedContext: 'Customer support chat messages.',
});

const simplified = await rewriter.rewrite(
  'We regret to inform you that your request cannot be processed at this time due to insufficient documentation.'
);
// -> "Sorry, we can't process your request yet — we need a few more documents."
```

**Translator API — on-device translation:**

```javascript
// Check language pair availability
const capabilities = await ai.translator.capabilities();
const pairStatus = capabilities.languagePairAvailable('en', 'fr');
// 'readily', 'after-download', or 'no'

if (pairStatus !== 'no') {
  const translator = await ai.translator.create({
    sourceLanguage: 'en',
    targetLanguage: 'fr',
  });

  const translated = await translator.translate('Hello, how can I help you today?');
  // -> "Bonjour, comment puis-je vous aider aujourd'hui ?"
}
```

### AI-Powered Web UX Patterns

Design guidelines for integrating AI features into web applications.

**Progressive enhancement — always provide a non-AI fallback:**

```javascript
async function enhanceSearchWithAI(query) {
  // Try on-device AI first
  if ('ai' in globalThis) {
    const caps = await ai.languageModel.capabilities();
    if (caps.available === 'readily') {
      const session = await ai.languageModel.create();
      const enhanced = await session.prompt(
        `Expand this search query with synonyms: "${query}"`
      );
      session.destroy();
      return enhanced;
    }
  }

  // Fallback: server-side AI
  try {
    const res = await fetch('/api/ai/expand-query', {
      method: 'POST',
      body: JSON.stringify({ query }),
    });
    return (await res.json()).expanded;
  } catch {
    // Final fallback: use original query as-is
    return query;
  }
}
```

**Disclosure — label AI-generated content (EU AI Act requirement):**

```html
<div class="ai-response" role="region" aria-label="AI-generated response">
  <p>{{ aiGeneratedText }}</p>
  <footer class="ai-disclosure">
    <svg aria-hidden="true"><!-- sparkle icon --></svg>
    <span>Generated by AI — may contain inaccuracies</span>
  </footer>
</div>
```

```css
.ai-disclosure {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  margin-top: 0.75rem;
  padding: 0.375rem 0.75rem;
  font-size: 0.8125rem;
  color: var(--text-secondary);
  background: var(--surface-secondary);
  border-radius: 6px;
}
```

**Streaming UX — show incremental results:**

```javascript
async function streamAIResponse(prompt, outputElement) {
  outputElement.textContent = '';
  outputElement.setAttribute('aria-busy', 'true');
  outputElement.classList.add('ai-typing');

  try {
    const session = await ai.languageModel.create();
    const stream = await session.promptStreaming(prompt);

    for await (const chunk of stream) {
      outputElement.textContent = chunk;
    }

    session.destroy();
  } catch (err) {
    outputElement.textContent = 'AI features temporarily unavailable. Please try again.';
  } finally {
    outputElement.setAttribute('aria-busy', 'false');
    outputElement.classList.remove('ai-typing');
  }
}
```

```css
.ai-typing::after {
  content: '▊';
  animation: blink 0.7s step-end infinite;
  margin-left: 1px;
}

@keyframes blink {
  50% { opacity: 0; }
}
```

**Opt-in pattern — let users trigger AI features explicitly:**

```html
<div class="compose-toolbar">
  <textarea id="message" placeholder="Type your message..."></textarea>
  <div class="ai-actions">
    <!-- AI features are opt-in, not automatic -->
    <button onclick="improveWriting()" class="btn-secondary btn-sm">
      <svg aria-hidden="true"><!-- wand icon --></svg>
      Improve writing
    </button>
    <button onclick="makeShorter()" class="btn-secondary btn-sm">
      Shorten
    </button>
    <button onclick="translateMessage()" class="btn-secondary btn-sm">
      Translate
    </button>
  </div>
</div>
```

**Caching inference results:**

```javascript
const aiCache = new Map();

async function cachedPrompt(session, prompt) {
  const cacheKey = prompt.trim().toLowerCase();

  if (aiCache.has(cacheKey)) {
    return aiCache.get(cacheKey);
  }

  const result = await session.prompt(prompt);
  aiCache.set(cacheKey, result);

  // Evict oldest entries if cache grows too large
  if (aiCache.size > 100) {
    const firstKey = aiCache.keys().next().value;
    aiCache.delete(firstKey);
  }

  return result;
}
```

### Practical Implementation Pattern

**Full feature-detection and fallback chain:**

```javascript
class AIService {
  #session = null;
  #available = false;

  async init() {
    // Feature detection
    if (!('ai' in globalThis) || !ai.languageModel) {
      console.log('Prompt API not available');
      return false;
    }

    const caps = await ai.languageModel.capabilities();

    if (caps.available === 'readily') {
      this.#available = true;
      return true;
    }

    if (caps.available === 'after-download') {
      // Optionally trigger download with progress UI
      try {
        this.#session = await ai.languageModel.create({
          monitor: (m) => m.addEventListener('downloadprogress', this.#onProgress),
        });
        this.#available = true;
        return true;
      } catch {
        return false;
      }
    }

    return false;
  }

  async prompt(text) {
    if (!this.#available) {
      return this.#serverFallback(text);
    }

    try {
      if (!this.#session) {
        this.#session = await ai.languageModel.create();
      }
      return await this.#session.prompt(text);
    } catch (err) {
      // Model error — fall back to server
      return this.#serverFallback(text);
    }
  }

  async #serverFallback(text) {
    try {
      const res = await fetch('/api/ai/prompt', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt: text }),
      });
      if (!res.ok) throw new Error('Server AI failed');
      return (await res.json()).result;
    } catch {
      return null; // Caller handles null as "AI unavailable"
    }
  }

  #onProgress(e) {
    console.log(`Model download: ${Math.round(e.loaded / e.total * 100)}%`);
  }

  destroy() {
    this.#session?.destroy();
    this.#session = null;
  }
}
```

**Web Worker offloading for heavy inference:**

```javascript
// main.js
const aiWorker = new Worker('/workers/ai-inference.js', { type: 'module' });

aiWorker.postMessage({
  type: 'classify',
  imageData: canvasCtx.getImageData(0, 0, 224, 224),
});

aiWorker.addEventListener('message', (e) => {
  if (e.data.type === 'result') {
    displayClassification(e.data.predictions);
  }
});
```

```javascript
// workers/ai-inference.js
import * as ort from 'onnxruntime-web';

let session = null;

async function loadModel() {
  session = await ort.InferenceSession.create('/models/mobilenet.onnx', {
    executionProviders: ['webnn', 'wasm'], // fallback chain
  });
}

self.addEventListener('message', async (e) => {
  if (!session) await loadModel();

  if (e.data.type === 'classify') {
    const input = preprocessImage(e.data.imageData);
    const results = await session.run({ input });
    self.postMessage({ type: 'result', predictions: Array.from(results.output.data) });
  }
});
```

**Performance expectations (early 2026):**

| Task | On-device latency | Notes |
|------|-------------------|-------|
| Image classification (MobileNet) | 10-50ms (GPU) | Real-time capable |
| Object detection (YOLO) | 30-100ms (GPU) | Viable for camera feed |
| Text generation (Gemini Nano) | 2-10s for ~100 tokens | Depends on device capability |
| Translation (on-device) | 200-800ms per sentence | After model download |
| Text embedding | 5-20ms per passage | Good for local search |

### Checklist

- [ ] Feature-detect AI APIs before using: `if ('ai' in globalThis && ai.languageModel)`.
- [ ] Always provide a non-AI fallback path (server-side API or manual input).
- [ ] Label AI-generated content with a visible disclosure per EU AI Act guidelines.
- [ ] Use streaming for text generation to avoid blocking the UI with long waits.
- [ ] Make AI features opt-in — do not auto-generate content unless the user explicitly enables it.
- [ ] Run heavy inference (WebNN, ONNX) in a Web Worker to keep the main thread responsive.
- [ ] Cache repeated inference results to avoid redundant computation.
- [ ] Handle model download gracefully — show progress and allow cancellation.
- [ ] Set `aria-busy="true"` on output regions during AI processing.
- [ ] Test on low-end devices — provide graceful degradation when hardware is insufficient.
- [ ] Do not ship model weights in your JavaScript bundle — use browser-provided models or lazy-load from CDN.

### Sources

- W3C WebNN specification (webmachinelearning.github.io/webnn)
- Chrome for Developers — "Built-in AI" documentation (Prompt API, Writer, Rewriter, Translator)
- ONNX Runtime Web — WebNN execution provider documentation
- Google AI for Web — Gemini Nano integration guides
- EU AI Act — Article 52: transparency obligations for AI-generated content
- web.dev — "AI on the web" (Thomas Steiner, 2024-2025)