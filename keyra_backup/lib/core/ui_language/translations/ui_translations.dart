import 'package:flutter/widgets.dart';

class UiTranslations extends InheritedWidget {
  final String currentLanguage;

  const UiTranslations({
    super.key,
    required super.child,
    required this.currentLanguage,
  });

  static UiTranslations of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UiTranslations>()!;
  }

  @override
  bool updateShouldNotify(UiTranslations oldWidget) {
    return currentLanguage != oldWidget.currentLanguage;
  }

  String translate(String key) {
    return translations[currentLanguage]?[key] ??
        translations['en']?[key] ??
        key;
  }

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // Settings & Profile
      'select_language': 'Select Language',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'dark_mode_disabled': 'Dark mode is disabled when app colors are enabled',
      'app_colors': 'App Colors',
      'gradient_theme_enabled': 'Using gradient theme colors',
      'notifications': 'Notifications',
      'app_language': 'App Language',
      'information': 'Information',
      'version': 'Version',
      'acknowledgments': 'Acknowledgments',
      'special_thanks': 'Special Thanks',
      'icons_section': 'Icons',
      'icons_description': 'HugeIcons - Beautiful and consistent icon set\nFlatIcon - High quality icons and graphics',
      'animations_section': 'Animations',
      'animations_description': 'Lottie Animation - "Free fox greetings Animation" by Solitudinem',
      'fonts_section': 'Fonts',
      'fonts_description': 'FascinateInline - Unique and stylish font for our branding',
      'libraries_section': 'Open Source Libraries',
      'libraries_description': 'Flutter and Dart communities for their amazing work',
      'contributors_section': 'Contributors',
      'contributors_description': 'All the developers who have contributed to this project',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'developer': 'Developer',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'Contact Us',
      'socials': 'Socials',
      'chat_with_friends': 'Chat with Friends',
      'improve_language_skills': 'Improve your language skills',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Discover learning tips',
      'tiktok': 'TikTok',
      'fun_language_content': 'Fun language content',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'privacy_policy_content': '''
Welcome to Keyra! This Privacy Policy explains how we collect, use, and protect your personal information.

1. Information We Collect
- Account information (email, name)
- Reading progress and preferences
- Study statistics and saved words
- Device information

2. How We Use Your Information
- To provide personalized learning experience
- To improve our services
- To send important updates

3. Data Protection
We implement security measures to protect your personal information and ensure it's not accessed without authorization.

4. Your Rights
You have the right to:
- Access your personal data
- Request corrections
- Delete your account
- Opt out of communications

5. Contact Us
If you have questions about this Privacy Policy, please contact us through the app.
''',
      'terms_of_service_content': '''
Terms of Service

1. Acceptance of Terms
By using Keyra, you agree to these Terms of Service.

2. User Account
- You are responsible for maintaining account security
- Provide accurate information
- One account per user

3. Acceptable Use
- Use for personal learning only
- Do not share account access
- Do not misuse the service

4. Content
- We own the app content and design
- You own your personal data
- Respect copyright laws

5. Termination
We may suspend accounts that violate these terms.

6. Changes to Terms
We may update these terms with notice.

7. Disclaimer
Service provided "as is" without warranties.
''',
      
      // Navigation
      'nav_home': 'Home',
      'nav_library': 'Library',
      'nav_study': 'Study',
      'nav_dashboard': 'Dashboard',

      // Home
      'home_error_load_books': 'Error loading books',
      'home_error_favorite': 'Error updating favorite status',
      'home_recently_added_stories': 'Recently Added Stories',
      'home_continue_reading': 'Continue Reading',
      'home_page_progress': 'Progress',
      'home_no_in_progress_books': 'No books in progress yet. Start reading a story to see it here!',

      // Library
      'library_search_books': 'Search books',
      'library_filter_all': 'All',
      'library_filter_favorites': 'Favorites',
      'library_filter_recents': 'Recent',
      'library_no_books': 'No books available',
      'library_retry': 'Retry',

      // Dashboard
      'books_read': 'Books Read',
      'favorite_books': 'Favorite Books',
      'reading_streak': 'Reading Streak',
      'saved_words': 'Saved Words',
      'achievements': 'Achievements',
      
      // Badges
      'badge_beginner': 'Beginner',
      'badge_intermediate': 'Intermediate',
      'badge_advanced': 'Advanced',
      'badge_master': 'Master',
      'badge_explorer': 'Explorer',
      'badge_voyager': 'Voyager',
      'badge_weaver': 'Weaver',
      'badge_navigator': 'Navigator',
      'badge_pioneer': 'Pioneer',
      'badge_royalty': 'Royalty',
      'badge_baron': 'Baron',
      'badge_legend': 'Legend',
      'badge_wizard': 'Wizard',
      'badge_epic': 'Epic',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Sovereign',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminary',
      'badge_beacon': 'Beacon',
      'badge_radiant': 'Radiant',
      'badge_lighthouse': 'Lighthouse',
      'badge_infinite': 'Infinite',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultimate',
      'requirements': 'Requirements',
      'books_read_requirement': '{0} books read required',
      'favorite_books_requirement': '{0} favorite books required',
      'reading_streak_requirement': '{0} days reading streak required',

      // Study
      'study_progress': 'Study Progress',
      'total_words': 'total words',
      'start_studying': 'Start Studying',
      'word_status_new': 'New',
      'word_status_learning': 'Learning',
      'word_status_learned': 'Learned',
      'dashboard_study_words': 'Study Words',
      'dashboard_select_language_to_study': 'Select language to study',
      'common_all_languages': 'All Languages',
      'language_english': 'English',
      'language_french': 'French',
      'language_spanish': 'Spanish',
      'language_italian': 'Italian',
      'language_german': 'German',
      'language_japanese': 'Japanese',
      'study_tips': 'Study Tips',
      'regular_practice': 'Regular Practice',
      'regular_practice_desc': 'Practice regularly to maintain and improve your vocabulary',
      'spaced_repetition': 'Spaced Repetition',
      'spaced_repetition_desc': 'Review words at increasing intervals to enhance retention',
      'context_learning': 'Context Learning',
      'context_learning_desc': 'Learn words in context to better understand their usage',
      'tap_to_see_definition': 'Tap to see definition',
      'tap_to_see_word': 'Tap to see word',
      'definition': 'Definition',
      'examples': 'Examples',
      'flashcard_error_update': 'Error updating word',
      'flashcard_study_session': 'Study Session',
      'flashcard_difficulty_hard': 'Hard',
      'flashcard_difficulty_good': 'Good',
      'flashcard_difficulty_easy': 'Easy',
      'no_saved_words_language_message': 'No saved words in this language yet',
      'no_saved_words_message': 'No saved words yet',
      'saved_words_title': 'Saved Words',
      'meanings': 'Meanings:',
      'common_definition': 'Definition',
    },
    'fr': {
      // Settings & Profile
      'settings': 'Paramètres',
      'app_colors': 'Couleurs de l\'App',
      'information': 'Informations',
      'version': 'Version',
      'notifications': 'Notifications',
      'app_language': 'Langue de l\'App',
      'gradient_theme_enabled': 'Utilisation des couleurs de thème dégradé',
      'dark_mode': 'Mode Sombre',
      'dark_mode_disabled': 'Le mode sombre est désactivé lorsque les couleurs de l\'app sont activées',
      'privacy_policy': 'Politique de Confidentialité',
      'terms_of_service': 'Conditions d\'Utilisation',
      'developer': 'Développeur',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'Contactez-nous',
      'socials': 'Réseaux Sociaux',
      'chat_with_friends': 'Discuter avec des Amis',
      'improve_language_skills': 'Améliorez vos compétences linguistiques',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Découvrez des conseils d\'apprentissage',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenu linguistique amusant',
      'logout': 'Déconnexion',
      'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'cancel': 'Annuler',

      // Navigation
      'nav_home': 'Accueil',
      'nav_library': 'Bibliothèque',
      'nav_study': 'Étudier',
      'nav_dashboard': 'Tableau de bord',

      // Home
      'home_error_load_books': 'Erreur lors du chargement des livres',
      'home_error_favorite': 'Erreur lors de la mise à jour des favoris',
      'home_recently_added_stories': 'Histoires Récemment Ajoutées',
      'home_continue_reading': 'Continuer la Lecture',
      'home_page_progress': 'Progression',
      'home_no_in_progress_books': 'Aucun livre en cours. Commencez à lire une histoire pour la voir ici !',

      // Library
      'library_search_books': 'Rechercher des livres',
      'library_filter_all': 'Tous',
      'library_filter_favorites': 'Favoris',
      'library_filter_recents': 'Récents',
      'library_no_books': 'Aucun livre disponible',
      'library_retry': 'Réessayer',

      // Dashboard
      'books_read': 'Livres Lus',
      'favorite_books': 'Livres Favoris',
      'reading_streak': 'Série de Lecture',
      'saved_words': 'Mots Sauvegardés',
      'achievements': 'Réalisations',

      // Study
      'study_progress': 'Progrès d\'Étude',
      'total_words': 'mots au total',
      'start_studying': 'Commencer à Étudier',
      'word_status_new': 'Nouveau',
      'word_status_learning': 'En cours',
      'word_status_learned': 'Appris',
      'dashboard_study_words': 'Étudier les Mots',
      'dashboard_select_language_to_study': 'Sélectionner la langue à étudier',
      'common_all_languages': 'Toutes les Langues',
      'language_english': 'Anglais',
      'language_french': 'Français',
      'language_spanish': 'Espagnol',
      'language_italian': 'Italien',
      'language_german': 'Allemand',
      'language_japanese': 'Japonais',
      'study_tips': 'Conseils d\'Étude',
      'regular_practice': 'Pratique Régulière',
      'regular_practice_desc': 'Pratiquez régulièrement pour maintenir et améliorer votre vocabulaire',
      'spaced_repetition': 'Répétition Espacée',
      'spaced_repetition_desc': 'Révisez les mots à intervalles croissants pour améliorer la rétention',
      'context_learning': 'Apprentissage en Contexte',
      'context_learning_desc': 'Apprenez les mots en contexte pour mieux comprendre leur utilisation',
      'tap_to_see_definition': 'Appuyez pour voir la définition',
      'tap_to_see_word': 'Appuyez pour voir le mot',
      'definition': 'Définition',
      'examples': 'Exemples',
      'flashcard_error_update': 'Erreur lors de la mise à jour du mot',
      'flashcard_study_session': 'Session d\'Étude',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_difficulty_easy': 'Facile',
      'no_saved_words_language_message': 'Pas encore de mots sauvegardés dans cette langue',
      'no_saved_words_message': 'Pas encore de mots sauvegardés',
      'saved_words_title': 'Mots Sauvegardés',
      'meanings': 'Significations :',
      'common_definition': 'Définition',

      // Badges
      'badge_beginner': 'Débutant',
      'badge_intermediate': 'Intermédiaire',
      'badge_advanced': 'Avancé',
      'badge_master': 'Maître',
      'badge_explorer': 'Explorateur',
      'badge_voyager': 'Voyageur',
      'badge_weaver': 'Tisseur',
      'badge_navigator': 'Navigateur',
      'badge_pioneer': 'Pionnier',
      'badge_royalty': 'Royauté',
      'badge_baron': 'Baron',
      'badge_legend': 'Légende',
      'badge_wizard': 'Sorcier',
      'badge_epic': 'Épique',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Souverain',
      'badge_virtuoso': 'Virtuose',
      'badge_luminary': 'Luminaire',
      'badge_beacon': 'Phare',
      'badge_radiant': 'Radiant',
      'badge_lighthouse': 'Phare',
      'badge_infinite': 'Infini',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultime',
      'requirements': 'Prérequis',
      'books_read_requirement': '{0} livres lus requis',
      'favorite_books_requirement': '{0} livres favoris requis',
      'reading_streak_requirement': '{0} jours de lecture consécutifs requis',
      'privacy_policy_content': '''
Bienvenue sur Keyra ! Cette Politique de Confidentialité explique comment nous collectons, utilisons et protégeons vos informations personnelles.

1. Informations Collectées
- Informations de compte (email, nom)
- Progrès de lecture et préférences
- Statistiques d'étude et mots sauvegardés
- Informations sur l'appareil

2. Utilisation des Informations
- Pour fournir une expérience d'apprentissage personnalisée
- Pour améliorer nos services
- Pour envoyer des mises à jour importantes

3. Protection des Données
Nous mettons en œuvre des mesures de sécurité pour protéger vos informations personnelles.

4. Vos Droits
Vous avez le droit de :
- Accéder à vos données personnelles
- Demander des corrections
- Supprimer votre compte
- Refuser les communications

5. Contactez-nous
Pour toute question, contactez-nous via l'application.
''',
      'terms_of_service_content': '''
Conditions d'Utilisation

1. Acceptation des Conditions
En utilisant Keyra, vous acceptez ces conditions.

2. Compte Utilisateur
- Vous êtes responsable de la sécurité
- Fournir des informations exactes
- Un compte par utilisateur

3. Utilisation Acceptable
- Usage personnel uniquement
- Ne pas partager l'accès
- Ne pas abuser du service

4. Contenu
- Nous possédons le contenu de l'app
- Vous possédez vos données
- Respecter les droits d'auteur

5. Résiliation
Nous pouvons suspendre les comptes en infraction.

6. Modifications
Nous pouvons mettre à jour ces conditions.

7. Avertissement
Service fourni "tel quel" sans garanties.
''',
    },
    'es': {
      // Settings & Profile
      'settings': 'Ajustes',
      'app_colors': 'Colores de la App',
      'information': 'Información',
      'version': 'Versión',
      'notifications': 'Notificaciones',
      'app_language': 'Idioma de la App',
      'gradient_theme_enabled': 'Usando colores de tema degradado',
      'dark_mode': 'Modo Oscuro',
      'dark_mode_disabled': 'El modo oscuro está desactivado cuando los colores de la app están habilitados',
      'privacy_policy': 'Política de Privacidad',
      'terms_of_service': 'Términos de Servicio',
      'developer': 'Desarrollador',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'Contáctenos',
      'socials': 'Redes Sociales',
      'chat_with_friends': 'Chatear con Amigos',
      'improve_language_skills': 'Mejora tus habilidades lingüísticas',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Descubre consejos de aprendizaje',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenido lingüístico divertido',
      'logout': 'Cerrar Sesión',
      'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      'cancel': 'Cancelar',

      // Navigation
      'nav_home': 'Inicio',
      'nav_library': 'Biblioteca',
      'nav_study': 'Estudiar',
      'nav_dashboard': 'Panel',

      // Home
      'home_error_load_books': 'Error al cargar los libros',
      'home_error_favorite': 'Error al actualizar el estado de favorito',
      'home_recently_added_stories': 'Historias Recién Añadidas',
      'home_continue_reading': 'Continuar Leyendo',
      'home_page_progress': 'Progreso',
      'home_no_in_progress_books': '¡No hay libros en progreso todavía. ¡Empieza a leer una historia para verla aquí!',

      // Library
      'library_search_books': 'Buscar libros',
      'library_filter_all': 'Todos',
      'library_filter_favorites': 'Favoritos',
      'library_filter_recents': 'Recientes',
      'library_no_books': 'No hay libros disponibles',
      'library_retry': 'Reintentar',

      // Dashboard
      'books_read': 'Libros Leídos',
      'favorite_books': 'Libros Favoritos',
      'reading_streak': 'Racha de Lectura',
      'saved_words': 'Palabras Guardadas',
      'achievements': 'Logros',

      // Study
      'study_progress': 'Progreso de Estudio',
      'total_words': 'palabras totales',
      'start_studying': 'Comenzar a Estudiar',
      'word_status_new': 'Nuevo',
      'word_status_learning': 'Aprendiendo',
      'word_status_learned': 'Aprendido',
      'dashboard_study_words': 'Estudiar Palabras',
      'dashboard_select_language_to_study': 'Seleccionar idioma para estudiar',
      'common_all_languages': 'Todos los Idiomas',
      'language_english': 'Inglés',
      'language_french': 'Francés',
      'language_spanish': 'Español',
      'language_italian': 'Italiano',
      'language_german': 'Alemán',
      'language_japanese': 'Japonés',
      'study_tips': 'Consejos de Estudio',
      'regular_practice': 'Práctica Regular',
      'regular_practice_desc': 'Practica regularmente para mantener y mejorar tu vocabulario',
      'spaced_repetition': 'Repetición Espaciada',
      'spaced_repetition_desc': 'Revisa palabras en intervalos crecientes para mejorar la retención',
      'context_learning': 'Aprendizaje en Contexto',
      'context_learning_desc': 'Aprende palabras en contexto para entender mejor su uso',
      'tap_to_see_definition': 'Toca para ver la definición',
      'tap_to_see_word': 'Toca para ver la palabra',
      'definition': 'Definición',
      'examples': 'Ejemplos',
      'flashcard_error_update': 'Error al actualizar la palabra',
      'flashcard_study_session': 'Sesión de Estudio',
      'flashcard_difficulty_hard': 'Difícil',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_difficulty_easy': 'Fácil',
      'no_saved_words_language_message': 'Aún no hay palabras guardadas en este idioma',
      'no_saved_words_message': 'Aún no hay palabras guardadas',
      'saved_words_title': 'Palabras Guardadas',
      'meanings': 'Significados:',
      'common_definition': 'Definición',

      // Badges
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzado',
      'badge_master': 'Maestro',
      'badge_explorer': 'Explorador',
      'badge_voyager': 'Viajero',
      'badge_weaver': 'Tejedor',
      'badge_navigator': 'Navegante',
      'badge_pioneer': 'Pionero',
      'badge_royalty': 'Realeza',
      'badge_baron': 'Barón',
      'badge_legend': 'Leyenda',
      'badge_wizard': 'Mago',
      'badge_epic': 'Épico',
      'badge_titan': 'Titán',
      'badge_sovereign': 'Soberano',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminario',
      'badge_beacon': 'Faro',
      'badge_radiant': 'Radiante',
      'badge_lighthouse': 'Faro',
      'badge_infinite': 'Infinito',
      'badge_renaissance': 'Renacimiento',
      'badge_ultimate': 'Definitivo',
      'requirements': 'Requisitos',
      'books_read_requirement': '{0} libros leídos requeridos',
      'favorite_books_requirement': '{0} libros favoritos requeridos',
      'reading_streak_requirement': '{0} días de racha de lectura requeridos',
      'privacy_policy_content': '''
¡Bienvenido a Keyra! Esta Política de Privacidad explica cómo recopilamos, usamos y protegemos su información personal.

1. Información que Recopilamos
- Información de cuenta (email, nombre)
- Progreso de lectura y preferencias
- Estadísticas de estudio y palabras guardadas
- Información del dispositivo

2. Uso de la Información
- Para proporcionar experiencia personalizada
- Para mejorar nuestros servicios
- Para enviar actualizaciones importantes

3. Protección de Datos
Implementamos medidas de seguridad para proteger su información personal.

4. Sus Derechos
Tiene derecho a:
- Acceder a sus datos personales
- Solicitar correcciones
- Eliminar su cuenta
- Optar por no recibir comunicaciones

5. Contáctenos
Para preguntas, contáctenos a través de la aplicación.
''',
      'terms_of_service_content': '''
Términos de Servicio

1. Aceptación de Términos
Al usar Keyra, acepta estos términos.

2. Cuenta de Usuario
- Es responsable de la seguridad
- Proporcionar información precisa
- Una cuenta por usuario

3. Uso Aceptable
- Solo uso personal
- No compartir acceso
- No abusar del servicio

4. Contenido
- Poseemos el contenido de la app
- Usted posee sus datos
- Respetar derechos de autor

5. Terminación
Podemos suspender cuentas infractoras.

6. Cambios
Podemos actualizar estos términos.

7. Descargo
Servicio proporcionado "tal cual".
''',
    },
    'it': {
      // Settings & Profile
      'settings': 'Impostazioni',
      'app_colors': 'Colori App',
      'information': 'Informazioni',
      'version': 'Versione',
      'notifications': 'Notifiche',
      'app_language': 'Lingua App',
      'gradient_theme_enabled': 'Usando i colori del tema sfumato',
      'dark_mode': 'Modalità Scura',
      'dark_mode_disabled': 'La modalità scura è disabilitata quando i colori dell\'app sono attivi',
      'privacy_policy': 'Informativa sulla Privacy',
      'terms_of_service': 'Termini di Servizio',
      'developer': 'Sviluppatore',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'Contattaci',
      'socials': 'Social',
      'chat_with_friends': 'Chatta con gli Amici',
      'improve_language_skills': 'Migliora le tue competenze linguistiche',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Scopri consigli per l\'apprendimento',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenuti linguistici divertenti',
      'logout': 'Esci',
      'logout_confirm': 'Sei sicuro di voler uscire?',
      'cancel': 'Annulla',

      // Navigation
      'nav_home': 'Home',
      'nav_library': 'Biblioteca',
      'nav_study': 'Studio',
      'nav_dashboard': 'Dashboard',

      // Home
      'home_error_load_books': 'Errore durante il caricamento dei libri',
      'home_error_favorite': 'Errore durante l\'aggiornamento dei preferiti',
      'home_recently_added_stories': 'Storie Aggiunte di Recente',
      'home_continue_reading': 'Continua a Leggere',
      'home_page_progress': 'Progresso',
      'home_no_in_progress_books': 'Nessun libro in corso. Inizia a leggere una storia per vederla qui!',

      // Library
      'library_search_books': 'Cerca libri',
      'library_filter_all': 'Tutti',
      'library_filter_favorites': 'Preferiti',
      'library_filter_recents': 'Recenti',
      'library_no_books': 'Nessun libro disponibile',
      'library_retry': 'Riprova',

      // Dashboard
      'books_read': 'Libri Letti',
      'favorite_books': 'Libri Preferiti',
      'reading_streak': 'Serie di Lettura',
      'saved_words': 'Parole Salvate',
      'achievements': 'Obiettivi',

      // Study
      'study_progress': 'Progresso Studio',
      'total_words': 'parole totali',
      'start_studying': 'Inizia a Studiare',
      'word_status_new': 'Nuovo',
      'word_status_learning': 'In corso',
      'word_status_learned': 'Imparato',
      'dashboard_study_words': 'Studia Parole',
      'dashboard_select_language_to_study': 'Seleziona lingua da studiare',
      'common_all_languages': 'Tutte le Lingue',
      'language_english': 'Inglese',
      'language_french': 'Francese',
      'language_spanish': 'Spagnolo',
      'language_italian': 'Italiano',
      'language_german': 'Tedesco',
      'language_japanese': 'Giapponese',
      'study_tips': 'Consigli di Studio',
      'regular_practice': 'Pratica Regolare',
      'regular_practice_desc': 'Pratica regolarmente per mantenere e migliorare il tuo vocabolario',
      'spaced_repetition': 'Ripetizione Spaziata',
      'spaced_repetition_desc': 'Rivedi le parole a intervalli crescenti per migliorare la memorizzazione',
      'context_learning': 'Apprendimento Contestuale',
      'context_learning_desc': 'Impara le parole nel contesto per capire meglio il loro uso',
      'tap_to_see_definition': 'Tocca per vedere la definizione',
      'tap_to_see_word': 'Tocca per vedere la parola',
      'definition': 'Definizione',
      'examples': 'Esempi',
      'flashcard_error_update': 'Errore nell\'aggiornamento della parola',
      'flashcard_study_session': 'Sessione di Studio',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Buono',
      'flashcard_difficulty_easy': 'Facile',
      'no_saved_words_language_message': 'Nessuna parola salvata in questa lingua',
      'no_saved_words_message': 'Nessuna parola salvata',
      'saved_words_title': 'Parole Salvate',
      'meanings': 'Significati:',
      'common_definition': 'Definizione',

      // Badges
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzato',
      'badge_master': 'Maestro',
      'badge_explorer': 'Esploratore',
      'badge_voyager': 'Viaggiatore',
      'badge_weaver': 'Tessitore',
      'badge_navigator': 'Navigatore',
      'badge_pioneer': 'Pioniere',
      'badge_royalty': 'Regalità',
      'badge_baron': 'Barone',
      'badge_legend': 'Leggenda',
      'badge_wizard': 'Mago',
      'badge_epic': 'Epico',
      'badge_titan': 'Titano',
      'badge_sovereign': 'Sovrano',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminare',
      'badge_beacon': 'Faro',
      'badge_radiant': 'Radiante',
      'badge_lighthouse': 'Faro',
      'badge_infinite': 'Infinito',
      'badge_renaissance': 'Rinascimento',
      'badge_ultimate': 'Supremo',
      'requirements': 'Requisiti',
      'books_read_requirement': '{0} libri letti richiesti',
      'favorite_books_requirement': '{0} libri preferiti richiesti',
      'reading_streak_requirement': '{0} giorni di lettura consecutivi richiesti',
      'privacy_policy_content': '''
Benvenuto su Keyra! Questa Informativa sulla Privacy spiega come raccogliamo, utilizziamo e proteggiamo le tue informazioni personali.

1. Informazioni Raccolte
- Informazioni account (email, nome)
- Progressi di lettura e preferenze
- Statistiche di studio e parole salvate
- Informazioni dispositivo

2. Utilizzo delle Informazioni
- Per fornire esperienza personalizzata
- Per migliorare i nostri servizi
- Per inviare aggiornamenti importanti

3. Protezione Dati
Implementiamo misure di sicurezza per proteggere le tue informazioni.

4. I Tuoi Diritti
Hai il diritto di:
- Accedere ai tuoi dati
- Richiedere correzioni
- Eliminare l'account
- Rifiutare comunicazioni

5. Contattaci
Per domande, contattaci tramite l'app.
''',
      'terms_of_service_content': '''
Termini di Servizio

1. Accettazione dei Termini
Usando Keyra, accetti questi termini.

2. Account Utente
- Responsabile della sicurezza
- Fornire informazioni accurate
- Un account per utente

3. Uso Accettabile
- Solo uso personale
- Non condividere accesso
- Non abusare del servizio

4. Contenuti
- Possediamo contenuti dell'app
- Tu possiedi i tuoi dati
- Rispettare copyright

5. Terminazione
Possiamo sospendere account violatori.

6. Modifiche
Possiamo aggiornare questi termini.

7. Disclaimer
Servizio fornito "così com'è".
''',
    },
    'de': {
      // Settings & Profile
      'settings': 'Einstellungen',
      'app_colors': 'App-Farben',
      'information': 'Informationen',
      'version': 'Version',
      'notifications': 'Benachrichtigungen',
      'app_language': 'App-Sprache',
      'gradient_theme_enabled': 'Verwendung von Farbverlaufsthema',
      'dark_mode': 'Dunkelmodus',
      'dark_mode_disabled': 'Der Dunkelmodus ist deaktiviert, wenn App-Farben aktiviert sind',
      'privacy_policy': 'Datenschutzerklärung',
      'terms_of_service': 'Nutzungsbedingungen',
      'developer': 'Entwickler',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'Kontakt',
      'socials': 'Soziale Medien',
      'chat_with_friends': 'Mit Freunden chatten',
      'improve_language_skills': 'Verbessere deine Sprachkenntnisse',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Entdecke Lerntipps',
      'tiktok': 'TikTok',
      'fun_language_content': 'Spaßige Sprachinhalte',
      'logout': 'Abmelden',
      'logout_confirm': 'Möchten Sie sich wirklich abmelden?',
      'cancel': 'Abbrechen',

      // Navigation
      'nav_home': 'Start',
      'nav_library': 'Bibliothek',
      'nav_study': 'Lernen',
      'nav_dashboard': 'Dashboard',

      // Home
      'home_error_load_books': 'Fehler beim Laden der Bücher',
      'home_error_favorite': 'Fehler beim Aktualisieren des Favoritenstatus',
      'home_recently_added_stories': 'Kürzlich hinzugefügte Geschichten',
      'home_continue_reading': 'Weiterlesen',
      'home_page_progress': 'Fortschritt',
      'home_no_in_progress_books': 'Noch keine Bücher in Bearbeitung. Beginne eine Geschichte zu lesen, um sie hier zu sehen!',

      // Library
      'library_search_books': 'Bücher suchen',
      'library_filter_all': 'Alle',
      'library_filter_favorites': 'Favoriten',
      'library_filter_recents': 'Kürzlich',
      'library_no_books': 'Keine Bücher verfügbar',
      'library_retry': 'Wiederholen',

      // Dashboard
      'books_read': 'Gelesene Bücher',
      'favorite_books': 'Lieblingsbücher',
      'reading_streak': 'Lesefolge',
      'saved_words': 'Gespeicherte Wörter',
      'achievements': 'Erfolge',

      // Study
      'study_progress': 'Lernfortschritt',
      'total_words': 'Wörter insgesamt',
      'start_studying': 'Lernen beginnen',
      'word_status_new': 'Neu',
      'word_status_learning': 'Lernend',
      'word_status_learned': 'Gelernt',
      'dashboard_study_words': 'Wörter lernen',
      'dashboard_select_language_to_study': 'Sprache zum Lernen auswählen',
      'common_all_languages': 'Alle Sprachen',
      'language_english': 'Englisch',
      'language_french': 'Französisch',
      'language_spanish': 'Spanisch',
      'language_italian': 'Italienisch',
      'language_german': 'Deutsch',
      'language_japanese': 'Japanisch',
      'study_tips': 'Lerntipps',
      'regular_practice': 'Regelmäßiges Üben',
      'regular_practice_desc': 'Übe regelmäßig, um deinen Wortschatz zu erhalten und zu verbessern',
      'spaced_repetition': 'Verteiltes Lernen',
      'spaced_repetition_desc': 'Wiederhole Wörter in zunehmenden Abständen für bessere Merkfähigkeit',
      'context_learning': 'Kontextlernen',
      'context_learning_desc': 'Lerne Wörter im Kontext, um ihre Verwendung besser zu verstehen',
      'tap_to_see_definition': 'Tippen für Definition',
      'tap_to_see_word': 'Tippen für Wort',
      'definition': 'Definition',
      'examples': 'Beispiele',
      'flashcard_error_update': 'Fehler beim Aktualisieren des Wortes',
      'flashcard_study_session': 'Lernsitzung',
      'flashcard_difficulty_hard': 'Schwer',
      'flashcard_difficulty_good': 'Gut',
      'flashcard_difficulty_easy': 'Einfach',
      'no_saved_words_language_message': 'Noch keine gespeicherten Wörter in dieser Sprache',
      'no_saved_words_message': 'Noch keine gespeicherten Wörter',
      'saved_words_title': 'Gespeicherte Wörter',
      'meanings': 'Bedeutungen:',
      'common_definition': 'Definition',

      // Badges
      'badge_beginner': 'Anfänger',
      'badge_intermediate': 'Fortgeschritten',
      'badge_advanced': 'Experte',
      'badge_master': 'Meister',
      'badge_explorer': 'Entdecker',
      'badge_voyager': 'Reisender',
      'badge_weaver': 'Weber',
      'badge_navigator': 'Navigator',
      'badge_pioneer': 'Pionier',
      'badge_royalty': 'Königlich',
      'badge_baron': 'Baron',
      'badge_legend': 'Legende',
      'badge_wizard': 'Zauberer',
      'badge_epic': 'Episch',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Souverän',
      'badge_virtuoso': 'Virtuose',
      'badge_luminary': 'Leuchtend',
      'badge_beacon': 'Leuchtfeuer',
      'badge_radiant': 'Strahlend',
      'badge_lighthouse': 'Leuchtturm',
      'badge_infinite': 'Unendlich',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultimate',
      'requirements': 'Anforderungen',
      'books_read_requirement': '{0} gelesene Bücher erforderlich',
      'favorite_books_requirement': '{0} Lieblingsbücher erforderlich',
      'reading_streak_requirement': '{0} Tage Lesefolge erforderlich',
      'privacy_policy_content': '''
Willkommen bei Keyra! Diese Datenschutzerklärung erläutert, wie wir Ihre persönlichen Daten sammeln, nutzen und schützen.

1. Gesammelte Informationen
- Kontoinformationen (E-Mail, Name)
- Lesefortschritt und Präferenzen
- Lernstatistiken und gespeicherte Wörter
- Geräteinformationen

2. Verwendung der Daten
- Für personalisiertes Lernen
- Zur Verbesserung unserer Dienste
- Für wichtige Updates

3. Datenschutz
Wir implementieren Sicherheitsmaßnahmen zum Schutz Ihrer Daten.

4. Ihre Rechte
Sie haben das Recht:
- Auf Datenzugriff
- Korrekturen anzufordern
- Konto zu löschen
- Kommunikation abzulehnen

5. Kontakt
Bei Fragen kontaktieren Sie uns über die App.
''',
      'terms_of_service_content': '''
Nutzungsbedingungen

1. Annahme der Bedingungen
Mit Nutzung von Keyra akzeptieren Sie diese.

2. Benutzerkonto
- Verantwortlich für Sicherheit
- Korrekte Informationen angeben
- Ein Konto pro Benutzer

3. Akzeptable Nutzung
- Nur persönliche Nutzung
- Keine Zugangsweitergabe
- Kein Missbrauch

4. Inhalte
- App-Inhalte gehören uns
- Ihre Daten gehören Ihnen
- Urheberrecht beachten

5. Kündigung
Wir können Konten bei Verstößen sperren.

6. Änderungen
Bedingungen können aktualisiert werden.

7. Haftungsausschluss
Dienst "wie besehen" ohne Garantien.
''',
    },
    'ja': {
      // Settings & Profile
      'settings': '設定',
      'app_colors': 'アプリの色',
      'information': '情報',
      'version': 'バージョン',
      'notifications': '通知',
      'app_language': 'アプリの言語',
      'gradient_theme_enabled': 'グラデーションテーマカラーを使用中',
      'dark_mode': 'ダークモード',
      'dark_mode_disabled': 'アプリの色が有効な場合、ダークモードは無効になります',
      'privacy_policy': 'プライバシーポリシー',
      'terms_of_service': '利用規約',
      'developer': '開発者',
      'developer_name': 'Emmanuel Fabiani',
      'contact_us': 'お問い合わせ',
      'socials': 'ソーシャル',
      'chat_with_friends': '友達とチャット',
      'improve_language_skills': '語学力を向上させる',
      'instagram': 'Instagram',
      'discover_learning_tips': '学習のヒントを見つける',
      'tiktok': 'TikTok',
      'fun_language_content': '楽しい言語コンテンツ',
      'logout': 'ログアウト',
      'logout_confirm': 'ログアウトしてもよろしいですか？',
      'cancel': 'キャンセル',

      // Navigation
      'nav_home': 'ホーム',
      'nav_library': 'ライブラリ',
      'nav_study': '学習',
      'nav_dashboard': 'ダッシュボード',

      // Home
      'home_error_load_books': '本の読み込み中にエラーが発生しました',
      'home_error_favorite': 'お気に入りの更新中にエラーが発生しました',
      'home_recently_added_stories': '最近追加されたストーリー',
      'home_continue_reading': '読み続ける',
      'home_page_progress': '進捗',
      'home_no_in_progress_books': '進行中の本はまだありません。ストーリーを読み始めるとここに表示されます！',

      // Library
      'library_search_books': '本を検索',
      'library_filter_all': 'すべて',
      'library_filter_favorites': 'お気に入り',
      'library_filter_recents': '最近',
      'library_no_books': '利用可能な本がありません',
      'library_retry': '再試行',

      // Dashboard
      'books_read': '読んだ本',
      'favorite_books': 'お気に入りの本',
      'reading_streak': '読書の連続日数',
      'saved_words': '保存した単語',
      'achievements': '達成',

      // Study
      'study_progress': '学習の進捗',
      'total_words': '合計単語数',
      'start_studying': '学習を開始',
      'word_status_new': '新規',
      'word_status_learning': '学習中',
      'word_status_learned': '習得済み',
      'dashboard_study_words': '単語を学習',
      'dashboard_select_language_to_study': '学習する言語を選択',
      'common_all_languages': 'すべての言語',
      'language_english': '英語',
      'language_french': 'フランス語',
      'language_spanish': 'スペイン語',
      'language_italian': 'イタリア語',
      'language_german': 'ドイツ語',
      'language_japanese': '日本語',
      'study_tips': '学習のヒント',
      'regular_practice': '定期的な練習',
      'regular_practice_desc': '語彙力を維持・向上させるため定期的に練習しましょう',
      'spaced_repetition': '間隔をあけた復習',
      'spaced_repetition_desc': '記憶力を高めるため、徐々に間隔を広げて単語を復習します',
      'context_learning': '文脈での学習',
      'context_learning_desc': '使い方をよりよく理解するため、文脈の中で単語を学びます',
      'tap_to_see_definition': 'タップして定義を表示',
      'tap_to_see_word': 'タップして単語を表示',
      'definition': '定義',
      'examples': '例文',
      'flashcard_error_update': '単語の更新エラー',
      'flashcard_study_session': '学習セッション',
      'flashcard_difficulty_hard': '難しい',
      'flashcard_difficulty_good': '良い',
      'flashcard_difficulty_easy': '簡単',
      'no_saved_words_language_message': 'この言語にはまだ保存された単語がありません',
      'no_saved_words_message': 'まだ保存された単語がありません',
      'saved_words_title': '保存した単語',
      'meanings': '意味：',
      'common_definition': '定義',

      // Badges
      'badge_beginner': '初心者',
      'badge_intermediate': '中級者',
      'badge_advanced': '上級者',
      'badge_master': 'マスター',
      'badge_explorer': '探検家',
      'badge_voyager': '航海者',
      'badge_weaver': '織り手',
      'badge_navigator': 'ナビゲーター',
      'badge_pioneer': '開拓者',
      'badge_royalty': '王族',
      'badge_baron': '男爵',
      'badge_legend': '伝説',
      'badge_wizard': '魔法使い',
      'badge_epic': '叙事詩',
      'badge_titan': 'タイタン',
      'badge_sovereign': '主権者',
      'badge_virtuoso': '達人',
      'badge_luminary': '輝く者',
      'badge_beacon': '灯台',
      'badge_radiant': '光輝く',
      'badge_lighthouse': '灯台',
      'badge_infinite': '無限',
      'badge_renaissance': 'ルネサンス',
      'badge_ultimate': 'アルティメット',
      'requirements': '要件',
      'books_read_requirement': '{0}冊の本を読む必要があります',
      'favorite_books_requirement': '{0}冊のお気に入りの本が必要です',
      'reading_streak_requirement': '{0}日間の連続読書が必要です',
      'privacy_policy_content': '''
Keyraへようこそ！このプライバシーポリシーでは、個人情報の収集、使用、保護方法について説明します。

1. 収集する情報
- アカウント情報（メール、名前）
- 読書の進捗と設定
- 学習統計と保存した単語
- デバイス情報

2. 情報の使用方法
- パーソナライズされた学習体験の提供
- サービスの改善
- 重要な更新の送信

3. データ保護
個人情報を保護するためのセキュリティ対策を実施しています。

4. あなたの権利
次の権利があります：
- 個人データへのアクセス
- 訂正の要求
- アカウントの削除
- 通信のオプトアウト

5. お問い合わせ
ご質問はアプリ内でお問い合わせください。
''',
      'terms_of_service_content': '''
利用規約

1. 規約の同意
Keyraを使用することで、この規約に同意したことになります。

2. ユーザーアカウント
- セキュリティの責任
- 正確な情報の提供
- 1人1アカウント

3. 適切な使用
- 個人学習のみ
- アクセス共有禁止
- サービスの悪用禁止

4. コンテンツ
- アプリのコンテンツは当社所有
- 個人データはユーザー所有
- 著作権法の遵守

5. 利用停止
規約違反でアカウント停止の可能性。

6. 規約の変更
規約は更新される場合があります。

7. 免責事項
サービスは「現状のまま」提供。
''',
    }
  };
}
