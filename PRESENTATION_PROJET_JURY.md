# 🎓 PRÉSENTATION & DEFENSE DU PROJET DE FIN DE SEMESTRE
## Système de Gestion des Présences (Attendance Management System)
**Matière :** AJT - Advanced Java Technologies (01CE0308)  
**Niveau :** Semestre 3 - Computer Engineering  
**Technologies :** Java EE, Servlets 3.1, JSP, JSTL & EL, JDBC, MySQL 8.0, Bootstrap 5.3, Chart.js, Maven, Apache Tomcat & Apache NetBeans  

---

## 📑 TABLE DES MATIÈRES
1. [Vue d'Ensemble & Objectifs du Projet](#1-vue-densemble--objectifs-du-projet)
2. [Architecture Technique en Couches (MVC)](#2-architecture-technique-en-couches-mvc)
3. [Conception & Schéma Relationnel de la Base de Données](#3-conception--schéma-relationnel-de-la-base-de-données)
4. [Fonctionnalités Clés & Sécurité (RBAC)](#4-fonctionnalités-clés--sécurité-rbac)
5. [Algorithmes & Logique Métier (Règle des 75% & Transactions JDBC)](#5-algorithmes--logique-métier-règle-des-75--transactions-jdbc)
6. [Design & Expérience Utilisateur (UI/UX)](#6-design--expérience-utilisateur-uiux)
7. [Guide Pas-à-Pas : Lancer le Projet dans NetBeans & XAMPP](#7-guide-pas-à-pas--lancer-le-projet-dans-netbeans--xampp)
8. [Guide de Réponse aux Questions Pièges du Jury](#8-guide-de-réponse-aux-questions-pièges-du-jury)

---

## 1. VUE D'ENSEMBLE & OBJECTIFS DU PROJET

### Problématique
Dans les universités et établissements d'enseignement supérieur, la prise de présence manuelle sur papier présente plusieurs inconvénients majeurs :
- **Perte de temps** en début ou fin de cours.
- **Risque d'erreurs ou de fraudes**.
- **Difficulté à consolider les statistiques** pour identifier à temps les étudiants ne respectant pas le quota minimal d'assiduité (75%).

### Solution Apportée
Une application Web d'entreprise moderne, sécurisée et intuitive permettant :
- À l'**Administrateur** de piloter les cohortes d'étudiants, le corps professoral, les cours et les inscriptions (relation Many-to-Many).
- Aux **Enseignants** d'accéder à leur feuille de présence interactive en un clic, d'enregistrer les présences par lot (*Batch Processing*) et de visualiser les alertes d'absentéisme en temps réel grâce à des indicateurs visuels et graphiques.

---

## 2. ARCHITECTURE TECHNIQUE EN COUCHES (MVC)

Le projet respecte rigoureusement les normes de développement Java d'entreprise avec le patron de conception **Modèle-Vue-Contrôleur (MVC)** en 4 couches découplées :

```
             ┌───────────────────────────────────────────────┐
             │       Navigateur Web (Client HTTP)            │
             └───────────────────────┬───────────────────────┘
                                     │ Requêtes HTTP (GET/POST)
                                     ▼
             ┌───────────────────────────────────────────────┐
             │  Filtre de Sécurité (AuthenticationFilter)     │
             └───────────────────────┬───────────────────────┘
                                     ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ COUCHE CONTRÔLEUR (Java Servlets)                                         │
│ • AuthServlet (Connexion / Déconnexion)                                    │
│ • AdminDashboardServlet / StudentServlet / TeacherServlet / SubjectServlet │
│ • AttendanceServlet (Saisie par lot) & ReportServlet (Rapports 75%)        │
└─────────────────────┬────────────────────────────────┬─────────────────────┘
                      │                                │
                      ▼                                ▼
┌──────────────────────────────────────┐   ┌─────────────────────────────────┐
│ COUCHE MODÈLE & DTO (Java Beans)     │   │ COUCHE VUE (JSP / JSTL / EL)    │
│ • User, Student, Teacher, Subject    │   │ • Pages JSP modernes Bootstrap  │
│ • Enrollment, Attendance             │   │ • Graphiques interactifs Chart.js│
│ • AttendanceSheetRowDTO, ReportDTO   │   │ • Formulaires & Modales dynamiques│
└─────────────────────▲────────────────┘   └─────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ COUCHE ACCÈS AUX DONNÉES (DAO & JDBC)                                     │
│ • DBConnection (Singleton JDBC avec db.properties)                        │
│ • UserDAO, StudentDAO, TeacherDAO, SubjectDAO, EnrollmentDAO, AttendanceDAO│
│ • Transactions ACID (commit/rollback) & PreparedStatement (anti-injection) │
└─────────────────────┬──────────────────────────────────────────────────────┘
                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ BASE DE DONNÉES RELATIONNELLE (MySQL 8.0)                                  │
│ attendance_management_system (6 tables normalisées 3NF)                   │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. CONCEPTION & SCHÉMA RELATIONNEL DE LA BASE DE DONNÉES

Le schéma relationnel répond fidèlement aux spécifications du sujet avec **6 tables normalisées en 3ème Forme Normale (3NF)** :

| Table | Rôle & Utilité | Clé Primaire & Clés Étrangères |
| :--- | :--- | :--- |
| `system_user` | Stocke les identifiants de connexion hachés (SHA-256) et les rôles (`ADMIN`, `TEACHER`). | `user_id` (PK) |
| `student` | Répertoire complet des étudiants avec numéro d'enrôlement unique. | `student_id` (PK), `enrollment_no` (UNIQUE) |
| `teacher` | Profil de l'enseignant, lié à son compte système. | `teacher_id` (PK), `user_id` (FK $\rightarrow$ `system_user`) |
| `subject` | Liste des matières universitaires et professeur assigné. | `subject_id` (PK), `teacher_id` (FK $\rightarrow$ `teacher`) |
| `enrollment` | Table d'association résolvant la relation N:M entre Étudiants et Matières. | `enrollment_id` (PK), `student_id` (FK), `subject_id` (FK), `(student_id, subject_id)` (UNIQUE) |
| `attendance` | Fiches de présence quotidiennes par inscription. | `attendance_id` (PK), `enrollment_id` (FK), `(enrollment_id, attendance_date)` (UNIQUE) |

> 💡 **Point d'excellence pour le jury :**
> - La table d'association `enrollment` évite la redondance d'informations : un étudiant suit plusieurs cours, et un cours réunit plusieurs étudiants.
> - La contrainte `UNIQUE (enrollment_id, attendance_date)` garantit qu'un même étudiant ne peut pas avoir deux statuts différents pour une même séance de cours.

---

## 4. FONCTIONNALITÉS CLÉS & SÉCURITÉ (RBAC)

### 1. Contrôle d'Accès Basé sur les Rôles (RBAC)
- **Filtre Servlet (`AuthenticationFilter`)** : Intercepte toutes les requêtes.
  - Tout accès non connecté vers `/admin/*` ou `/teacher/*` est automatiquement redirigé vers `/login`.
  - Un enseignant ne peut pas accéder aux pages réservées aux administrateurs (erreur HTTP 403 Forbidden).
- **Protection des Mots de Passe** : Les mots de passe sont hachés via l'algorithme cryptographique **SHA-256** (`PasswordUtil.java`).
- **Prévention des Injections SQL** : 100% des requêtes passent par des `PreparedStatement` paramétrés (`?`), neutralisant tout risque d'attaque par injection.

### 2. Module Administrateur
- **Tableau de bord dynamique** avec 4 KPI cards (Total Étudiants, Enseignants, Matières, Taux global).
- **Graphique en anneau (Donut Chart)** : Distribution en temps réel Présents vs Absents.
- **Graphique à barres (Bar Chart)** : Taux d'assiduité comparé par matière.
- **CRUD complet** pour Étudiants, Enseignants (génération automatique du compte de connexion), Matières et Inscriptions.

### 3. Module Enseignant
- **Espace dédié** affichant uniquement les matières attribuées à l'enseignant connecté.
- **Feuille d'appel interactive** :
  - Sélection de la matière et de la date (par défaut date du jour).
  - Boutons d'automatisation rapide : *"Tous Présents"* et *"Tous Absents"*.
  - Sélecteurs radios visuels (Vert pour Présent, Rouge pour Absent).
  - Enregistrement par lot atomique.
- **Rapports d'assiduité & Règle des 75%** :
  - Calcul dynamique du pourcentage d'assiduité par étudiant.
  - Barres de progression colorées (Vert si $\ge 75\%$, Rouge si $< 75\%$).
  - Badge d'avertissement et alerte d'exclusion.
  - Fonction d'export / impression directe de la liste officielle.

---

## 5. ALGORITHMES & LOGIQUE MÉTIER

### A. Transaction JDBC Atomique pour les Présences (`saveBatchAttendance`)
Pour éviter des corruptions de données en cas de panne réseau ou serveur pendant l'enregistrement d'une classe de 50 étudiants, le DAO utilise une **transaction JDBC avec validation atomique** :

```java
conn.setAutoCommit(false); // Démarrage transaction
PreparedStatement stmt = conn.prepareStatement(
    "INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) " +
    "VALUES (?, ?, ?, ?) " +
    "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by)"
);

for (Map.Entry<Integer, String> entry : enrollmentStatusMap.entrySet()) {
    stmt.setInt(1, entry.getKey());
    stmt.setDate(2, date);
    stmt.setString(3, entry.getValue());
    stmt.setInt(4, teacherId);
    stmt.addBatch(); // Traitement par lot performant
}

stmt.executeBatch();
conn.commit(); // Validation complète
```

### B. Calcul de l'Assiduité et Seuil des 75% (`StudentReportDTO`)
La règle académique est implémentée avec précision :
$$\text{Pourcentage d'Assiduité} = \left( \frac{\text{Séances Présentes}}{\text{Total des Séances de la Matière}} \right) \times 100$$
- Si $\text{Pourcentage} < 75\%$, la méthode `isWarning()` renvoie `true`, ce qui active automatiquement le style d'alerte rouge et le libellé *"Risque d'exclusion aux examens"*.

---

## 6. DESIGN & EXPÉRIENCE UTILISATEUR (UI/UX)

L'interface a été conçue pour allier modernité, professionnalisme et clarté :
- **Palette de couleurs épurée** : Nuances d'Indigo (`#4f46e5`), Bleu ardoise (`#1e293b`), Vert émeraude (`#10b981`) et Rouge corail (`#ef4444`).
- **Composants modernes** : Cartes à ombres douces, barres de recherche instantanées sur les tableaux sans rechargement de page (`main.js`), alertes auto-fermantes après 5 secondes.
- **Graphiques interactifs Chart.js** : Animation fluide lors du chargement des statistiques.

---

## 7. GUIDE PAS-À-PAS : LANCER LE PROJET DANS NETBEANS & XAMPP

### Étape 1 : Base de Données (MySQL dans XAMPP)
1. Ouvrez le **XAMPP Control Panel**.
2. Démarrez le service **MySQL** (cliquez sur *Start*).
3. Ouvrez votre navigateur sur `http://localhost/phpmyadmin` (ou utilisez la console MySQL).
4. Cliquez sur l'onglet **Importer** (Import) :
   - Sélectionnez le fichier `database/schema.sql` puis cliquez sur **Exécuter**.
   - Sélectionnez ensuite `database/seed_data.sql` puis cliquez sur **Exécuter**.
5. Votre base de données `attendance_management_system` est prête avec 6 tables et des données de test complètes.

### Étape 2 : Ouvrir le Projet dans Apache NetBeans
1. Lancez **Apache NetBeans**.
2. Dans le menu supérieur, cliquez sur **File** $\rightarrow$ **Open Project...**
3. Naviguez jusqu'au dossier du projet :  
   `.../attendance-management-system/AttendanceSystem`
4. NetBeans détectera automatiquement l'icône de projet Maven Web (icône de tasse de café avec un globe web). Cliquez sur **Open Project**.

### Étape 3 : Exécution de l'Application
1. Faites un clic droit sur le projet dans l'explorateur NetBeans $\rightarrow$ **Run** (ou appuyez sur `F6`).
2. NetBeans vous demandera de sélectionner votre serveur (ex: **Apache Tomcat** ou **GlassFish**).
3. L'application se compilera et s'ouvrira automatiquement dans votre navigateur à l'adresse :
   `http://localhost:8080/AttendanceManagementSystem/`

### Identifiants de Démonstration :
| Profil | Nom d'utilisateur | Mot de passe | Accès |
| :--- | :--- | :--- | :--- |
| **Administrateur** | `admin` | `admin123` | Dashboard complet, CRUD étudiants/profs/matières |
| **Enseignant 1** | `kunal.khimani` | `teacher123` | Espace AJT & OS, saisie des présences, rapports |
| **Enseignant 2** | `sweta.khatana` | `teacher123` | Espace DBMS, saisie des présences, rapports |

---

## 8. GUIDE DE RÉPONSE AUX QUESTIONS PIÈGES DU JURY

Voici les questions fréquentes des examinateurs en soutenance AJT et les réponses à formuler avec assurance :

### Q1 : *"Pourquoi avez-vous créé une table `enrollment` au lieu de mettre directement l'étudiant dans la matière ?"*
> **Votre réponse :**  
> *"La relation entre un étudiant et une matière est de type Many-to-Many (N:M). Un étudiant est inscrit à plusieurs matières, et une matière est suivie par plusieurs étudiants. Créer une table intermédiaire `enrollment` permet de respecter la 3ème Forme Normale (3NF), d'éviter toute redondance et d'enregistrer des informations spécifiques à l'inscription (date d'inscription, statut actif/inactif) ainsi que les présences rattachées."*

### Q2 : *"Comment assurez-vous la sécurité contre les injections SQL ?"*
> **Votre réponse :**  
> *"Nous n'utilisons aucune concaténation directe de chaînes dans nos requêtes SQL. Toutes les interactions avec la base passent par des objets `PreparedStatement` avec des paramètres positionnels `?`. Cela garantit que le moteur SQL précompile la requête et traite les entrées utilisateurs strictement comme des données typées, rendant impossible l'injection de commandes malveillantes."*

### Q3 : *"Que se passe-t-il si la connexion coupe au milieu de l'enregistrement de la présence ?"*
> **Votre réponse :**  
> *"La méthode `saveBatchAttendance` utilise une transaction JDBC explicite. Nous désactivons l'auto-commit (`conn.setAutoCommit(false)`), nous préparons un lot de requêtes (`addBatch()`) et nous ne validons (`conn.commit()`) que si toutes les lignes ont été exécutées avec succès. En cas de la moindre exception, un bloc `catch` exécute un `conn.rollback()`, garantissant l'atomicité et l'intégrité de la base."*

### Q4 : *"Comment protégez-vous les pages pour qu'un enseignant ne puisse pas modifier les notes ou étudiants en tant qu'admin ?"*
> **Votre réponse :**  
> *"Nous avons mis en place un `AuthenticationFilter` qui intercepte chaque requête HTTP. Si un utilisateur connecté avec le rôle `TEACHER` tente d'accéder à une URL sous `/admin/*`, le filtre bloque immédiatement la requête et renvoie un code de statut HTTP 403 Forbidden."*

### Q5 : *"Pourquoi avoir utilisé JSTL et Expression Language (EL) dans vos pages JSP ?"*
> **Votre réponse :**  
> *"Pour respecter les bonnes pratiques Java EE et éliminer les anciens scriptlets Java (`<% ... %>`) dans les vues. JSTL (`<c:forEach>`, `<c:if>`, `<c:choose>`) combiné avec EL (`${...}`) sépare nettement la présentation de la logique métier, ce qui rend le code propre, maintenable et sécurisé."*

---
*(Ce document peut être imprimé ou projeté sous forme de diapositives lors de votre soutenance orale).*
