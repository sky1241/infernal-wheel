# DESIGN TREE - Mind Map UX/UI

> Arbres de decision UNIQUEMENT - pour le code, voir WEB.md et MOBILE.md

---

## ARBRE PRINCIPAL

```
                         DESIGN
                           |
              +------------+------------+
              |            |            |
           TOKENS       LAYOUT      COMPONENTS
              |            |            |
         Spacing 4px   Responsive    Touch 44px+
         Colors 4.5:1  Navigation    Focus visible
         Typography    Density       States clairs
              |            |            |
              +------+-----+-----+------+
                     |           |
                 FEEDBACK    ACCESSIBILITY
                     |           |
                 < 100ms     WCAG AA
                 skeleton    Keyboard
                 validation  Screen reader
                     |           |
                     +-----+-----+
                           |
                      CONVERSION
                           |
                    Field burden
                    Guest checkout
                    Trust signals
```

---

## PHASE 0: Avant de Coder

```
Qui est l'utilisateur?
         |
    +----+----+
    |         |
  Mobile    Desktop
  First?    First?
    |         |
    v         v
 MOBILE.md  WEB.md
```

---

## PHASE 1: Tokens

```
                DESIGN TOKENS
                     |
     +---------------+---------------+
     |               |               |
  SPACING         COLORS         TYPOGRAPHY
     |               |               |
  Base: 4px     Semantiques      Body: 16px
     |               |               |
 0,4,8,12,16,   Primary,        Label: lh 1.2
 24,32,48       Surface,        Copy: lh 1.5
                Error/Success
```

---

## PHASE 2: Layout

```
            QUEL LAYOUT?
                 |
     +-----------+-----------+
     |                       |
Mobile (<768px)        Desktop (>=1024px)
     |                       |
+----+----+          +-------+-------+
|         |          |               |
Simple  Complex    Dashboard     Marketing
|         |          |               |
Stack   Tab Bar    Sidebar +      Hero +
vertical bottom    Main area     Sections
```

### Navigation

```
       COMBIEN DE DESTINATIONS?
                |
    +-----------+-----------+
    |           |           |
  2-3         4-5          6+
    |           |           |
  Tabs      Tab Bar     Navigation
  ou        (mobile)     Drawer
Segmented   Bottom Nav   ou Sidebar
            (Android)
                |
          Labels TOUJOURS
          (jamais icons seuls)
```

---

## PHASE 3: Composants

### Touch Targets

```
     ELEMENT INTERACTIF?
            |
       +----+----+
       |         |
      Oui       Non
       |
  Quelle plateforme?
       |
+------+------+------+
|      |      |      |
iOS  Android  Web   Universal
|      |      |      |
44pt   48dp   24px*   48px
              |
        *44px recommande
```

### Forms - Labels

```
    TYPE DE CHAMP?
          |
+---------+---------+
|         |         |
Texte   Select    Toggle
|         |         |
v         v         v

Label VISIBLE (jamais placeholder seul)
     |
+----+----+
|         |
Au-dessus  Floating
(simple)   (compact)
```

### Forms - Validation

```
     QUAND VALIDER?
          |
+---------+---------+
|                   |
Pendant saisie    Au blur
(JAMAIS rouge     (standard)
 des 1er char)        |
     |           Erreur si invalide
     v           Succes si valide
Apres 3+ chars        |
ET pause 250ms   Retirer erreur
     |           des correction
Feedback positif
discret si OK
```

---

## PHASE 4: Feedback

### Timing

```
     DUREE DE L'ACTION?
            |
+-----------+-----------+
|           |           |
< 100ms   100ms-2s     > 2s
|           |           |
Aucun     Spinner    Progress
indicateur subtil      bar
|           |           |
Instantane  Ou skeleton Avec %
            si contenu  si possible
```

### Motion

```
         QUEL TYPE D'ANIMATION?
                 |
     +-----------+-----------+
     |           |           |
  Micro       Standard     Large
(feedback)   (transition)  (page)
     |           |           |
100-200ms    250-350ms    450-600ms
     |           |           |
  hover,     navigation,  entree/
  toggle,    modal,       sortie
  ripple     drawer       ecran
```

### Toast vs Alert

```
     TYPE DE MESSAGE?
            |
+-----------+-----------+
|           |           |
Succes      Erreur     Action
|           |           |
Toast      Alert ou   Snackbar
auto 4s    inline     avec Undo
|           |           |
Position:  Focus sur  1 action max
bottom     le champ   "ANNULER"
```

---

## PHASE 5: Conversion

```
     CHECKOUT FLOW
          |
+---------+---------+
|                   |
Guest checkout    Account
PROMINENT!        required?
|                   |
62% sites         Delayed:
le cachent        creer compte
|                 APRES paiement
= abandons
```

### Trust Signals

```
     OU PLACER LA CONFIANCE?
              |
+-------------+-------------+
|             |             |
Paiement    Formulaire   Footer
|             |             |
Encadrer    Microcopy    Logos
visuellement rassurant   Contact
les champs      |        Mentions
|           "Securise"
Badges      "Pas de spam"
proches
```

---

## PHASE 6: Accessibilite

```
WCAG AA MUST-HAVE:
     |
+----+----+----+----+
|    |    |    |    |
Touch Contrast Focus Keyboard
24px+  4.5:1  visible tout
       text   2px+   navigable
       3:1    outline
       UI
```

---

## VALEURS CLES (memo)

| Quoi | Valeur |
|------|--------|
| Touch iOS | 44pt |
| Touch Android | 48dp |
| Touch Web | 24px min, 44px ideal |
| Spacing | 4px base |
| Contraste texte | 4.5:1 |
| Contraste UI | 3:1 |
| Focus | 2px solid + offset 2px |
| Anim micro | 100-200ms |
| Anim standard | 250-350ms |
| Spring subtle | 0.15 |
| Spring visible | 0.30 |

---

*Mind map - pour le code complet voir WEB.md et MOBILE.md*
