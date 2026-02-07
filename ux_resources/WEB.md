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

**Checklist:**
- [ ] Le vide explique la cause et propose une action primaire
- [ ] Ton adapté (first-use vs no-results vs permission vs offline)
- [ ] Actions permettent vraie récupération (reset filtres, suggestions)
- [ ] Illustration ne vole pas l'attention au CTA
- [ ] Progression vers "moment aha" (checklist courte)

---

### 3. Error States

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Canal selon impact | Inline = erreur locale; Snackbar = statut non bloquant; Modal = bloquant/risque élevé | Modal pour validation de champ; Toast pour erreur précise | [Material Snackbars](https://material.io/components/snackbars) |
| Message d'erreur | "Quoi + pourquoi + comment corriger"; Langage neutre | Messages hostiles; Codes techniques; Pas d'action | [NN/g Hostile Error Messages](https://media.nngroup.com/media/reports/free/Hostile_Error_Messages.pdf) |
| Timing validation | Valider au bon moment (onBlur/after pause); Pas d'erreur avant que l'utilisateur ait fini | Erreur rouge dès 1er caractère; Toutes erreurs à la fin | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |
| Retry + offline | Action "Réessayer"; État offline explicite; Préserver saisie | Perdre données; Retry silencieux; Erreur réseau = erreur métier | [Apple HIG Loading](https://developer.apple.com/design/human-interface-guidelines/loading) |
| Prévention | Guider avant saisie (mask, exemple, contraintes); État attendu visible | Deviner le format; Règles masquées jusqu'à l'échec | [Smashing Magazine Forms](https://www.smashingmagazine.com/2018/08/best-practices-for-mobile-form-design/) |

**Checklist:**
- [ ] Canal d'erreur correspond à l'impact
- [ ] Chaque message indique quoi, pourquoi, comment corriger
- [ ] Validation inline non prématurée
- [ ] Récupération possible (retry, offline state, conservation)
- [ ] Prévention en amont (formats, exemples, contraintes)

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

**Checklist:**
- [ ] Labels persistants, placeholders = exemples
- [ ] Convention required/optional cohérente et explicitée
- [ ] Validation inline non prématurée + disparition quand corrigé
- [ ] Auto-focus et tab order respectent l'intention
- [ ] Formulaires minimisés, pré-remplis, chunkés

---

### 12. Actions & Confirmations

| Pattern | Règle d'or | Anti-pattern | Source |
|---------|------------|--------------|--------|
| Actions destructives | Confirmer avant si irréversible/haut risque; Sinon Undo après | Confirmation pour micro-action; Suppression définitive sans confirm/undo | [Material Snackbars](https://material.io/components/snackbars) |
| Undo | Fenêtre de récupération courte et claire; Action évidente et accessible | Undo caché/trop bref; Undo qui n'annule pas vraiment | [Material Snackbars](https://material.io/components/snackbars) |
| Libellés boutons | Verbes spécifiques ("Supprimer", "Enregistrer"); Bouton primaire = effet final | "OK / Oui / Non" sans contexte; Ordre incohérent | [Smashing Magazine Microcopy](https://www.smashingmagazine.com/2024/09/thinking-like-ux-writer-better-microcopy/) |
| Bulk actions | Afficher count sélectionné; Permettre annuler sélection; Résumer impact | Action masse sans feedback; Pas de "deselect all" | [Laws of UX Von Restorff](https://lawsofux.com/von-restorff-effect/) |
| Disabled submit | Indiquer raison précise (champs manquants); Guider correction | Submit grisé silencieux; Erreur après tentatives répétées | [Baymard Inline Validation](https://baymard.com/blog/inline-form-validation) |

**Checklist:**
- [ ] Confirmation si irréversible/haut risque; sinon Undo
- [ ] Undo visible, fiable, fenêtre claire
- [ ] Boutons libellés avec verbes spécifiques
- [ ] Bulk actions: count + annuler sélection + impact clair
- [ ] Disabled submit explique quoi corriger

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

*Document généré le 2026-02-06*
