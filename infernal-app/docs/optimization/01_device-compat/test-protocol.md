# Protocoles de Test

## 1. Test Fonctionnel de Base

### Checklist par feature

#### Compteurs d'addiction
- [ ] Increment fonctionne (tap +)
- [ ] Decrement fonctionne (tap -)
- [ ] Decrement desactive a 0
- [ ] Premiere utilisation enregistre l'heure
- [ ] Trend affiche correctement vs hier
- [ ] Haptic feedback sur tap

#### Sommeil
- [ ] Affichage "pas de donnees" si vide
- [ ] Saisie manuelle fonctionne
- [ ] Import HealthKit/Health Connect (si autorise)
- [ ] Score qualite calcule correctement
- [ ] Format duree "7h30" affiche

#### Journal
- [ ] Texte sauvegarde automatiquement
- [ ] Texte persiste apres fermeture app
- [ ] Export genere le bon format

#### Navigation
- [ ] Bottom nav switch les tabs
- [ ] Etat preserve entre tabs
- [ ] Back button comportement correct

### Devices de test minimum

| Categorie | Device recommande | Alternative |
|-----------|-------------------|-------------|
| iOS petit | iPhone SE simulator | iPhone 8 |
| iOS grand | iPhone 14 Pro simulator | iPhone 12 |
| Android petit | Pixel 4a emulator | 360dp device |
| Android grand | Pixel 7 emulator | 400dp+ device |

---

## 2. Test de Persistence

### Scenario: Fermeture app
1. Ouvrir l'app
2. Incrementer un compteur
3. Ecrire du texte dans le journal
4. Force-quit l'app (swipe up)
5. Rouvrir l'app
6. **Verifier** : compteur et texte preserves

### Scenario: Changement de jour
1. A 3h59, incrementer un compteur
2. Attendre 4h00 (ou changer l'heure systeme)
3. **Verifier** : nouveau jour demarre, compteur precedent en "hier"

### Scenario: Reinstallation
1. Desinstaller l'app
2. Reinstaller
3. **Verifier** : donnees perdues (comportement attendu, pas de cloud)

---

## 3. Test de Performance

### Metriques a verifier

| Metrique | Cible | Methode |
|----------|-------|---------|
| Startup time | < 2s | Chrono manuel ou DevTools |
| FPS scroll | 60 FPS | Flutter DevTools > Performance |
| Memory idle | < 100 MB | DevTools > Memory |
| Memory peak | < 200 MB | Apres navigation intensive |

### Scenario: Stress scroll
1. Ouvrir l'app avec 30+ jours d'historique
2. Scroller rapidement dans le calendrier (si existe)
3. **Verifier** : pas de jank visible, FPS stable

### Scenario: Low memory
1. Ouvrir plusieurs apps lourdes
2. Ouvrir InfernalWheel
3. **Verifier** : pas de crash, donnees sauvegardees

---

## 4. Test Accessibilite

### VoiceOver (iOS) / TalkBack (Android)

- [ ] Tous les boutons ont un label lisible
- [ ] Ordre de lecture logique
- [ ] Actions "incrementer/decrementer" annoncees
- [ ] Etats (actif/inactif) annonces

### Tailles de texte

- [ ] App lisible avec taille texte systeme "Extra Large"
- [ ] Pas de texte tronque
- [ ] Touch targets toujours >= 44pt (iOS) / 48dp (Android)

---

## 5. Test Edge Cases

### Dates
- [ ] 31 decembre -> 1er janvier (changement d'annee)
- [ ] 28/29 fevrier (annee bissextile)
- [ ] Changement heure ete/hiver

### Donnees
- [ ] JSON corrompu -> app ne crash pas
- [ ] Fichier manquant -> nouveau fichier cree
- [ ] Disque plein -> message d'erreur propre

### Permissions
- [ ] HealthKit refuse -> fallback manuel fonctionne
- [ ] Permission revoquee apres -> re-demande ou fallback
