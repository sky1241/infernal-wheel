# DEEP RESEARCH PROMPT - UX WEARABLE / SMARTWATCH (~170 pages cible)

## CONTEXTE
Je construis une base de connaissances UX/UI EXHAUSTIVE pour applications **smartwatch** (Wear OS + watchOS + Tizen legacy + Fitbit OS + Garmin Connect IQ).
J'ai deja une base solide Web + iOS + Android (MOBILE.md, WEB.md, DESIGN_TREE.md) avec ~200 pages de regles.

Il me manque le volet **wearable** : TOUTES les regles specifiques aux montres connectees.

Mon app cible : **tracking d'addictions** (cigarettes, alcool, sport) sur Samsung Galaxy Watch 7 (Wear OS 5 / One UI Watch 6). Detection automatique par ML (accelerometre + gyroscope) + compteurs manuels + sync Bluetooth vers telephone.

L'app doit etre utilisable en **moins de 1 seconde** : gros boutons, feedback haptique, glances rapides, zero friction. L'utilisateur a la main mouillee, porte des gants, est en plein soleil, ou ne regarde meme pas l'ecran.

## CE QUE JE RECHERCHE
Des **valeurs numeriques concretes** et **patterns specifiques** pour TOUTES les plateformes wearable :
- Touch targets sur ecran rond 1.2-1.5 pouces
- Navigation sans crown/bezel vs avec
- Layout sur ecran circulaire vs carre vs rectangulaire
- Interactions sans regarder (haptique, audio, voice)
- Tiles, Complications, Watch Faces, Notifications
- Battery et performance constraints
- Health/Fitness/Addiction tracking patterns
- Accessibility sur montre (screen reader, voice control, motor disabilities)
- Ambient/Always-On Display
- Sync montre <-> telephone <-> cloud
- Onboarding et first-run sur montre
- Error states et edge cases
- Internationalization sur ecran minuscule
- Sensor UX (comment presenter les donnees capteurs a l'utilisateur)
- Privacy, permissions, data handling

Pour CHAQUE regle :
- Valeurs exactes (dp, px, pt, mm, ms, Hz, mAh, ratios)
- Differences entre Wear OS / watchOS / Fitbit / Garmin
- Samsung One UI Watch vs stock Wear OS quand different
- Exemples d'apps reelles avec screenshots/descriptions
- Sources officielles 2023-2026 (guidelines, etudes, papers)
- Anti-patterns : ce qu'il ne faut JAMAIS faire

---

## PARTIE 1 : FONDAMENTAUX ECRAN ROND (20-25 pages)

### 1.1 Catalogue des Ecrans Montre
- Dimensions ecran par modele : Galaxy Watch 4/5/6/7, Pixel Watch 1/2/3, Apple Watch SE/Series 9/10/Ultra, Fitbit Sense/Versa, Garmin Venu
- Resolution en pixels par modele
- PPI (pixels per inch) par modele
- Forme : rond, carre, rectangulaire, rond avec chin
- Taille physique en mm du cadran
- Epaisseur de bezel (reduit la zone utilisable)
- Ecran plat vs ecran curve aux bords

### 1.2 Touch Targets Smartwatch
- Taille minimale cibles tactiles Wear OS (valeur officielle Google en dp)
- Taille minimale cibles tactiles watchOS (valeur officielle Apple en pt/mm)
- Taille RECOMMANDEE pour interaction rapide sans precision
- Taille pour interaction SANS REGARDER (eyes-free)
- Zone de hit vs taille visuelle (hitbox peut etre plus grande que le bouton visible)
- Espacement minimum entre cibles interactives (eviter les misclicks)
- Impact de la courbure de l'ecran sur les zones tactiles (bords ronds = moins precis = targets plus grands)
- Zones mortes : coins de l'ecran rond, proximite du bezel
- Samsung Galaxy Watch : specificites One UI Watch vs stock Wear OS
- Impact des gants (hiver, sport) sur la precision tactile
- Impact des doigts mouilles (apres sport, pluie, douche) sur le tactile
- Etudes sur le taux d'erreur tap par taille de cible sur montre
- Comparaison avec les touch targets mobile (48dp Android, 44pt iOS) : scaling factor

### 1.3 Layout Ecran Circulaire
- Zone "safe" utilisable : quel pourcentage de l'ecran rond est reellement utilisable ?
- Inscribed square : dimensions du rectangle inscrit dans le cercle
- Inset rectangulaire vs layout radial vs layout free-form
- Placement optimal du contenu principal (centre, haut, repartition)
- Scrollable content : WearableRecyclerView (legacy) vs ScalingLazyColumn (Compose)
- Liste courbee : comment les items suivent la forme de l'ecran
- Chin displays (Moto 360 legacy, certains Wear OS) : impact layout
- Padding/marges recommandees pour ne pas etre coupe par les bords ronds
- Grilles : 1 colonne, 2 colonnes max — quand utiliser quoi ?
- Layout symetrique vs asymetrique
- Content gravity : centrer vs aligner en haut
- Overscroll behavior : bounce, glow, edge fade
- Full-screen content vs content with margins

### 1.4 Typographie Montre
- Taille de police minimum lisible sur montre (valeurs officielles)
- Taille recommandee pour : titres principaux, sous-titres, body text, captions, labels de boutons
- Nombre de caracteres max par ligne sur ecran rond (avant troncature)
- Nombre de lignes max recommande par ecran
- Polices system : Roboto (Wear OS), SF Compact (watchOS), system fonts Garmin/Fitbit
- Poids de police : quand utiliser Light, Regular, Medium, Bold
- Troncature : ellipsis, combien de lignes max avant "..."
- Lisibilite en exterieur (soleil direct) : contraste minimum requis
- Lisibilite en mouvement (poignet qui bouge) : taille minimum empirique
- Espacement des lettres (letter-spacing) recommande sur petit ecran
- Line-height recommendations pour montre
- Material Typography scale pour Wear OS (Display, Title, Body, Label)
- Dynamic Type / taille de police ajustable par l'utilisateur

### 1.5 Couleurs et Contraste
- Background : pourquoi noir OLED est quasi-obligatoire (battery + lisibilite)
- Couleurs d'accent : combien de couleurs differentes max dans une app montre ?
- Contraste minimum texte sur fond noir OLED (WCAG sur montre ?)
- Contraste minimum pour elements interactifs
- Material You / Dynamic Colors sur Wear OS 4+ : comment ca marche ?
- Samsung color theming (palette extraite du cadran)
- watchOS : couleurs system (tint color) vs custom palette
- Indicateurs d'etat universels : rouge = danger/stop, vert = ok/go, orange = warning, bleu = info
- Couleurs pour visibility rapide (glanceable) : quelles palettes fonctionnent en 0.5s ?
- Couleurs pour daltoniens sur montre (8% des hommes)
- High contrast mode sur montre
- Couleurs interdites / a eviter sur OLED (burn-in risk)
- Gradients : oui/non sur montre ?

### 1.6 Densite d'Information (Glanceability)
- Combien d'informations max sur un seul ecran de montre ?
- Hierarchie ideale : 1 info principale + combien de secondaires ?
- "Glanceable" : en combien de secondes l'utilisateur doit comprendre l'ecran ? (etudes)
- Exemples concrets annotes : ecran ideal vs ecran surcharge
- Nombre de boutons max par ecran (valeur recommandee)
- Texte vs icones : ratio ideal sur montre
- Patterns de layout : "hub and spoke", "linear flow", "card stack"
- Information density par type d'app : fitness, notification, utility, communication
- Negative space : combien d'espace vide minimum sur montre ?
- Etudes eye-tracking sur smartwatch (si disponibles)
- Cognitive load : combien de decisions par ecran max ?

### 1.7 Iconographie Montre
- Taille d'icone minimum sur montre (dp/pt)
- Taille recommandee pour icones d'action
- Style : filled vs outlined — lequel est plus lisible sur petit ecran ?
- Icones avec label vs icones seules : quand ?
- Icon sets : Material Symbols (Wear OS), SF Symbols (watchOS)
- Icones custom : guidelines de design (stroke width, padding, grid)
- App icon sur montre : dimensions requises par plateforme
- Icones monochromes vs couleur
- Espacement icone-texte dans un bouton

---

## PARTIE 2 : INTERACTIONS ET NAVIGATION (15-20 pages)

### 2.1 Modes d'Interaction
- **Touch** : tap, long press, double tap — quand utiliser chacun ? Duree long press (ms)
- **Swipe** : horizontal (pages), vertical (scroll), edge swipe (back/dismiss)
- **Bezel rotatif** (Samsung Galaxy Watch 4/5/6/7) : usages, sensibilite, haptic ticks
- **Digital Crown** (Apple Watch) : usages, scroll, zoom, selection
- **Boutons physiques** : home button, back button, side button — conventions par plateforme
- **Gestes avances** : shake to undo, raise to wake, wrist flick, double tap poignet (Apple Watch S9+), cover to mute/silence
- **Voice input** : quand encourager le voice vs tactile ? Fiabilite par contexte
- **Touch-and-hold menus** : equivalent du right-click / 3D Touch sur montre
- Hierarchie des interactions : quelle interaction pour quelle importance d'action ?

### 2.2 Navigation sur Montre
- **Patterns principaux** : hub-and-spoke (watchOS), hierarchique, lineaire, carousel
- Profondeur max recommandee (nombre de niveaux avant que l'utilisateur soit perdu)
- Retour/Back : swipe right (Wear OS), swipe right/edge (watchOS), bouton physique
- Page indicators : dots en haut/bas, position labels, scroll bar laterale
- Vertical scroll vs horizontal pages (swipe left/right) : quand utiliser quoi ?
- App launcher : liste vs grille — etudes de performance
- Navigation entre apps : recent apps, comment revenir vite au cadran
- "Escape hatch" : TOUJOURS pouvoir revenir au watch face en 1 action (home button)
- Quick Settings / Control Center : acces rapide aux toggles systeme
- Handoff : commencer sur la montre, continuer sur le telephone
- Deep linking : ouvrir un ecran specifique depuis notification/complication/tile

### 2.3 Feedback Haptique
- Types de vibrations disponibles Wear OS (VibrationEffect, EFFECT_CLICK, EFFECT_TICK, etc.)
- Types de vibrations Apple Watch (WKHapticType : notification, start, stop, click, etc.)
- Samsung Galaxy Watch : specificites moteur haptique, vibration patterns
- Quand vibrer : confirmation action, erreur, alerte sante, notification, navigation, timer
- Duree et intensite recommandees par type d'interaction (ms)
- Patterns haptiques composites : single tap, double tap, triple tap, long buzz, pattern rhythme
- Feedback haptique pour le bezel rotatif Samsung : tick par cran
- Impact battery de l'haptique (mesures concretes)
- Conventions universelles : quelle vibration = quelle signification ?
- Haptique + audio : combiner les deux feedback
- Haptique pendant workout/sport : assez fort pour sentir en courant ?
- Desactiver l'haptique : option utilisateur, mode silencieux

### 2.4 Input et Saisie sur Montre
- Boutons : combien max par ecran ? Taille minimum recommandee
- Steppers (+/-) : taille, placement, increment par tap vs hold
- Sliders : utilisables sur montre ? Taille minimum, precision
- Confirmation d'actions importantes : swipe to confirm vs tap+confirm dialog vs double tap
- Selection dans une liste : scroll + tap, bezel scroll + tap
- Input numerique : comment entrer un chiffre ? (stepper, predefined choices, voice)
- Input texte : clavier miniature (T9, swipe), dictee vocale, reponses predefinies, emojis
- Quick actions : 1 tap = 1 action complete (pas de confirmation sauf destructif)
- Picker : date picker, time picker, number picker sur montre
- Multi-select : possible sur montre ? Comment ?

### 2.5 Gestes Specifiques Montre
- Swipe to dismiss notification
- Swipe to reveal actions (style iOS Mail)
- Drag to reorder (possible sur montre ?)
- Pinch to zoom (possible mais rare)
- Force touch / firm press (deprecated sur watchOS 7+, jamais sur Wear OS)
- Rotate bezel to scroll (Samsung) : vitesse, acceleration, snap-to-item
- Crown scroll (Apple) : vitesse, resistance, precision
- Wrist gestures : flick pour scroller (accessibilite), raise/lower pour ouvrir/fermer
- Double clench (Apple Watch Ultra) : assignable action

---

## PARTIE 3 : COMPOSANTS ET PATTERNS UI (15-20 pages)

### 3.1 Tiles (Wear OS) / Smart Stack (watchOS)
- **Tiles Wear OS** : dimensions, layout templates, interactions possibles, refresh rate
- **Tiles Material** : composants disponibles (Text, Button, Image, Spacer, Arc, etc.)
- Combien de tiles un utilisateur configure reellement ? (donnees d'usage)
- Tile vs App : arbre de decision — quand creer une tile vs ouvrir l'app ?
- Tile design : fond noir, contenu centre, CTA visible
- Swipe entre tiles : navigation horizontale
- **Smart Stack watchOS** : equivalent des tiles, rotation automatique, widgets
- Tile interactive : boutons dans la tile (Wear OS 4+)
- Refresh strategy : quand mettre a jour la tile ? (timeline vs event-driven)
- Templates officiels Google pour tiles (layouts pre-faits)

### 3.2 Complications (Watch Face)
- Types de complications Wear OS : SHORT_TEXT, LONG_TEXT, RANGED_VALUE, MONOCHROMATIC_IMAGE, SMALL_IMAGE, PHOTO_IMAGE, GOAL_PROGRESS, WEIGHTED_ELEMENTS
- Types de complications watchOS : circular, rectangular, inline, graphic corner, graphic bezel, etc.
- Taille des complications par position sur cadran (coin, centre, bord, sub-dial)
- Refresh rate : combien de fois mettre a jour ? (Wear OS: TimelineEntry, watchOS: CLKComplicationTimelineEntry)
- Tap action : deep link vers ecran specifique vs ouvrir app
- Data providers : comment exposer les donnees de l'app comme complication
- Design : couleur = tint color du cadran, respecter le style du watch face
- Que montrer dans une complication pour une app de tracking ? (compteur, timer, icone + chiffre)
- Battery impact du refresh rate des complications

### 3.3 Notifications Montre
- Notification anatomy complete : app icon, titre, body, big text, actions, inline reply
- Taille max du texte : titre (combien de chars), body (combien de chars/lignes)
- Nombre d'actions max : Wear OS (3), watchOS (variable), limites pratiques
- Inline reply : clavier, voice, reponses predefinies — quand proposer chacun ?
- Notification grouping / stacking (bundled notifications)
- Priorite / interruption : quand vibrer + afficher vs silent vs heads-up
- Rich notifications : images, progress bar, custom layout — possibilites par plateforme
- Timing intelligent : quand envoyer sur montre vs telephone vs les deux ?
- Bridge notifications (du telephone) vs standalone (de l'app montre)
- Notification channels et categories
- Do Not Disturb / Bedtime Mode : comportement attendu
- Actions destructives dans notification : confirmer ou non ?
- Notification pour detection automatique (ML) : quelle formulation ? "Cigarette detectee?" avec Oui/Non

### 3.4 Boutons et Actions
- **Button sizes** : valeurs concretes min/recommandees/larges (dp Wear OS, pt watchOS)
- Bouton primaire : taille, couleur, placement (centre-bas typiquement)
- Bouton secondaire : quand en avoir un ? Placement par rapport au primaire
- Bouton plein ecran (full-width) : quand utiliser ?
- FAB (Floating Action Button) : existe-t-il sur montre ? Alternatives
- Icon buttons : taille minimum, avec ou sans label texte ?
- Chip / Pill buttons : cas d'usage sur montre (filtres, tags, quick replies)
- Toggle / Switch sur montre : taille, comportement
- Button states : normal, pressed (scale down? darken?), disabled (opacite?), loading
- Button with icon + text : layout, espacement
- Danger button (action destructive) : couleur rouge, confirmation requise ?
- Ghost/outline button sur fond noir OLED : visibilite

### 3.5 Listes et Scroll
- **ScalingLazyColumn** (Compose for Wear OS) : scaling + alpha effect sur les items hors centre
- **WearableRecyclerView** (legacy Views) : curved layout manager
- **List** watchOS : SwiftUI List, WKInterfaceTable
- Item height recommandee (dp/pt) — minimum et comfortable
- Combien d'items visibles simultanement sur l'ecran ?
- Indicateur de scroll : barre laterale, position indicator, fade edges
- "Snap to center" (RSB snap) vs free scroll
- Performance : combien d'items max avant lag ?
- Section headers dans liste : sticky ou pas ?
- Empty state dans liste
- Pull to refresh : existe sur montre ? Alternatives
- Swipe actions sur item (delete, archive) : utilisable sur montre ?
- List item anatomy : icone + texte primaire + texte secondaire + indicateur

### 3.6 Dialogues et Confirmations
- Alert dialog sur montre : anatomy, taille, nombre de boutons (2 max ?)
- Confirmation pattern : CRITIQUE car risque de tap accidentel sur petit ecran
- Full-screen dialog vs overlay semi-transparent
- Auto-dismiss apres X secondes (pour les success/info)
- Undo pattern sur montre : toast + undo button vs shake to undo
- Dialog pour permissions runtime
- Dialog long texte : scroll dans dialog
- Placement des boutons dans dialog : vertical stack vs horizontal

### 3.7 Progress Indicators
- Circular progress (arc) : taille, epaisseur du trait, couleur
- Linear progress : quand utiliser sur montre ?
- Indeterminate : spinner circulaire, taille, animation
- Goal progress : ring complet (Samsung Health style)
- Multi-ring progress (activite Apple Watch : Move/Exercise/Stand)
- Texte dans le progress ring (pourcentage, valeur absolue)
- Animations : duree de l'animation de progression
- Colors : vert = objectif atteint, progression de couleur

### 3.8 Cards sur Montre
- Card anatomy : background, padding, contenu, radius
- Card vs list item : quand utiliser quoi ?
- Card full-width vs card with margins
- Card empilees (stack vertical avec scroll)
- Card interactive (tap pour action) vs card informative
- Card avec action buttons integres
- Background color : #1E1E1E (#2E2E2E?) sur fond noir

---

## PARTIE 4 : AMBIENT MODE ET ALWAYS-ON DISPLAY (5-10 pages)

### 4.1 Always-On Display (AOD)
- Regles Wear OS pour ambient mode : max 5% pixels allumes, pas d'animation, refresh 1/min
- Regles watchOS : complications se mettent a jour, animations arretees, dimmed
- Couleurs autorisees en ambient : blanc, gris, couleurs desaturees
- Layout en ambient vs interactif : que garder, que masquer ?
- Anti burn-in : decaler le contenu de quelques pixels periodiquement
- Flat ambient (sans couleurs) vs low-bit ambient (1-bit par canal)
- Battery impact AOD active vs desactive
- User expectation : l'app doit-elle avoir un ambient mode ?
- Transition interactif → ambient : animation ? Timing ?

### 4.2 Raise to Wake
- Delai raise-to-wake typique (ms)
- Ce que l'utilisateur voit en premier : watch face ou derniere app ?
- Resume previous app : pendant combien de temps apres le dernier usage ?
- Tilt to wake vs button to wake : preferences utilisateur

### 4.3 Watch Face Design
- Regles de design watch face (si on veut integrer nos compteurs dans le cadran)
- Watch face vs Complication : quand integrer dans le cadran vs complication separee
- Animations watch face : permises en interactif, interdites en ambient
- Watch face data sources : complications API
- Personnalisation utilisateur : couleurs, layout, complications selectionnees
- Samsung Watch Face Studio vs Wear OS Watch Face Format

---

## PARTIE 5 : HEALTH, FITNESS & ADDICTION TRACKING PATTERNS (15-20 pages)

### 5.1 Compteurs et Tracking Quotidien
- Counter display : quelle taille pour le chiffre principal ? (la plus grosse info)
- Bouton increment (+1) : taille ENORME pour eyes-free, placement, feedback haptique + visuel
- Bouton decrement (-1) : necessaire ? Si oui, plus petit et/ou protege (long press)
- Confirmation de +1 : immediate (optimistic) vs dialog ? Etudes sur les erreurs de tap
- Daily reset : comment gerer le changement de jour ? (4h du matin vs minuit)
- Historique : comment afficher des tendances sur ecran minuscule ? Bar chart mini ? Derniers 7 jours ?
- Progress ring / arc vers objectif quotidien (ex: max 10 clopes)
- Streak display sur montre : "5 jours sans alcool" — format compact
- Record personnel : "Record: 14j" — comment afficher avec le compteur
- Compteur anime : le chiffre qui change avec une micro-animation (scale, color flash)
- Son/haptique sur +1 : feedback satisfaisant vs feedback neutre

### 5.2 Timers et Chronomètres
- Timer "depuis derniere consommation" : format "2h 34min" vs "2:34" vs "il y a 2h"
- Timer grand format : placement centre, taille dominante
- Timer qui tourne en background : notification ongoing, complication, tile
- Timer et ambient mode : comment afficher un timer qui tourne en AOD ?
- Milestones de timer : notification a 1h, 2h, 4h, 8h, 12h, 24h, 48h ?
- Format adaptatif : "34 min" → "2h 34m" → "1j 2h" → "5 jours"
- Couleur du timer : neutre vs vert progressif (plus c'est long, plus c'est vert)
- Stopwatch patterns : start/stop/lap/reset — placement boutons

### 5.3 Workout / Activity Tracking
- Ecran pendant activite : quelles metriques afficher ? (max 3-4 metriques)
- Layout multi-metriques : grille 2x2, liste, pages swipeable
- Start/Pause/Stop : placement et taille boutons, protection contre tap accidentel
- Auto-pause detection : quand et comment ?
- GPS tracking : indicateur visible (icone), impact battery affiche ?
- Heart rate display : BPM gros + mini graph, zone HR couleur
- Zone HR : couleurs universelles (gris repos, bleu echauffement, vert cardio, orange seuil, rouge max)
- Lap/split : pattern d'interaction (bouton lateral ? tap ecran ?)
- Lock screen pendant workout (eviter les taps accidentels en courant)
- Water lock mode : desactiver le tactile pendant natation
- Ecran lisible en mouvement : taille police minimum empirique

### 5.4 Health Metrics Display
- Heart rate : affichage temps reel, format BPM + mini sparkline, update frequency
- Steps : compteur + objectif + progress ring (Samsung Health style)
- Sleep : resume (duree, score, phases), graphique simplifie, derniere nuit vs historique
- Calories : actives vs totales, affichage et objectif
- SpO2 : affichage pourcentage + indicateur normal/anormal
- Stress level : score + couleur + conseil rapide
- Body composition (Samsung) : comment resumer sur montre ?
- Trends : mini bar chart derniers 7 jours, "voir sur telephone" pour details
- Alerts sante : HR trop haute/basse, irregularite rythme, inactivite prolongee
- Comparaison avec la moyenne / objectif : fleche haut/bas, couleur

### 5.5 Addiction Tracking Specifique
- **Apps existantes analysees** : SmokeFree, QuitNow!, I Am Sober, Nomo, Smoke Free (Sean Allen), EasyQuit, Quit Tracker, HabitBull — POUR CHAQUE : ce qui marche bien et ce qui est nul sur montre
- Compteur cigarettes/jour : affichage optimal (gros chiffre centre, couleur selon gravite)
- Compteur alcool : unites standard, verres, format
- Timer "depuis derniere" : le plus important sur montre ? Toujours visible ?
- Quick log : 1 TAP pour enregistrer "+1 clope" — c'est la killer feature montre
- Bouton "j'ai resiste a une envie" : gamification, feedback rewarding (confetti haptique ?)
- Notification rappel : frequence, timing, formulation non-culpabilisante
- Tile ideale addiction tracking : que montrer ? (timer + compteur jour + quick add button)
- Complication ideale : quel type ? Que montrer ? (timer ou compteur ou les deux)
- Objectif progressif : "hier 12, objectif aujourd'hui 11" — affichage
- Celebration milestone : 1 jour, 3 jours, 1 semaine, 1 mois — feedback montre
- Craving log avec intensite (1-5) : possible sur montre en 2 taps ?
- Integration Samsung Health : publier les donnees dans Samsung Health ?
- Argent economise : affichage sur montre ("12.50 CHF economises")

### 5.6 Gamification sur Montre
- Badges/achievements : notification + animation quand debloque
- Streak fire/flames : icone + compteur jours
- Level up : feedback haptique + visuel
- Daily challenge : affichable sur montre ?
- Social : comparaison avec amis, classement — sur montre ou uniquement telephone ?
- Confetti / celebration animation : duree, frequence, pas trop (fatigue)
- Sound effects : bip de recompense, acceptable sur montre ?

---

## PARTIE 6 : PERFORMANCE, BATTERY ET CONSTRAINTS TECHNIQUES (10-15 pages)

### 6.1 Specs Hardware par Montre
- RAM : Galaxy Watch 7 (2GB), Pixel Watch 3 (2GB), Apple Watch S10 (1GB) — valeurs exactes
- CPU : Exynos W1000 (Samsung), Snapdragon W5+ (Pixel), S9 SiP (Apple) — performance relative
- Storage : capacite, espace disponible pour apps
- Battery capacity : mAh par modele
- Ecran : AMOLED, refresh rate, luminosite max (nits)
- Capteurs disponibles : accelerometre, gyroscope, HR, SpO2, temperature, barometre, GPS, NFC
- Connectivite : Bluetooth version, WiFi, LTE (si modele cellulaire)

### 6.2 Budget Battery par Feature
- Ecran allume en continu : drain/heure
- GPS actif : drain/heure
- HR monitoring continu (1Hz vs 10Hz vs realtime) : drain/heure
- Accelerometre 50Hz continu : drain/heure
- Gyroscope 50Hz continu : drain/heure
- Bluetooth connected : drain/heure
- WiFi actif : drain/heure
- Foreground service running : drain/heure
- Vibration motor : drain par vibration
- TOTAL budget acceptable pour une app qui tourne en background toute la journee

### 6.3 Optimisation App
- Foreground service : quand obligatoire, comment minimiser l'impact battery
- Sampling rate capteurs : quel compromis precision vs battery ? (5Hz vs 25Hz vs 50Hz vs 100Hz)
- Adaptive sampling : haute frequence quand mouvement detecte, basse quand idle
- Wake locks : quand utiliser, duree max recommandee
- Background processing : limites Wear OS (Doze mode, App Standby)
- WorkManager sur Wear OS : periodic work, constraints
- Data sync : batch (toutes les X minutes) vs real-time, WiFi vs Bluetooth
- Image loading : taille max, cache, format (WebP ?)
- Animation performance : fps cible, complexite max
- APK size : impact sur install over Bluetooth (lent!), taille max recommandee
- ProGuard/R8 : reduire la taille de l'app
- Cold start time : objectif en ms, optimisations (lazy init, splash screen)

### 6.4 Loading et Performance UX
- Temps de lancement acceptable (cold start) : combien de ms max ?
- Temps d'interaction premiere : combien de ms entre launch et premier tap possible ?
- Skeleton screens sur montre : oui ou non ? Quelle alternative ?
- Indicateur de chargement montre : spinner circulaire, taille, placement
- Offline first : toujours avoir des donnees locales, jamais d'ecran "loading"
- Startup : auto-load last state vs fresh start — quelle approche ?
- Background task terminee : notification vs mise a jour silencieuse
- ANR (Application Not Responding) timeout sur Wear OS : combien de secondes ?

### 6.5 Memory Management
- Memory limits par app sur Wear OS
- LowMemoryKiller : priorite des apps montre
- Quand le systeme tue l'app en background
- Strategies pour survivre en background (foreground service, alarms)
- Cache strategy : combien de donnees garder en memoire ?

---

## PARTIE 7 : SYNC MONTRE <-> TELEPHONE (10-15 pages)

### 7.1 Architecture de Communication Wear OS
- **Wear Data Layer API** : DataClient (sync data), MessageClient (one-shot messages), ChannelClient (streaming)
- **DataClient** : DataItem, DataMap, max size, sync automatique
- **MessageClient** : fire-and-forget, max size, pas de garantie de delivery
- **ChannelClient** : pour gros transferts (fichiers, streaming)
- **CapabilityClient** : decouvrir quels devices ont quelle app installee
- Bluetooth vs WiFi vs Cloud : quand chaque canal est utilise automatiquement
- Latence typique par canal de communication
- Fiabilite : que faire si le message est perdu ?

### 7.2 Architecture de Communication watchOS
- **Watch Connectivity** : WCSession, transferUserInfo, updateApplicationContext, sendMessage
- **transferUserInfo** : queued, reliable delivery — pour les events importants
- **updateApplicationContext** : last-value-wins — pour l'etat courant
- **sendMessage** : real-time, requires reachability — pour le live
- **transferFile** : gros fichiers
- Complication data transfer : CLKComplicationServer
- Background refresh : WKApplicationRefreshBackgroundTask

### 7.3 Patterns de Sync
- **Real-time sync** : quand c'est necessaire ? (live HR pendant workout partagé)
- **Event-driven sync** : envoyer chaque event quand il arrive (+1 clope → message immediat)
- **Batch sync** : regrouper les events et syncer periodiquement (toutes les 5/15/30 min)
- **Store and forward** : enregistrer localement, envoyer quand connexion disponible
- **State sync** : envoyer l'etat complet periodiquement (compteur total, pas chaque event)
- Offline resilience : TOUJOURS fonctionner sans telephone a proximite
- Sync indicators : faut-il montrer "synced" / "pending" a l'utilisateur ?
- Conflict resolution : si montre et telephone modifient les memes donnees
- First install sync : transferer l'historique existant du telephone vers la montre

### 7.4 Data Format et Protocol
- Taille max des messages Data Layer (100KB DataItem, 256KB MessageClient)
- Format optimal : JSON (simple) vs Protocol Buffers (compact) vs key-value pairs (minimal)
- Schema versioning : gerer les mises a jour app montre vs telephone (versions differentes)
- Timestamps : TOUJOURS UTC, conversion locale au display
- Timezone handling : montre et telephone dans des timezones differentes ?
- Compression : utile pour batch sync ? (gzip, etc.)
- Encryption : donnees sante = sensibles, chiffrement necessaire ?

### 7.5 Companion App (Telephone)
- Companion app obligatoire ou optionnelle ?
- Installer l'app montre depuis le telephone : Google Play / App Store flow
- Settings sync : configurer sur le telephone, appliquer sur la montre
- Data visualization detaillee sur le telephone (graphiques, historique long)
- Export de donnees depuis le telephone
- Notification management : telephone controle quelles notifications vont sur la montre

---

## PARTIE 8 : ACCESSIBILITY SUR MONTRE (5-10 pages)

### 8.1 Screen Reader (TalkBack / VoiceOver)
- TalkBack sur Wear OS : comment ca marche ? Gestes specifiques (explore by touch)
- VoiceOver sur watchOS : navigation avec Digital Crown
- Content descriptions pour chaque element interactif
- Focus order : logique et previsible
- Announce changes : quand notifier le screen reader d'un changement d'etat
- Skip decorative elements
- Grouping elements : quand grouper pour une meilleure experience screen reader

### 8.2 Motor Accessibility
- Cibles tactiles agrandies : taille pour utilisateurs avec tremblements
- Voice control : naviguer et interagir par la voix
- Switch control : utiliser la montre avec un accessoire externe
- AssistiveTouch (Apple Watch) : naviguer avec des gestes de la main (clench, pinch, double pinch)
- Reduce Motion : impact sur les animations de l'app
- Touch accommodations : hold duration, ignore repeat
- One-handed use : TOUJOURS (c'est une montre, l'autre main est occupee)

### 8.3 Visual Accessibility
- Tailles de police dynamiques : supporter Dynamic Type (watchOS) / font scaling (Wear OS)
- Bold Text option : respecter le setting systeme
- Reduce Transparency : impact sur les overlays
- High Contrast : supporter le mode contraste eleve
- Daltonisme : ne jamais encoder l'information UNIQUEMENT par la couleur
- Minimum contrast ratios : memes que WCAG ou plus stricts sur montre ?

### 8.4 Cognitive Accessibility
- Langage simple : phrases courtes, mots simples
- Icones + texte (jamais icones seules pour les actions importantes)
- Consistent navigation : toujours le meme pattern dans toute l'app
- Error recovery : facile de revenir en arriere, undo disponible
- Reduced complexity : mode simplifie pour utilisateurs ages ?

---

## PARTIE 9 : ONBOARDING, PERMISSIONS ET FIRST-RUN (5-10 pages)

### 9.1 Onboarding sur Montre
- Onboarding COURT : combien d'ecrans max ?
- Skip toujours possible
- Montrer la valeur immediatement : pas de tutorial, direct dans l'app
- Progressive disclosure : apprendre en utilisant
- Onboarding sur le telephone vs sur la montre : ou faire quoi ?
- Permission pre-priming : expliquer POURQUOI avant le dialog systeme
- First launch : que voir ? Etat vide avec CTA clair

### 9.2 Permissions Runtime
- Permissions montre vs permissions telephone : lesquelles demander ou ?
- BODY_SENSORS : timing, formulation
- ACTIVITY_RECOGNITION : timing, formulation
- ACCESS_FINE_LOCATION : timing, formulation, impact battery disclaimer
- Notification permission (Android 13+) : sur montre aussi ?
- Si refuse : degraded mode, re-demander quand ? Jamais harasser
- Settings deep-link : diriger vers les settings si refuse
- Permissions groupees vs une par une

### 9.3 Error States et Edge Cases
- Pas de telephone connecte : que montrer ? Que fonctionne toujours ?
- Bluetooth desactive : message, CTA pour activer
- WiFi desactive : impact ? Message ?
- Batterie faible montre : reduire les features ? Notification ?
- Pas de capteur HR (montre sans) : graceful degradation
- GPS unavailable indoor : fallback, message
- App crash recovery : reprendre l'etat precedent automatiquement
- Donnees corrompues : comment gerer ?
- Storage full : message, cleanup suggestions
- App update required : montre vs telephone version mismatch

---

## PARTIE 10 : INTERNATIONALISATION ET LOCALISATION (3-5 pages)

### 10.1 Texte sur Petit Ecran
- Langues verbose (allemand, finnois) : troncature strategies
- RTL (arabe, hebreu) : layout mirroring sur montre
- Nombre de traductions testees avant release
- Pluralization : gerer "1 cigarette" vs "5 cigarettes" sur montre
- Date/time formats : 24h vs 12h, formats courts, relatifs ("il y a 2h")
- Units : km vs miles, kg vs lbs — detection automatique via locale

### 10.2 Contenu Adaptatif
- Texte qui s'adapte a la taille d'ecran (Galaxy Watch 4 40mm vs 44mm)
- Abbreviations automatiques : "minutes" → "min" → "m"
- Icones universelles vs texte localize : quand privilegier les icones

---

## PARTIE 11 : DISTRIBUTION ET TESTING (3-5 pages)

### 11.1 Distribution
- Google Play pour Wear OS : standalone vs companion-required
- App Store pour watchOS : toujours via l'app iPhone ?
- Galaxy Store : specificites Samsung
- Sideloading via ADB : pour dev et beta testing
- APK size limits et impact sur l'install via Bluetooth

### 11.2 Testing Montre
- Emulateur Wear OS : limitations vs device reel
- Test sur device : ADB WiFi, debugger, profiler
- Test ambient mode : comment trigger ?
- Test battery drain : outils de mesure
- Test haptique : uniquement sur device reel
- UI testing : Espresso for Wear OS, XCTest for watchOS
- Monkey testing : stress test sur montre
- Field testing : porter la montre une journee complete, noter les problemes
- A/B testing : possible sur montre ? Comment ?

---

## PARTIE 12 : DESIGN SYSTEM ET FRAMEWORKS (5-10 pages)

### 12.1 Compose for Wear OS (Jetpack)
- Composants disponibles : Button, Chip, Card, ScalingLazyColumn, PositionIndicator, TimeText, etc.
- Horologist library (Google) : composants supplementaires non-inclus dans la base
- Material 3 for Wear OS : etat actuel, differences avec Material 3 mobile
- Theme : MaterialTheme for Wear, colors, typography, shapes
- Preview dans Android Studio : @WearPreview
- Navigation : SwipeDismissableNavHost

### 12.2 SwiftUI pour watchOS
- Composants natifs : NavigationStack, List, TabView, Gauge, ProgressView
- Digital Crown integration : digitalCrownRotation modifier
- Complications avec SwiftUI : CLKComplicationTemplate
- Widget extensions pour watchOS
- Navigation : NavigationSplitView, NavigationLink

### 12.3 Design Tokens Wearable
- Spacing scale pour montre (plus petite que mobile)
- Border radius : recommandations pour ecran rond
- Elevation : shadows sur OLED noir ? (non → utiliser les couleurs de surface)
- Icon sizes : scale specifique montre
- Component sizes : tous les composants en dp/pt

---

## PARTIE 13 : APP LIFECYCLE ET STATE MANAGEMENT (5-10 pages)

### 13.1 Cycle de Vie App sur Montre
- **Cold start** : premiere ouverture, temps acceptable, splash screen oui/non ?
- **Warm start** : app en background, resume rapide — combien de temps le systeme garde l'app en memoire ?
- **Kill & restart** : le systeme tue l'app (manque de RAM) — comment restaurer l'etat ?
- Saved instance state sur Wear OS : que sauvegarder ?
- Difference lifecycle Wear OS vs watchOS (background execution limits)
- Foreground service : seul moyen de garantir que l'app ne se fait pas tuer ?
- onStop / onDestroy : sauvegarder les donnees critiques (compteur, timer)

### 13.2 Resume et Continuité
- L'utilisateur revient apres 2h : que voir ? Dernier ecran ou ecran d'accueil ?
- Timer qui tourne : toujours visible meme apres kill (recalculer au resume)
- Compteur du jour : persiste entre sessions, stockage permanent
- Transition ecran → ambient → ecran : smooth, pas de flash blanc
- "Raise to wake" revient sur l'app ou sur le watch face ? (setting system, timeout configurable)
- **RecentApps timeout** : combien de temps l'app reste dans les recents ?

### 13.3 Wrist Detection et On-Body State
- Wrist detection : montre detecte quand elle est au poignet vs posee
- Impact sur le tracking : arreter les capteurs si la montre est retiree ?
- Lock screen apres retrait : impact UX, PIN requis
- Capteurs indisponibles quand pas au poignet (HR impossible, accelerometre = bruit de table)
- Notification "montre retiree" : utile pour le tracking (gap dans les donnees)
- Resume tracking automatiquement quand remise au poignet

### 13.4 Notification comme Interface Principale
- Pour certains use cases, la notification EST l'app (detection auto → notification → confirmer/ignorer)
- Actions dans notification sans ouvrir l'app : "+1", "Faux positif", "Ignorer"
- Notification ongoing (foreground service) : mini-dashboard permanent
- Heads-up notification : quand interrompre l'utilisateur vs notification silencieuse
- Pattern "notification-first app" : l'utilisateur n'ouvre presque jamais l'app, tout passe par les notifications
- Quick reply dans notification : reponses predefinies pour log rapide

---

## PARTIE 14 : CURVED UI ET SYSTEM OVERLAY (3-5 pages)

### 14.1 Curved Text et Arc Layouts
- **CurvedText** (Wear OS) : texte qui suit la courbure de l'ecran rond
- **ArcLine** : lignes/progress bars courbees au bord de l'ecran
- Quand utiliser du curved text vs texte droit : status, labels peripheriques, progress
- Readability du curved text : taille minimum, combien de caracteres max
- watchOS equivalent : pas de curved text natif en SwiftUI (sauf complications)

### 14.2 TimeText et System UI
- **TimeText** (Wear OS) : heure affichee en haut de l'ecran, TOUJOURS presente
- Comment gerer le TimeText : le cacher ? Le customiser ? L'integrer dans le design ?
- Leading/trailing text dans TimeText : ajouter du contenu a cote de l'heure
- **PositionIndicator** : barre de scroll laterale, style, couleur
- System gestures : swipe from top (quick settings), swipe from bottom (deprecated?), back swipe
- App content vs system UI : z-index, chevauchement, safe zones

### 14.3 Edge-to-Edge et Insets
- Insets system sur Wear OS : status bar, navigation, chin
- Full-screen immersive mode : quand cacher le system UI
- Round screen insets : WindowInsets pour ecran rond
- Chin insets : pour les rares montres avec chin
- Comment tester les insets sur differentes formes d'ecran

---

## PARTIE 15 : HEALTH PLATFORM INTEGRATION (3-5 pages)

### 15.1 Health Connect (Android / Wear OS)
- Ecrire des donnees dans Health Connect : quels types (ExerciseSession, NutritionRecord, custom?)
- Lire des donnees depuis Health Connect : sleep, HR, steps pour enrichir l'app
- Permissions Health Connect : granulaires, revocables, comment gerer
- Est-ce que "cigarettes fumees" existe comme type dans Health Connect ? Si non, quel type custom ?
- Sync automatique : l'app ecrit dans Health Connect, Samsung Health le lit automatiquement ?
- Background read/write : possible ou seulement quand l'app est ouverte ?

### 15.2 Samsung Health SDK
- Samsung Health SDK vs Health Connect : differences, lequel utiliser ?
- Samsung Privileged Health SDK : acces restreint, comment obtenir l'acces ?
- Publier des donnees custom dans Samsung Health : possible ?
- Lire le sleep data de Samsung Health pour enrichir le tracking (premiere clope apres reveil)
- Integration Samsung Health tiles : apparaitre dans le dashboard Samsung Health ?

### 15.3 Interoperabilite
- Ecrire une fois, lire partout : Health Connect comme hub central
- Google Fit legacy : encore utilise ? Migration vers Health Connect ?
- Export standardise : CSV, JSON, FHIR (standard medical) ?
- Partager avec un professionnel de sante : format, securite, consentement

---

## PARTIE 16 : AUDIO ET SON SUR MONTRE (3-5 pages)

### 16.1 Capabilities Audio
- Speaker sur montre : quels modeles ont un speaker ? (Galaxy Watch oui, certains non)
- Volume max acceptable en public vs en prive
- Qualite audio speaker montre : limites (frequences, distorsion)
- Microphone : qualite pour voice input, bruit ambiant
- Bluetooth audio : connecter des ecouteurs a la montre (sans telephone)

### 16.2 Quand Utiliser le Son
- Son vs haptique vs visuel : arbre de decision pour chaque type de feedback
- Son pour alarmes/timers : obligatoire meme en mode silencieux ?
- Son pour notifications : presque toujours off sur montre (haptique suffit)
- Son pour confirmation d'action : quand c'est utile (workout start/stop)
- Son pour accessibilite : audio cues pour utilisateurs malvoyants
- Volume adaptatif : baisser automatiquement selon le contexte (reunion detectee ?)

### 16.3 Mode Silencieux / DND / Theatre Mode
- Mode silencieux : haptique seulement, pas de son
- Do Not Disturb : pas d'interruption, notifications silencieuses
- Theatre mode / Cinema mode : ecran off + son off + haptique off
- Bedtime mode : ecran dimmed, notifications filtrees
- Impact sur l'app : comment reagir dans chaque mode ?
- Comment l'app detecte le mode actif ?

---

## PARTIE 17 : CONTEXTES D'UTILISATION SPECIFIQUES (5-10 pages)

### 17.1 Contextes Physiques
- **En mouvement** (marche, course) : ecran difficile a lire, vibrations du poignet, 1 main libre
- **Sous la pluie / doigts mouilles** : tactile moins precis, water lock mode
- **Avec des gants** : tactile ne marche pas → boutons physiques, voice, bezel
- **En plein soleil** : contraste requis, luminosite max, couleurs qui restent lisibles
- **Dans le noir** (nuit, cinema) : luminosite minimum, mode sombre, AOD dimmed
- **En nageant** : water lock, pas de tactile, boutons physiques uniquement
- **En conduisant** : ZERO interaction complexe, voice ou 1 tap max, legal implications
- **Au lit / reveil** : ecran face au visage, luminosite basse, alarme haptique

### 17.2 Contextes Sociaux
- **En reunion** : discretion, pas de son, ecran off, consultation rapide
- **En conversation** : regarder la montre = impoli → interactions < 2 secondes
- **En public** : privacy (ecran petit = naturellement prive), notifications sensibles
- **Au restaurant / bar** : contexte de consommation alcool → moment critique pour le tracking

### 17.3 Adaptation Contextuelle Automatique
- Detecter l'activite (Google Activity Recognition) : adapter l'UI
- Detecter l'heure : mode nuit automatique
- Detecter la localisation : features contextuelles (GPS cluster = lieu de fumage)
- Detecter la position du poignet : ecran visible ou pas (raise to wake logic)
- Detecter la charge : nightstand mode quand sur le chargeur
- DND schedule : respecter les plages horaires de l'utilisateur

---

## PARTIE 18 : DATA VISUALIZATION SUR PETIT ECRAN (5-10 pages)

### 18.1 Types de Graphiques sur Montre
- **Sparkline** : micro line chart sans axes, tendance seulement — quand utiliser ?
- **Bar chart mini** : 7 barres (derniers 7 jours), sans labels, couleur = valeur
- **Progress ring / arc** : le chart #1 sur montre (objectif vs actuel)
- **Multi-ring** : Apple Activity style (3 rings), max combien de rings ?
- **Pie chart** : NON sur montre ? Ou cas acceptable ?
- **Heatmap calendar** : contribution graph style GitHub — possible sur montre ?
- **Gauge** : demi-cercle, pour valeurs avec range (HR zones, stress)

### 18.2 Regles de Data Viz Montre
- Pas d'axes visibles (pas de place)
- Pas de legendes separees (integrer dans le chart)
- Couleur = information (vert = bon, rouge = mauvais)
- Max combien de data points visibles ?
- Labels : valeur actuelle + min/max OU valeur actuelle seulement
- Animation de chart : entry animation, update animation
- Tap sur chart : zoom / detail ou "voir sur telephone" ?

### 18.3 Comparaison Aujourd'hui vs Historique
- "Aujourd'hui vs hier" : fleche haut/bas + pourcentage
- "Aujourd'hui vs moyenne 7j" : par rapport a la norme
- "Aujourd'hui vs objectif" : progress ring ou barre
- Trend indicator : fleche, couleur, sparkline
- Format compact : "+3 vs hier" ou "↑ 25%"

---

## PARTIE 19 : SECURITE, PRIVACY ET DONNEES DE SANTE (5-10 pages)

### 19.1 Authentification sur Montre
- PIN sur montre : quand demander ? (unlock, paiement, donnees sensibles)
- Pattern lock : existe sur Wear OS ?
- Wrist detection : unlock automatique quand la montre est au poignet
- Biometrique : pas de Face ID / fingerprint sur montre → PIN only
- Auto-lock : apres retrait du poignet, apres timeout
- Samsung Knox : securite enterprise, impact sur les apps

### 19.2 Donnees de Sante - Reglementation
- HIPAA (US) : regles pour apps health sur montre
- GDPR (EU) : donnees de sante = categorie speciale, consentement explicite
- Health Connect (Android) : permissions granulaires, audit log
- HealthKit (iOS) : permissions, encryption at rest
- Donnees de tracking addiction : sensibilite particuliere (stigma, assurance, employeur)
- Data minimization : ne collecter QUE ce qui est necessaire
- Retention policy : combien de temps garder les donnees ? Droit a l'effacement

### 19.3 Encryption et Stockage
- Encryption at rest sur montre : SQLCipher ? Android Keystore ?
- Encryption in transit : TLS pour sync, Bluetooth encryption
- Ou stocker les donnees sensibles : SharedPreferences (non!) vs EncryptedSharedPreferences vs Room + encryption
- Backup : les donnees montre sont-elles incluses dans le backup Android ?
- Export de donnees : format, chiffrement, partage securise

### 19.4 Privacy UX
- Onboarding privacy : expliquer clairement quelles donnees sont collectees
- Dashboard privacy : "vos donnees" accessible depuis settings
- Delete my data : bouton clair, confirmation, irreversible
- Anonymization : si sync vers cloud, anonymiser
- No cloud option : tout garder 100% local = argument de vente

---

## PARTIE 20 : ML ET INFERENCE ON-DEVICE (3-5 pages)

### 20.1 Contraintes ML sur Montre
- Taille de modele max recommandee (KB/MB) pour ne pas impacter storage et RAM
- TensorFlow Lite sur Wear OS : support, performance, delegates (NNAPI, GPU)
- Core ML sur watchOS : support, limites
- Inference time budget : combien de ms max pour ne pas bloquer l'UI ?
- Inference en background vs sur le main thread
- Batch inference vs single inference
- Frequency d'inference : toutes les X secondes — trouver le sweet spot

### 20.2 UX de la Detection Automatique
- Notification "cigarette detectee" : formulation, timing, actions (Confirmer / Faux positif)
- Faux positifs : impact sur la confiance utilisateur, comment les gerer
- Faux negatifs : l'utilisateur ne sait pas que la detection a rate → bouton manuel en backup
- Confidence score : montrer a l'utilisateur ? (probablement non, trop technique)
- Learning from corrections : "ce n'etait pas une cigarette" → ameliorer le modele ?
- Feedback loop : utilisateur corrige → donnees envoyees pour retraining ?
- Privacy du ML : inference 100% on-device, aucune donnee sensor envoyee au cloud

### 20.3 Sensor Fusion UX
- Combiner accelerometre + gyroscope + HR + GPS : comment presenter les resultats ?
- Confidence indicators : "detection sure" vs "detection possible"
- Multi-modal confirmation : accelerometre dit cigarette + GPS dit lieu connu = haute confiance
- Battery trade-off : quels capteurs activer en continu vs on-demand ?

---

## PARTIE 21 : CHARGING UX ET BATTERY STATES (3-5 pages)

### 21.1 Comportement sur le Chargeur
- Nightstand mode : montre sur le chargeur = reveil/horloge de table
- App behavior quand en charge : continuer le tracking ? Pause ?
- Ecran always-on pendant la charge : oui (pas de battery concern)
- Alarm sur chargeur : sonnerie + ecran, pas de vibration (pas au poignet)

### 21.2 Battery States UX
- Battery level display : dans l'app ou seulement system ?
- Low battery warning : a quel pourcentage ? (15%? 10%? 5%?)
- Low battery mode : quelles features couper en premier ?
- Ultra low battery : desactiver le monitoring ML, garder le compteur manuel
- Battery drain notification : "L'app utilise X% de batterie" — comment eviter
- Charging reminder : si la montre n'est pas chargee et battery < X%
- Estimated battery life avec l'app active vs sans

### 21.3 Planning de Charge Utilisateur
- Quand charger si on porte la montre la nuit (sleep tracking) ?
- Charge rapide : combien de temps pour 0-100% par modele ?
- Charge partielle : "30 min de charge = X heures d'utilisation"
- Impact sur le tracking : gap dans les donnees pendant la charge

---

## PARTIE 22 : SAMSUNG GALAXY WATCH SPECIFICITES (5-10 pages)

### 22.1 One UI Watch vs Stock Wear OS
- Differences UI : boutons, listes, navigation, animations
- Samsung Health SDK : acces aux donnees Samsung Health (pas Health Connect)
- Samsung Privileged Health SDK : BioActive sensor, body composition, blood pressure (acces restreint)
- Samsung Internet sur montre : ouvrir des liens
- Samsung Pay : NFC, interaction
- Galaxy Wearable app (companion) : settings, watch faces, tiles management

### 22.2 Hardware Specifique Samsung
- BioActive sensor (Galaxy Watch 4+) : HR, ECG, BIA (body composition), SpO2, temperature (GW5+)
- Sampling rates disponibles par capteur Samsung
- Bezel physique (GW4 Classic) vs bezel tactile (GW5/6/7) : differences d'interaction
- Bouton Home + bouton Back : conventions
- Speaker + microphone : qualite, usage
- GPS : precision, temps de fix, battery impact mesure

### 22.3 Samsung Software Specifique
- One UI Watch 5/6 : nouvelles features, design changes
- Samsung Health integration : comment publier des donnees dans Samsung Health
- Bixby sur montre : voice commands, quality
- Samsung Galaxy Store vs Google Play Store : double distribution ?
- Samsung Knox : impact sur les permissions et le sideloading
- Good Lock / Watch plugins : personnalisation avancee

---

## PARTIE 23 : STANDALONE VS COMPANION - ARCHITECTURE DECISIONS (3-5 pages)

### 23.1 Standalone Watch App
- Quand l'app montre doit fonctionner SANS telephone a proximite
- Donnees locales : tout stocker sur la montre
- Sync opportuniste : envoyer quand le telephone est disponible
- LTE watch : acces internet direct sans telephone
- WiFi direct : sync quand sur le meme reseau
- Limitations standalone : pas de cloud, pas de notifications riches, pas de settings complexes

### 23.2 Companion-Required
- Quand exiger le telephone : configuration complexe, visualisation detaillee, export
- Install flow : installer depuis le Play Store telephone → auto-install sur montre
- Version mismatch : telephone v2.0, montre v1.5 — comment gerer ?
- Companion app minimaliste : juste un receiver de data + dashboard
- Companion app riche : settings, historique, graphiques, export, social features

### 23.3 Hybrid (Recommande)
- Montre : autonome pour le tracking (compteurs, timers, detection)
- Telephone : configuration + visualisation detaillee + export
- Sync bidirectionnelle : settings du telephone → montre, data de la montre → telephone
- Graceful degradation : tout fonctionne sans telephone, le telephone ajoute de la valeur

---

## FORMAT DE REPONSE SOUHAITE

Pour CHAQUE pattern/regle :

```markdown
### [Nom du Pattern]

| Platform | Value | Source |
|----------|-------|--------|
| Wear OS (stock) | [value] | [source + lien si possible] |
| Wear OS (Samsung One UI) | [value si different] | [source] |
| watchOS | [value] | [source + lien si possible] |
| Fitbit OS | [value si applicable] | [source] |
| Garmin CIQ | [value si applicable] | [source] |

**Apps qui font ca bien:** [App1 — pourquoi], [App2 — pourquoi]
**Apps qui font ca MAL:** [App1 — pourquoi c'est nul]

**Quand utiliser:**
- Cas 1
- Cas 2

**Quand eviter:**
- Cas 1

**Anti-patterns (NE JAMAIS FAIRE) :**
- Truc 1
- Truc 2

**Checklist actionnable :**
- [ ] Point 1 avec valeur concrete
- [ ] Point 2 avec valeur concrete

**Code/Implementation (si applicable) :**
```kotlin // Wear OS
// code
```
```swift // watchOS
// code
```
```

---

## SOURCES PRIORITAIRES (chercher dans cet ordre)
1. **Google Wear OS Design Guidelines** (developer.android.com/wear) — 2024-2026
2. **Samsung One UI Watch Design Guide** (developer.samsung.com) — 2024-2026
3. **Apple watchOS Human Interface Guidelines** (developer.apple.com/design) — 2024-2026
4. **Material Design 3 for Wear OS** — composants et specs
5. **Horologist library** (Google) — composants supplementaires
6. **Compose for Wear OS documentation** — API reference
7. **Fitbit Design Guidelines** — si disponible
8. **Garmin Connect IQ UX Guidelines** — developers.garmin.com
9. **Nielsen Norman Group** — etudes smartwatch UX (2020-2026)
10. **Baymard Institute** — si applicable wearable
11. **Academic papers** : ACM CHI, MobileHCI, IMWUT — wearable UX, health tracking, micro-interactions, glanceability
12. **Real apps analysees** : Samsung Health, Google Fit, Apple Fitness+, Strava, Nike Run Club, Fitbit app, Garmin Connect, SmokeFree, QuitNow!, I Am Sober, Nomo, EasyQuit, Quit Tracker, HabitBull, Smoke Free (Sean Allen), Calm, Headspace, Sleep Cycle, AutoSleep, Carrot Weather, Google Keep (Wear), Google Maps (Wear), Spotify (Wear), Todoist (Wear), Citymapper (Wear), Komoot (Wear)
13. **Design systems publics** : Samsung Health, Fitbit, Garmin, Material Design for Wear OS
14. **YouTube / Medium / blog posts** de designers Wear OS et watchOS (2023-2026)
15. **Samsung Developer Conference** talks — One UI Watch, Health SDK
16. **Google I/O** talks — Wear OS, Compose for Wear OS, Tiles API, Health Services
17. **WWDC** talks — watchOS, WidgetKit, HealthKit, SwiftUI for watchOS
18. **Reddit / XDA** — r/WearOS, r/GalaxyWatch, r/AppleWatch — real user feedback et pain points

---

## OBJECTIF FINAL
Document de **~170 pages** avec valeurs CONCRETES couvrant Wear OS + watchOS + Fitbit + Garmin.

**REGLES :**
- Pas de generalites vagues — CHAQUE regle doit avoir une valeur numerique ou un pattern concret
- Si une valeur differe entre plateformes, TOUTES les variantes doivent etre listees
- CHAQUE pattern doit avoir au moins 1 exemple d'app reelle qui le fait bien + 1 anti-pattern
- Les sources doivent etre verifiables (liens si possible, sinon nom du document + date)
- Si une info n'est pas documentee officiellement, le dire clairement et donner la valeur empirique/community consensus

**PRIORITE :**
1. Health/fitness/addiction tracking (compteurs, timers, quick log) — c'est mon use case #1
2. Touch targets et layout (c'est ce qui fait qu'une app montre est utilisable ou pas)
3. Haptique et feedback (c'est le differentiel cle vs le telephone)
4. Performance et battery (c'est la contrainte #1 technique)
5. Samsung Galaxy Watch specificites (c'est ma montre)
6. Sync montre-telephone (c'est le flux de donnees)
7. ML on-device et detection automatique (c'est mon feature differenciante)
8. Data visualization sur petit ecran (c'est comment montrer les stats)
9. Contextes d'utilisation (c'est la realite du terrain)
10. Securite et privacy des donnees de sante
11. Tout le reste

**BONUS SI POSSIBLE :**
- Etudes chiffrees : taux d'erreur tap par taille de cible, duree moyenne de session sur montre, retention apps montre vs mobile
- Benchmarks industrie : combien d'apps Wear OS un utilisateur installe en moyenne, sessions/jour, duree session
- Comparatifs : Wear OS vs watchOS — quelle plateforme a les meilleurs patterns UX et pourquoi
- Predictions 2026-2027 : ou va le wearable UX ? (AI on-wrist, gestures, brain-computer interface ?)
