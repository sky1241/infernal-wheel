# Bible UX — App Icon Design 2024–2026
# Spécifications, science des couleurs, principes, cas d'usage et workflow
# Sources: Android Developers, Apple Documentation, W3C, AppTweak, SplitMetrics, StoreMaven, NNGroup
# Date de référence: 31 mars 2026

---

## A — SPÉCIFICATIONS PLATEFORME

### A1 — Android Adaptive Icons (Material Design, 26 fév. 2026)
- Canvas par couche: **108 × 108 dp** (foreground + background + monochrome optionnel)
- Zone logo minimum: **≥ 48 × 48 dp**
- Zone logo maximum: **≤ 66 × 66 dp** (safe zone garantie lisible sous tout masque OEM)
- Réserve masquage/parallax: **18 dp par côté**
- Aire interne résultante: 108 − 2×18 = **72 dp**
- Safe zone "ultra-sûre": **66 dp** (cercle centré)
- Pas de masques ni ombres dans vos layers (l'OS les applique)
- Masques OEM: cercle, squircle, rounded square — votre icône doit survivre à tous
- Source: https://developer.android.com/develop/ui/views/launch/icon_design_adaptive

### A2 — Conversion dp → px (export Android)
| Densité | Layer 108dp | Logo max 66dp | Réserve 18dp |
|---------|------------|---------------|-------------|
| mdpi | 108 px | 66 px | 18 px |
| hdpi | 162 px | 99 px | 27 px |
| xhdpi | 216 px | 132 px | 36 px |
| xxhdpi | 324 px | 198 px | 54 px |
| xxxhdpi | 432 px | 264 px | 72 px |

### A3 — Apple — Tailles par device
- **iPhone**: 60×60 pt → 120×120 (@2x) / 180×180 (@3x)
- **iPad**: 76×76 pt → 152×152 (@2x) ; iPad Pro: 83.5×83.5 → 167×167 (@2x)
- **Spotlight**: 40×40 pt → 80×80 (@2x)
- **Settings**: 29×29 pt → 58×58 (@2x) / 87×87 (@3x)
- **Apple Watch**: Notif 24×24/27.5×27.5, Long Look 44×44, Launcher 40×40, Quick Look 86×86/98×98
- **Mac**: 16, 32, 128, 256, 512 pt (+@2x) + App Store 1024×1024
- **Règle opacité**: PNG obligatoire, pas de régions transparentes (erreur ITMS-90647)
- **Coins**: squircle/superellipse, ne pas arrondir manuellement — la plateforme applique son masque
- Utiliser les templates Apple Design Resources
- Sources: Apple QA1686, Asset Catalog Format

### A4 — Android 13+ Themed/Monochrome Icons
- L'utilisateur active les icônes thématisées → le système applique un **tint wallpaper/thème** à la couche `<monochrome>`
- XML: `<adaptive-icon>` avec `<monochrome android:drawable="…">` en plus de foreground/background
- Contraintes monochrome: valeurs d'alpha/luminosité, pas de dégradés colorés, mêmes safe zones 66dp
- **NOUVEAU Android 16 QPR2 (2026)**: Android thème automatiquement les icônes **même sans couche monochrome fournie**
- → Renforce l'importance de silhouettes simples + bon contraste de luminance

### A5 — Android 12+ Splash Screen
- API SplashScreen dédiée
- Icône via `windowSplashScreenAnimatedIcon`
- Animation pilotée en millisecondes
- Vérifier doc Android pour sizing exact (ajusté régulièrement)

### A6 — Icône Play Store 512×512 vs Launcher
| Aspect | Play Store | Launcher |
|--------|-----------|----------|
| Taille | 512×512 px | 108×108 dp/couche |
| Format | PNG 32-bit sRGB ≤1024KB | Adaptive icon multi-layer |
| Forme | Carré plein (masquage dynamique ~30% rayon) | Masqué par OEM |
| Ombre | Aucune (Play gère) | Aucune (OS gère) |
| Nature | Asset **marketing** | Asset **UI système** |
- Peuvent être distinctes si nécessaire, tant que la reconnaissance de marque reste élevée
- **Rejets typiques**: taille/format non conformes, fichier >1024KB, ombres/biseaux ajoutés, éléments critiques trop proches des bords
- Source: https://developer.android.com/distribute/google-play/resources/icon-design-specifications

### A7 — Samsung Galaxy Store / Huawei AppGallery
- **Samsung**: 512×512 px PNG ≤1024KB (aligné sur Play Store)
- **Huawei AppGallery**: 216×216 ou 512×512 px, PNG (≤2MB) ou WEBP (≤100KB)
- Huawei ancienne guideline: 192×192 px minimum (héritage, variabilité selon pays/produit)
- **Recommandation**: prévoir pipeline export 256/512, vérifier dans AppGallery Connect la contrainte courante

---

## B — COULEUR, PERCEPTION ET ACCESSIBILITÉ

### B1 — Psychologie des couleurs par catégorie (data AppTweak, top apps US)
| Catégorie | Couleur dominante | Détails |
|-----------|------------------|---------|
| **Finance** | Bleu (~40%) | Vert = 2ème; style "logo simple sur fond uni" |
| **Social** | Bleu/violet majoritaire | ~30-36% dégradé; ~12-16% logo noir |
| **Travel** | Bleu (~40-45%) | ~25-35% fond blanc; ~26-28% élément voyage (avion/globe) |
| **Shopping** | Chaudes rouge/orange (~36-38%) | Style "fond uni + logo flat" |
| **Food & Drink** | Rouge (~46-54%) | Souvent couleur principale |
| **Health/Wellness** | Vert/bleu | Top apps: Headspace (orange), Calm (bleu), Noom (vert) |
- **Prudence**: la psychologie des couleurs est souvent sur-vendue (NNGroup). Le choix dépend du contexte + tests
- Le bleu est cité comme couleur de confiance (enquête 1000 consommateurs US, mars 2025)
- Source: https://www.apptweak.com/en/aso-blog/infographic-mobile-games-app-icon-trends-2

### B2 — Impact couleur/icône sur conversion (A/B publiés)
| Étude | Résultat |
|-------|---------|
| SplitMetrics (cas Ciliz) | 20.46% → 24.42% = **+19.4% relatif** |
| SplitMetrics (Nanobit) | **+18% conversion** + **+22% installs organiques** en 40 jours |
| SplitMetrics (benchmarks 2024) | Icônes optimisées = jusqu'à **+25% acquisition** |
| SplitMetrics (fond clair/simple) | **>+26% conversion** across categories |
| Apple PPO | Tests jusqu'à 90 jours, ≥90% de confiance |
- **Point clé**: l'icône est un **levier de conversion mesurable**, pas une décoration
- Elle mérite un cycle d'expérimentation comparable aux screenshots
- Sources: SplitMetrics cases, Apple PPO documentation

### B3 — Contrastes — Seuils WCAG applicables aux icônes
- **Non-texte essentiel** (SC 1.4.11): contraste ≥ **3:1** contre couleurs adjacentes
- **Texte dans icône** (SC 1.4.3): contraste ≥ **4.5:1**
- À **48px**: viser ≥3:1 minimum pour silhouette principale
- À **96px / 192px**: même seuil 3:1, plus de détails acceptables si silhouette dominante
- Sources: W3C WCAG 2.1/2.2

### B4 — Daltonisme (CVD)
- Prévalence rouge-vert: **~8% hommes**, **~0.5% femmes** (populations européennes)
- **Ne jamais** coder la différence principale uniquement via rouge/vert (protan/deutan)
- Préférer: contrastes de **luminance** (clair/foncé) + formes + contours + espaces négatifs
- Utiliser des simulateurs CVD pour validation
- Sources: NCBI, Colour Blind Awareness

### B5 — Dark mode, wallpapers et auto-tinting
- Android themed icons: tint basé sur wallpaper/thème appliqué à la couche monochrome
- **Android 16 QPR2**: auto-theme même sans couche monochrome → contrôle du rendu moins déterministe
- → Renforce l'importance de **silhouettes simples + contrastes**
- Apple (2026): Icon Composer pour icônes multi-layer "Liquid Glass" avec prévisualisation modes d'apparence

---

## C — PRINCIPES DE COMPOSITION ET TESTS

### C1 — Grilles d'icône (Google keylines + Apple grids)
- **Google Material keyline shapes** (product icons):
  - Carré: 152×152 dp
  - Cercle: Ø 176 dp
  - Rectangle vertical: 176×128 dp
  - Rectangle horizontal: 128×176 dp
- Product icons fournis à **48 dp**, scaling à **192×192 dp** (400%)
- **Apple**: templates via Apple Design Resources (App Icon Template iOS & iPadOS 26)
- Source: https://m1.material.io/style/icons.html

### C2 — Golden ratio / Règle des tiers
- **Règle des tiers**: point focal dans une zone de saillance, sans compromettre la symétrie optique
- **Golden ratio**: outil de proportion (rapport de masses), doit être validé par **tests de lisibilité** (48px, 1-2m de distance, fond varié)
- Traiter comme **heuristiques à tester**, pas comme des lois
- L'approche "test-driven" est supérieure à l'approche "mythe-driven" (données A/B le confirment)

### C3 — Silhouette test — Protocole
1. Convertir en monochrome (ou utiliser la couche monochrome Android 13+)
2. Afficher à **48px** et **24px** sur fond clair ET fond sombre
3. Appliquer un **flou gaussien léger** (1-2px)
4. Vérifier la reconnaissance en **<1 seconde**
- Si l'icône passe ces 4 étapes, elle est valide
- Material: "Use simple shapes for background silhouettes"

### C4 — Figure-fond
- Android: la séparation figure-fond doit fonctionner **sans dépendre d'une couleur spécifique** (OEM masks + themed icons)
- Viser ≥ **3:1** de contraste non-textuel pour la silhouette

### C5 — Poids visuel et centering optique
- **Centrage optique > centrage mathématique** (un pictogramme "lourd" doit être légèrement recentré)
- Limiter les détails fins au profit des **masses** (ce qui survit à 48px)
- Material documente les "Optical corrections" nécessaires

### C6 — Typographie dans les icônes
- Les libellés améliorent la compréhension des icônes (NNGroup)
- Le texte dans l'icône ne marche que si:
  - Le mot/monogramme est **déjà ultra-reconnu** (marque média: HBO, CNN, BBC)
  - Typographie **très bold**, peu de lettres, contraste ≥ **4.5:1**
- Validation obligatoire via **tests store** (PPO / A/B) — le texte en icône est un pari mesurable
- Source: https://www.nngroup.com/articles/icon-usability/

### C7 — Espace négatif
- L'espace négatif doit rester perceptible à **48px**
- Si le "truc malin" disparaît à petite taille, il ne sert plus la reconnaissance
- Rattacher aux safe zones Android (66dp) et contrainte de masquage

---

## D — TENDANCES ET CAS D'ÉTUDE 2024–2026

### D1 — Tendances 2024-2025
- Dominance du **minimalisme** avec ombres douces et dégradés subtils
- Focus sur **un élément clé** plutôt que des compositions complexes
- 2026: montée du **soft 3D**, **hyper-minimal line**, **retrofuturism**, icônes variables selon contexte
- Fonds simples = **>+26% conversion** (SplitMetrics)
- Sources: ASO Mobile, Envato

### D2 — Case studies Health/Wellness
- **Headspace**: rebranding 2024, nouvelle identité/illustration/typo. 100M+ downloads, NPS 60+, 73% clients enterprise citent la marque comme driver
- **Strava**: système iconographique 150+ icônes sur 4 breakpoints, feature "Custom App Icons"
- Pour les autres (Calm, Noom, Flo, Samsung Health, Google Fit, Nike Run Club): compléter par timeline d'icônes via AppTweak ASO Timeline

### D3 — Apps "text-in-icon" qui réussissent
- Pattern: taille du mot très court, typo bold, contraste ≥4.5:1, reconnaissance préalable
- Validation obligatoire via tests store (PPO/A/B)

### D4 — Échecs de redesign (sourcés)
| App | Année | Incident | Leçon |
|-----|-------|----------|-------|
| **Airbnb** | 2014 | Logo "Bélo" → backlash social/médiatique | Tester auprès des utilisateurs avant |
| **Instagram** | 2016 | Icône gradient → controverse massive, mais durable | Le backlash initial ne prédit pas l'échec long-terme |
| **Gap** | 2010 | Redesign logo → retiré en quelques jours | La familiarité module l'acceptation |
- Recherche académique: la **surprise** et la **familiarité/attachement** modulent l'acceptation
- Plus la familiarité est élevée, plus la surprise peut être négative
- → Nécessité d'un récit, d'une transition, et/ou de variantes
- Source: ResearchGate "Surprise! We changed the logo"

### D5 — Grille d'évaluation indie icons
1. Conformité plateforme (safe zones / masques)
2. Silhouette (48px)
3. Contraste (3:1 non-text)
4. Palette limitée (2-3 couleurs)
5. Test A/B (pré-tap) si possible

---

## E — WORKFLOW TECHNIQUE, EXPORTS ET TESTS

### E1 — Outils recommandés (2024-2026)
- **Android**: template Figma officiel + Android Studio Image Asset Studio
- **Apple**: Apple Design Resources + Icon Composer (2026, multi-layer "Liquid Glass") + SF Symbols
- **Design**: Figma, Affinity Designer, IconKitchen
- Lier l'output aux contraintes d'asset catalog / mipmap

### E2 — Checklist export complète
**Android launcher:**
- [ ] Adaptive icon: foreground + background + monochrome (recommandé Android 13+)
- [ ] Bitmaps par densité si nécessaire (mdpi→xxxhdpi, 108dp base)
- [ ] `res/mipmap-anydpi-v26/ic_launcher.xml`
- [ ] `res/mipmap-anydpi-v26/ic_launcher_round.xml`

**Google Play Store:**
- [ ] 512×512 PNG 32-bit sRGB ≤1024KB
- [ ] Carré plein, pas d'ombres, pas de coins arrondis manuels

**iOS/iPadOS/watchOS/macOS:**
- [ ] App Store: 1024×1024 px
- [ ] iPhone: 120×120 (@2x) + 180×180 (@3x)
- [ ] iPad: 152×152 (@2x) + 167×167 (@2x Pro)
- [ ] PNG, pas de régions transparentes

**Web (favicon/PWA):**
- [ ] 16×16, 32×32, 180×180 (apple-touch-icon), 192×192, 512×512

### E3 — Méthodologie de test
- **Apple PPO**: treatments, impressions, conversion rate, confidence ≥90%, max 90 jours
- **A/B testing ASO**: au moins un cycle semaine, une seule hypothèse par test (AppTweak)
- **Prudence statistique**: 90% de confiance peut être insuffisant pour décisions robustes (StoreMaven)
- Tester sur **home screen réel** + **store listing** + avec **différents masques** (cercle, squircle, rounded square)

### E4 — Rejets fréquents (Play / App Store)
**Google Play:**
- Format/poids/couleur non conformes (512×512 PNG sRGB ≤1024KB)
- Ombres/biseaux ajoutés (Play les gère)
- Éléments critiques trop proches des bords (masquage dynamique)

**Apple:**
- Tailles manquantes dans l'asset catalog
- PNG invalide ou mauvais modèle colorimétrique
- Transparence dans des contextes exigeant l'opacité (erreur ITMS-90647)

### E5 — Performance vectorielle
- Préférer du vector simple pour foreground/monochrome (bords nets, silhouettes)
- Basculer en PNG si illustration trop complexe → problèmes de rendu sur appareils faibles
- Règle empirique: "si vous devez micro-optimiser des paths, vous êtes déjà trop complexe"
- Android ne publie pas de "max path count" universel — profiling interne recommandé

---

## F — RÉFÉRENCES CLÉS

### Spécifications plateformes
- Android Adaptive Icons: https://developer.android.com/develop/ui/views/launch/icon_design_adaptive
- Google Play Icon Specs: https://developer.android.com/distribute/google-play/resources/icon-design-specifications
- Apple QA1686: https://developer.apple.com/library/archive/qa/qa1686/_index.html
- Apple Asset Catalog: https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AppIconType.html
- Apple Design Resources: https://developer.apple.com/design/resources/
- Samsung Content Publish API: https://developer.samsung.com/galaxy-store/galaxy-store-developer-api/content-publish-api/reference.html

### Accessibilité
- W3C WCAG 2.2: https://www.w3.org/TR/WCAG22/
- WCAG Non-text Contrast: https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html
- WCAG Contrast Minimum: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- NCBI Color Vision: https://www.ncbi.nlm.nih.gov/books/NBK11538/table/ch28kallcolor.T1/
- Colour Blind Awareness: https://www.colourblindawareness.org/colour-blindness/

### Études ASO / Conversion
- AppTweak Icon Trends: https://www.apptweak.com/en/aso-blog/infographic-mobile-games-app-icon-trends-2
- SplitMetrics Ciliz: https://splitmetrics.com/cases/ciliz-improves-conversion-with-splitmetrics-agency/
- SplitMetrics Nanobit: https://splitmetrics.com/cases/nanobit-increases-conversion-with-splitmetrics/
- SplitMetrics +25%: https://www.internationalaccountingbulletin.com/news/splitmetrics-research-finds-app-icon-optimisation-lands-up-to-25-more-users/
- Apple PPO: https://developer.apple.com/app-store/product-page-optimization/
- AppTweak A/B Testing: https://www.apptweak.com/en/aso-blog/basics-of-a-b-testing-in-aso
- StoreMaven: https://www.storemaven.com/academy/app-store-testing/

### Design / UX
- NNGroup Color: https://www.nngroup.com/articles/color-enhance-design/
- NNGroup Icon Usability: https://www.nngroup.com/articles/icon-usability/
- Material Icons: https://m1.material.io/style/icons.html
- ASO Mobile Trends 2025: https://asomobile.net/en/blog/app-icon-trends-and-best-practices-2025/
- Envato Trends 2026: https://author.envato.com/hub/icon-design-trends-2026/

### Case Studies
- Headspace rebrand: https://organizations.headspace.com/blog/headspace-unveils-refreshed-brand-and-expands-offerings-for-lifelong-mental-health-support
- Headspace design: https://www.itsnicethat.com/articles/italic-studio-headspace-graphic-design-project-250424
- Strava brand: https://www.designbyti.com/strava-brand
- Airbnb backlash: https://www.forbes.com/sites/davidvinjamuri/2014/07/22/airbnb-attempts-to-rebrand-accidentally-renames-ladyparts/
- Instagram redesign: https://techcrunch.com/2016/05/11/instagrams-big-redesign-goes-live-with-a-colorful-new-icon-black-and-white-app-and-more/
- Instagram retrospective: https://www.creativebloq.com/design/branding/rebrand-revisited-instagrams-controversial-2016-redesign
- Gap logo: https://www.theguardian.com/media/2010/oct/12/gap-logo-redesign
- Logo change research: https://www.researchgate.net/publication/303869341_Surprise_We_changed_the_logo
