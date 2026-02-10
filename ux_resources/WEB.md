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
