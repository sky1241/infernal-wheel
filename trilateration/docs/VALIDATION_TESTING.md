# VALIDATION & TESTING — PROTOCOLES SCIENTIFIQUES
*Méthodologies de validation du système détection cigarette/alcool sur smartwatch*

---

## POURQUOI LA VALIDATION EST CRITIQUE

**Problème classique en ML wearable** : Modèle performant en lab (90% accuracy) mais médiocre en réel (65%)

**Causes** :
- **Data leakage** : K-fold cross-validation mélange données d'un même sujet → surestimation
- **Lab-to-field gap** : Environnement contrôlé ≠ conditions réelles (mouvement, distractions, variabilité)
- **Overfitting** : Modèle apprend patterns spécifiques des sujets d'entraînement, pas généralisables

**Solution** : Validation rigoureuse avec **Leave-One-Subject-Out (LOSO)** + field study

**Sources** : [HAR Validation Study 2024](https://www.mdpi.com/1999-4893/17/12/556), [Multimodal Stress Detection Validation](https://ejournals.umn.ac.id/index.php/TI/article/view/4488)

---

## CROSS-VALIDATION STRATEGIES

### A — Leave-One-Subject-Out (LOSO) ✅ RECOMMANDÉ

**Principe** : Train sur N-1 sujets, test sur 1 sujet complètement inconnu

**Implémentation** :
```python
from sklearn.model_selection import LeaveOneGroupOut
import numpy as np

# Data
X = np.array([...])  # Features (samples × 30)
y = np.array([...])  # Labels (0=rien, 1=cigarette, 2=alcool)
subjects = np.array([0, 0, 0, ..., 1, 1, 1, ..., N-1, N-1])  # Subject IDs

# LOSO Cross-Validation
logo = LeaveOneGroupOut()
scores = []

for train_idx, test_idx in logo.split(X, y, groups=subjects):
    X_train, X_test = X[train_idx], X[test_idx]
    y_train, y_test = y[train_idx], y[test_idx]

    # Train model
    model = RandomForestClassifier(n_estimators=200, class_weight='balanced')
    model.fit(X_train, y_train)

    # Evaluate on held-out subject
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred, average='weighted')

    scores.append({'subject': subjects[test_idx][0], 'accuracy': accuracy, 'f1': f1})

print(f"LOSO Mean Accuracy: {np.mean([s['accuracy'] for s in scores]):.3f}")
print(f"LOSO Mean F1: {np.mean([s['f1'] for s in scores]):.3f}")
```

**Avantages** :
- **Pas de data leakage** : sujet test jamais vu pendant training
- **Generalization réaliste** : reflète performance sur nouveaux utilisateurs
- **Gold standard** : méthode recommandée par littérature scientifique

**Inconvénients** :
- **Accuracy plus basse** : ~10-15% inférieure à K-fold (mais réaliste)
- **Computationally expensive** : N iterations (N = nombre de sujets)

**Expected results** *(basé sur littérature)* :

| Validation Method | Accuracy | F1-score |
|-------------------|----------|----------|
| **K-fold (5-fold)** | 89% | 0.87 |
| **LOSO** | **76%** | **0.74** |
| **Gap** | -13% | -0.13 |

**Interprétation** : LOSO montre la vraie performance sur nouveaux utilisateurs

**Sources** : [LOSO Plain English Guide](https://plainenglish.io/blog/leave-one-subject-out-cross-validation-for-machine-learning-model), [Random Forest LOSO Example](https://www.mdpi.com/1999-4893/17/12/556)

### B — K-Fold Cross-Validation ❌ NON RECOMMANDÉ (data leakage)

**Principe** : Split data en K folds aléatoires, train sur K-1, test sur 1

**Problème** : Si un sujet a 100 samples, ces samples seront dans différents folds
- Fold 1 (train) : 20 samples sujet A
- Fold 2 (test) : 20 samples sujet A ← **DATA LEAKAGE**

**Résultat** : Modèle voit patterns du sujet A pendant training → overestimation performance

**Example** :
```python
# K-fold (BIASED)
from sklearn.model_selection import cross_val_score

scores = cross_val_score(model, X, y, cv=5, scoring='f1_weighted')
print(f"K-fold F1: {scores.mean():.3f}")  # Output: 0.89 (surestimé)
```

**Conclusion** : **Ne jamais utiliser K-fold pour wearable ML** (sauf si vraiment pas assez de sujets)

### C — Temporal Split (Alternative)

**Principe** : Train sur premiers jours, test sur derniers jours (même sujets)

**Implémentation** :
```python
# Split temporel (70% train, 30% test)
split_idx = int(0.7 * len(X))

X_train, X_test = X[:split_idx], X[split_idx:]
y_train, y_test = y[:split_idx], y[split_idx:]

model.fit(X_train, y_train)
y_pred = model.predict(X_test)
```

**Use case** : Quand pas assez de sujets (N < 10), mais veut éviter K-fold bias

**Limitation** : Ne teste pas généralisation à nouveaux sujets

---

## PERFORMANCE METRICS — CLASSIFICATION

### A — Confusion Matrix (Fondamental)

**Principe** : Matrice erreurs pour 3 classes (rien, cigarette, alcool)

```
              Predicted
            rien  cig  alc
Actual rien  950   5   10   (TN, FP_cig, FP_alc)
       cig    8   82   4    (FN, TP_cig, FP_alc)
       alc   12   3   40    (FN, FP_cig, TP_alc)
```

**Interprétation** :
- **Diagonal** : Bonnes prédictions (950 + 82 + 40 = 1072 / 1114 = 96.2% accuracy)
- **Hors diagonal** : Erreurs
  - 5 cigarettes détectées comme "rien" (faux négatif cigarette)
  - 8 cigarettes confondues avec "rien" (faux négatif)
  - 3 alcools confondus avec cigarette (confusion inter-classes)

**Code** :
```python
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

y_true = [...]  # Ground truth
y_pred = [...]  # Model predictions

cm = confusion_matrix(y_true, y_pred, labels=[0, 1, 2])

# Visualize
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['rien', 'cigarette', 'alcool'])
disp.plot()
```

### B — Precision, Recall, F1-Score (Classe par classe)

**Formules** :

| Métrique | Formule | Signification |
|----------|---------|---------------|
| **Precision** | TP / (TP + FP) | Parmi détections positives, combien sont vraies? |
| **Recall** | TP / (TP + FN) | Parmi vrais positifs, combien détectés? |
| **F1-score** | 2 × (P × R) / (P + R) | Harmonic mean (balance P et R) |

**Example cigarette** :
```
TP (cigarette) = 82
FP (cigarette) = 5 + 3 = 8   (détectées à tort)
FN (cigarette) = 8 + 4 = 12  (manquées)

Precision = 82 / (82 + 8) = 0.911  (91.1%)
Recall = 82 / (82 + 12) = 0.872     (87.2%)
F1 = 2 × (0.911 × 0.872) / (0.911 + 0.872) = 0.891  (89.1%)
```

**Interprétation** :
- **Precision élevée** (91.1%) : Peu de faux positifs (quand dit cigarette, c'est vraiment cigarette 91% du temps)
- **Recall moyen** (87.2%) : Manque ~13% cigarettes (12 non détectées sur 94 total)
- **F1 balancé** (89.1%) : Bon compromis

**Code** :
```python
from sklearn.metrics import classification_report

print(classification_report(y_true, y_pred, target_names=['rien', 'cigarette', 'alcool']))
```

Output example:
```
              precision    recall  f1-score   support

        rien       0.98      0.98      0.98       965
   cigarette       0.91      0.87      0.89        94
      alcool       0.74      0.73      0.73        55

    accuracy                           0.96      1114
   macro avg       0.88      0.86      0.87      1114
weighted avg       0.96      0.96      0.96      1114
```

**Sources** : [Confusion Matrix Guide](https://towardsdatascience.com/performance-metrics-confusion-matrix-precision-recall-and-f1-score-a8fe076a2262/), [Google ML Metrics](https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall)

### C — ROC-AUC (Receiver Operating Characteristic)

**Principe** : Courbe TPR (True Positive Rate) vs FPR (False Positive Rate) pour différents seuils

**Use case** : Évaluer performance globale, indépendamment du seuil de décision

**Formules** :
- TPR (Recall) = TP / (TP + FN)
- FPR = FP / (FP + TN)

**Interprétation AUC** :
- **AUC = 1.0** : Classificateur parfait
- **AUC = 0.9-0.99** : Excellent
- **AUC = 0.8-0.89** : Bon
- **AUC = 0.7-0.79** : Acceptable
- **AUC = 0.5** : Aléatoire (pas mieux que pile ou face)

**Code** :
```python
from sklearn.metrics import roc_auc_score, roc_curve
import matplotlib.pyplot as plt

# Binary classification (cigarette vs rien)
y_true_binary = (y_true == 1).astype(int)  # 1 if cigarette, 0 otherwise
y_scores = model.predict_proba(X)[:, 1]    # Probability of cigarette

# Compute ROC curve
fpr, tpr, thresholds = roc_curve(y_true_binary, y_scores)
auc = roc_auc_score(y_true_binary, y_scores)

# Plot
plt.plot(fpr, tpr, label=f'ROC curve (AUC = {auc:.3f})')
plt.plot([0, 1], [0, 1], 'k--', label='Random')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.legend()
plt.show()
```

**Limitation** : ROC-AUC **biaisé pour classes déséquilibrées** (si cigarette = 1% samples, FPR reste bas même avec beaucoup de FP)

### D — PR-AUC (Precision-Recall AUC) ✅ MEILLEUR POUR IMBALANCED

**Principe** : Courbe Precision vs Recall (focus sur classe positive rare)

**Avantage** : Sensible aux faux positifs **même si classe majoritaire domine**

**Example** :
- Dataset : 98% rien, 1% cigarette, 1% alcool (très déséquilibré)
- ROC-AUC : 0.95 (paraît bon, mais FPR faible à cause TN énormes)
- PR-AUC : 0.72 (réaliste, montre que precision/recall pas top)

**Code** :
```python
from sklearn.metrics import precision_recall_curve, average_precision_score

# Compute PR curve
precision, recall, thresholds = precision_recall_curve(y_true_binary, y_scores)
pr_auc = average_precision_score(y_true_binary, y_scores)

# Plot
plt.plot(recall, precision, label=f'PR curve (AUC = {pr_auc:.3f})')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.legend()
plt.show()
```

**Recommandation** : **Utiliser PR-AUC pour cigarette/alcool** (classes minoritaires ~1-2% samples)

**Sources** : [F1 vs ROC-AUC Guide](https://www.deepchecks.com/f1-score-accuracy-roc-auc-and-pr-auc-metrics-for-models/), [Neptune.ai Metrics Comparison](https://neptune.ai/blog/f1-score-accuracy-roc-auc-pr-auc)

---

## FIELD VALIDATION — LAB VS REAL-WORLD

### Lab Study (Controlled Environment)

**Setup** :
- **Environnement** : Laboratoire contrôlé, participants assis
- **Protocole** : Fumer 1 cigarette toutes les 30 min pendant 3h (6 cigarettes total)
- **Confounding** : Demander de faire gestes confondants (manger, boire, téléphone) entre cigarettes
- **Monitoring** : Video recording + manual labeling (ground truth)

**Expected results** *(basé sur littérature)* :
- **Precision** : 92-95%
- **Recall** : 85-90%
- **F1-score** : 88-92% ✓

**Avantages** :
- Contrôle total → isoler variables
- Ground truth précis (video)
- Reproductibilité

**Inconvénients** :
- Pas représentatif du quotidien
- Participants conscients d'être observés (Hawthorne effect)
- Environnement artificiel → surestimation performance

### Field Study (Real-World)

**Setup** :
- **Environnement** : Vie quotidienne (maison, travail, bar, extérieur)
- **Protocole** : Porter smartwatch 24/7 pendant 7-30 jours
- **Labeling** : Self-report via app mobile (button "J'ai fumé") + EMA (Ecological Momentary Assessment)
- **Monitoring** : No video (privacy), trust self-report

**Expected results** *(basé sur littérature)* :
- **Precision** : 80-88% (baisse -10% vs lab)
- **Recall** : 75-85% (baisse -10% vs lab)
- **F1-score** : 77-86% ✓

**Gap lab-to-field** : **5-10% typical** (acceptable si <15%)

**Challenges** :
- **Self-report compliance** : Oublis (~15% events non reportés)
- **False negatives** : Mouvement intense (sport) → masque gesture
- **False positives** : Contextes non testés en lab (ex: bricolage, conduire)
- **Battery drain** : Participants chargent pas montre → missing data

**Mitigation strategies** :
- **EMA reminders** : Push notification toutes les 2h "Avez-vous fumé?"
- **Smart lighter** : Bluetooth lighter enregistre allumages (ground truth passif)
- **Video spot checks** : 10% du temps, demander video confirmation

**Sources** : [Smoking Detection Field Study](https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/), [Naturalistic Environment Study](https://mhealth.jmir.org/2022/2/e28159), [Sensors Scoping Review](https://pmc.ncbi.nlm.nih.gov/articles/PMC11561437/)

### Pilot Study (Feasibility)

**Objectif** : Valider faisabilité avant large-scale study

**Protocol** :
- **N = 5-10 participants**
- **Duration** : 7 jours
- **Metrics** : Compliance rate, battery life, false positive rate, usability (SUS score)

**Success criteria** :
- **Compliance** : >80% participants complètent 7 jours
- **Battery** : Montre tient 18h+ (full day)
- **False positive rate** : <5 per day
- **Usability** : SUS score >70 (acceptable)

---

## IRB & ETHICS — HUMAN SUBJECTS RESEARCH

### A — IRB Approval (Institutional Review Board)

**Requirement** : **Obligatoire** pour toute recherche impliquant humains (US, EU, Canada)

**Processus** :
1. **Submit protocol** : Description étude, risks/benefits, consent form
2. **IRB review** : 2-6 semaines
3. **Approval or modifications** : Revise si nécessaire
4. **Annual renewal** : Re-submit chaque année

**Documents requis** :
- Research protocol (10-20 pages)
- Informed consent form
- Recruitment materials (flyers, emails)
- Data management plan (privacy, security)

**Sources** : [IRB Understanding](https://ccrps.org/clinical-research-blog/understanding-institutional-review-boards-irbs-roles-amp-responsibilities), [IRB FDA FAQ](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/institutional-review-boards-frequently-asked-questions)

### B — Informed Consent

**Principe** : Participants doivent **comprendre** et **accepter volontairement** participer

**Éléments clés** :
1. **Purpose** : Pourquoi l'étude? (développer détecteur cigarette)
2. **Procedures** : Que va-t-on faire? (porter montre, self-report, durée)
3. **Risks** : Quels risques? (skin irritation montre, data breach minimal, pas de risques santé)
4. **Benefits** : Quels bénéfices? (contribuer science, compensation financière, pas de bénéfice direct santé)
5. **Privacy** : Comment données protégées? (encrypted, anonymized, local storage, no cloud)
6. **Voluntary** : Peut arrêter quand veut, sans pénalité
7. **Contact** : Qui contacter si questions? (PI email, IRB office)

**Special considerations wearables** *(source: PMC Ethical Considerations)* :
- **Technical jargon** : Éviter, utiliser langage simple
- **Video demonstration** : Montrer comment porter montre, utiliser app
- **Data ownership** : Clarifier qui possède données (participant garde contrôle)
- **Secondary use** : Demander permission utiliser données pour futures études (optionnel)

**Template example** :
```
INFORMED CONSENT FORM

Study Title: Smartwatch-Based Smoking Detection System

Principal Investigator: [Name], [Email]

PURPOSE:
We are developing a system that automatically detects when you smoke a cigarette
using sensors in a smartwatch. This study will help us test if the system works
accurately in daily life.

WHAT WILL HAPPEN:
If you agree to participate, you will:
1. Wear a smartwatch 24 hours/day for 7 days
2. Press a button in the app every time you smoke a cigarette
3. Answer short surveys (2 min) 3 times per day
4. Return the smartwatch at the end of the study

TIME COMMITMENT: 7 days, ~5 minutes/day for app logging

RISKS:
- Minor skin irritation from wearing watch (rare, <1%)
- Small risk of data breach (we encrypt all data)
- No health risks (we only record sensor data, not change behavior)

BENEFITS:
- $75 compensation for completing study
- Contributing to smoking cessation research
- No direct health benefit to you

PRIVACY:
- All data encrypted and stored locally on watch
- Your name replaced with ID code (deidentified)
- Data kept for 5 years, then deleted
- No data shared with third parties (except anonymized results in papers)

VOLUNTARY:
- Participation is completely voluntary
- You can quit anytime without penalty
- You can request your data be deleted anytime

QUESTIONS:
- For study questions: [PI email]
- For rights questions: [IRB office email]

I have read this form and agree to participate.

Signature: ________________  Date: __________
```

**Sources** : [IRB Consent Guidelines](https://hrpp.umich.edu/irb-health-sciences-and-behavioral-sciences-hsbs/informed-consent-guidelines-templates/), [Wearable Ethics PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8429072/)

### C — GDPR Compliance (European Union)

**Applicable** : Si participants basés en EU (même si chercheur US)

**Principes GDPR** :
1. **Lawfulness** : Consent explicite (opt-in, pas opt-out)
2. **Purpose limitation** : Données utilisées seulement pour étude déclarée
3. **Data minimization** : Collecter seulement nécessaire (pas d'over-collection)
4. **Accuracy** : Corriger erreurs si participant signale
5. **Storage limitation** : Supprimer après durée légale (5 ans typical)
6. **Security** : Encryption, access control, audit logs
7. **Right to erasure** : Participant peut demander suppression données ("right to be forgotten")

**GDPR consent template additions** :
```
GDPR DATA PROTECTION NOTICE

Your personal data will be processed in accordance with the General Data
Protection Regulation (GDPR).

You have the right to:
- Access your data (request copy)
- Rectify errors in your data
- Erase your data ("right to be forgotten")
- Restrict processing
- Data portability (receive your data in machine-readable format)
- Object to processing

To exercise these rights, contact: [Data Protection Officer email]

Data retention: 5 years after study completion, then securely deleted.
```

**Sources** : [GDPR IRB Template](https://research-compliance.umich.edu/irb-hsbs-gdpr-informed-consent-template-1), [UCSF IRB GDPR](https://irb.ucsf.edu/gdpr)

---

## PARTICIPANT RECRUITMENT

### Target Population

**Inclusion criteria** :
- Age : 18-65 ans (adultes)
- Smoking status : Current smoker, ≥5 cigarettes/day (light to heavy)
- Device compatibility : Owns smartphone (iOS or Android)
- Language : Fluent in study language (English, French, etc.)
- Willing to wear smartwatch 24/7 for study duration

**Exclusion criteria** :
- Cardiovascular conditions (arrhythmia, heart failure) → HR data unreliable
- Pacemaker or implanted device → interference potential
- Skin allergy to metal/rubber (watch band)
- Pregnancy (precautionary, no known risk)
- Unable to provide informed consent

### Sample Size

**Based on literature** *(smoking detection studies)* :

| Study | N participants | Duration | Cigarettes detected | Performance |
|-------|----------------|----------|---------------------|-------------|
| RisQ 2014 | 8 | 3h lab + 4h field | ~50 | 81% F1 |
| ASPIRE 2021 | 15 | 1.5h controlled | ~100 | 90% F1 |
| Sense2Quit 2025 | 20 | 7 days field | ~1000 | 97.52% F1 |

**Recommendation for our study** :
- **Pilot (feasibility)** : N = 5-10, 7 days
- **Validation study** : N = 15-30, 7-14 days
- **Field deployment** : N = 50-100, 30 days

**Power analysis** *(simplified)* :
- Target F1-score : 85%
- Null hypothesis : F1 = 50% (random)
- Power : 0.8 (80% chance detect effect if exists)
- Alpha : 0.05 (5% false positive rate)
- **Required N** : ~20 participants (based on paired t-test)

### Recruitment Strategy

**Channels** :
1. **University flyers** : Post on campus (cafeteria, dorms, libraries)
2. **Online ads** : Facebook, Reddit r/stopsmoking, Craigslist
3. **Smoking cessation clinics** : Partner with local clinics
4. **Snowball sampling** : Participants refer friends

**Flyer example** :
```
🚬 SMOKERS NEEDED FOR RESEARCH STUDY 🚬

Earn $75 for wearing a smartwatch for 7 days!

We are testing a new technology that detects smoking automatically.
All you do is wear a smartwatch and log when you smoke.

Requirements:
✓ Age 18-65
✓ Smoke 5+ cigarettes per day
✓ Own a smartphone

Time: 7 days (~5 min/day logging)
Compensation: $75 Amazon gift card

Interested? Email: study@university.edu
IRB Approved #12345
```

### Compensation

**Typical rates** *(US, 2024-2025)* :
- **Lab study** (3h) : $30-50
- **Pilot field** (7 days) : $50-75
- **Full field** (30 days) : $100-150

**Payment method** :
- Amazon/Visa gift card (most common)
- Cash (requires signature)
- Venmo/PayPal (convenient but tax implications)

---

## A/B TESTING — MODEL IMPROVEMENT

### Scenario : Tester 2 modèles en production

**Model A** : Random Forest (baseline), 85% F1-score
**Model B** : CNN-LSTM (advanced), 88% F1-score (en lab)

**Question** : Model B vraiment meilleur en réel? Ou juste overfitting?

**A/B test protocol** :
1. **Split users** : 50% get Model A, 50% get Model B (randomized)
2. **Duration** : 14 days (minimum 7 days pour stabilité)
3. **Metrics** : False positive rate, false negative rate, battery drain
4. **Analysis** : T-test pour comparer performance

**Implementation** :
```python
# Backend assigns model version
user_id = get_user_id()
model_version = 'A' if hash(user_id) % 2 == 0 else 'B'

# Log every prediction
log_event({
    'user_id': user_id,
    'model_version': model_version,
    'timestamp': now(),
    'prediction': prediction,
    'confidence': confidence,
    'ground_truth': None  # filled later by user self-report
})

# After 14 days, analyze
results_A = get_results(model_version='A')
results_B = get_results(model_version='B')

# T-test
from scipy.stats import ttest_ind
t_stat, p_value = ttest_ind(results_A['f1_scores'], results_B['f1_scores'])

if p_value < 0.05:
    print(f"Model B significantly better (p={p_value:.3f})")
    deploy_model('B')
else:
    print(f"No significant difference (p={p_value:.3f})")
    keep_model('A')  # Simpler model wins (Occam's razor)
```

---

## CHECKLIST — VALIDATION COMPLÈTE

### Phase 1 : Lab Validation (Controlled)

- [ ] IRB approval obtained
- [ ] N = 5-10 participants recruited
- [ ] Informed consent signed
- [ ] Protocol : 6 cigarettes over 3h + confounding gestures
- [ ] Video recording + manual labeling (ground truth)
- [ ] Model inference on collected data
- [ ] Confusion matrix computed
- [ ] F1-score ≥ 85% (target)
- [ ] False positive rate < 10%

### Phase 2 : Field Validation (Real-World)

- [ ] N = 15-30 participants recruited
- [ ] Duration : 7-14 days
- [ ] Self-report app functional (button logging)
- [ ] EMA reminders every 2h
- [ ] Battery life ≥ 18h verified
- [ ] Data collected from all participants
- [ ] LOSO cross-validation performed
- [ ] F1-score ≥ 80% (target, acceptable if <85%)
- [ ] Lab-to-field gap < 10%

### Phase 3 : Production Deployment

- [ ] Final model selected (A/B test winner)
- [ ] OTA update mechanism tested
- [ ] Privacy audit passed (GDPR compliant)
- [ ] User onboarding flow tested (5 users)
- [ ] Monitor false positive rate (< 2 per day)
- [ ] Monitor false negative rate (< 5%)
- [ ] User feedback collected (SUS score > 70)

---

## RÉFÉRENCES SCIENTIFIQUES VALIDÉES

### Cross-Validation & Generalization

1. **HAR Validation Methods 2024** - MDPI
   https://www.mdpi.com/1999-4893/17/12/556
   → LOSO vs K-fold comparison, data leakage prevention

2. **LOSO Plain English Guide** - Plain English
   https://plainenglish.io/blog/leave-one-subject-out-cross-validation-for-machine-learning-model
   → LOSO implementation tutorial

3. **Multimodal Stress Detection Validation** - Ultimatics
   https://ejournals.umn.ac.id/index.php/TI/article/view/4488
   → Lab-to-field gap, LOSO 85-96% accuracy

4. **Practical ML Validation for mHealth** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC11035658/
   → Bias evaluation, validation best practices

### Performance Metrics

5. **Confusion Matrix Guide** - Towards Data Science
   https://towardsdatascience.com/performance-metrics-confusion-matrix-precision-recall-and-f1-score-a8fe076a2262/
   → Precision, recall, F1 explained

6. **Google ML Crash Course** - Google Developers
   https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall
   → Official metrics guide

7. **F1 vs ROC-AUC** - DeepChecks
   https://www.deepchecks.com/f1-score-accuracy-roc-auc-and-pr-auc-metrics-for-models/
   → PR-AUC for imbalanced data

8. **Neptune.ai Metrics Comparison**
   https://neptune.ai/blog/f1-score-accuracy-roc-auc-pr-auc
   → When to use which metric

### Field Validation Studies

9. **Smoking Detection Field Study 2017** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/
   → Lab 85% F1, Field 83% F1 (gap <5%)

10. **Naturalistic Environment Study 2022** - JMIR
    https://mhealth.jmir.org/2022/2/e28159
    → 4-week study, 46 smokers, real-world deployment

11. **Sensors Scoping Review 2024** - PMC
    https://pmc.ncbi.nlm.nih.gov/articles/PMC11561437/
    → Lab vs field gap, validation protocols

### IRB & Ethics

12. **IRB Understanding** - CCRPS
    https://ccrps.org/clinical-research-blog/understanding-institutional-review-boards-irbs-roles-amp-responsibilities
    → IRB roles, responsibilities

13. **Wearable Ethics Considerations** - PMC
    https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8429072/
    → Informed consent for wearables, data ownership

14. **GDPR IRB Template** - University of Michigan
    https://research-compliance.umich.edu/irb-hsbs-gdpr-informed-consent-template-1
    → GDPR-compliant consent form

---

*"La validation rigoureuse sépare la science de l'anecdote."*

**Protocoles validés scientifiquement — Février 2026**
Sky × Claude
