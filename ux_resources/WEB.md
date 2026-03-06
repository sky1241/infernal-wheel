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