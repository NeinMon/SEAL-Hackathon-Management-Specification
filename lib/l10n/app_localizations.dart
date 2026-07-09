import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi'),
  ];

  /// No description provided for @sessionBootstrapMessage.
  ///
  /// In en, this message translates to:
  /// **'Restoring sign-in session...'**
  String get sessionBootstrapMessage;

  /// No description provided for @statusRegistrationClosing.
  ///
  /// In en, this message translates to:
  /// **'Registration closing soon'**
  String get statusRegistrationClosing;

  /// No description provided for @statusJudging.
  ///
  /// In en, this message translates to:
  /// **'Judging in progress'**
  String get statusJudging;

  /// No description provided for @allEventsFilter.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get allEventsFilter;

  /// No description provided for @myTeamReadyBadge.
  ///
  /// In en, this message translates to:
  /// **'On a team'**
  String get myTeamReadyBadge;

  /// No description provided for @myTeamPendingBadge.
  ///
  /// In en, this message translates to:
  /// **'No team yet'**
  String get myTeamPendingBadge;

  /// No description provided for @weightedScoreHint.
  ///
  /// In en, this message translates to:
  /// **'Displayed score is a weighted rubric average saved to the system.'**
  String get weightedScoreHint;

  /// No description provided for @scorePublishedWithHintSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Scores published. Participants will be notified in their inbox.'**
  String get scorePublishedWithHintSnackBar;

  /// No description provided for @demoResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get demoResetTitle;

  /// No description provided for @demoResetDescription.
  ///
  /// In en, this message translates to:
  /// **'Deletes all users, events, teams, submissions and scores in the current environment. Demo local only.'**
  String get demoResetDescription;

  /// No description provided for @demoResetConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Type RESET to confirm'**
  String get demoResetConfirmLabel;

  /// No description provided for @demoResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Demo data reset.'**
  String get demoResetSuccess;

  /// No description provided for @eventSupportHotline.
  ///
  /// In en, this message translates to:
  /// **'Contact organizers via Chat or notifications'**
  String get eventSupportHotline;

  /// No description provided for @demoOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick demo guide'**
  String get demoOnboardingTitle;

  /// No description provided for @demoOnboardingStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start demo'**
  String get demoOnboardingStartButton;

  /// No description provided for @demoOnboardingParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get demoOnboardingParticipantTitle;

  /// No description provided for @demoOnboardingParticipantBody.
  ///
  /// In en, this message translates to:
  /// **'Event → Team → Submit. Use a demo account if the environment is seeded.'**
  String get demoOnboardingParticipantBody;

  /// No description provided for @demoOnboardingJudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Judge'**
  String get demoOnboardingJudgeTitle;

  /// No description provided for @demoOnboardingJudgeBody.
  ///
  /// In en, this message translates to:
  /// **'Scoring tab → pick a submission → enter criteria and feedback → Submit score.'**
  String get demoOnboardingJudgeBody;

  /// No description provided for @demoOnboardingAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get demoOnboardingAlertsTitle;

  /// No description provided for @demoOnboardingAlertsBody.
  ///
  /// In en, this message translates to:
  /// **'Bell icon top-right. Tap a score notification to view details.'**
  String get demoOnboardingAlertsBody;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SEAL Hackathon'**
  String get appName;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @stayButton.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stayButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @detailsButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @inviteButton.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteButton;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @unknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// No description provided for @leaderBadge.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get leaderBadge;

  /// No description provided for @meLabel.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meLabel;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusActive;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @filterRegistrationOpen.
  ///
  /// In en, this message translates to:
  /// **'Registration open'**
  String get filterRegistrationOpen;

  /// No description provided for @networkOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Check your connection and try again.'**
  String get networkOfflineMessage;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to server'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownError;

  /// No description provided for @accessDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDeniedTitle;

  /// No description provided for @accessDeniedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available for your role.'**
  String get accessDeniedSubtitle;

  /// No description provided for @accessDeniedDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with an appropriate account.'**
  String get accessDeniedDefaultMessage;

  /// No description provided for @backToEventsButton.
  ///
  /// In en, this message translates to:
  /// **'Back to events'**
  String get backToEventsButton;

  /// No description provided for @loginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in'**
  String get loginRequiredTitle;

  /// No description provided for @loginRequiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue using SEAL Hackathon.'**
  String get loginRequiredSubtitle;

  /// No description provided for @goToLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Go to sign in'**
  String get goToLoginButton;

  /// No description provided for @supabaseRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to system'**
  String get supabaseRequiredTitle;

  /// No description provided for @supabaseRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'The app is not ready to load data. Try again later or contact organizers.'**
  String get supabaseRequiredBody;

  /// No description provided for @notLoggedInMessage.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in.'**
  String get notLoggedInMessage;

  /// No description provided for @logoutFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not sign out. Try again.'**
  String get logoutFailedMessage;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully'**
  String get saveSuccess;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updateSuccess;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @roleParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get roleParticipant;

  /// No description provided for @roleJudge.
  ///
  /// In en, this message translates to:
  /// **'Judge'**
  String get roleJudge;

  /// No description provided for @roleMentor.
  ///
  /// In en, this message translates to:
  /// **'Mentor'**
  String get roleMentor;

  /// No description provided for @roleOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get roleOrganizer;

  /// No description provided for @eventsNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsNavLabel;

  /// No description provided for @myHomeNavLabel.
  ///
  /// In en, this message translates to:
  /// **'My home'**
  String get myHomeNavLabel;

  /// No description provided for @teamNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamNavLabel;

  /// No description provided for @submitNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitNavLabel;

  /// No description provided for @judgeNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get judgeNavLabel;

  /// No description provided for @dashboardNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardNavLabel;

  /// No description provided for @chatNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatNavLabel;

  /// No description provided for @mapNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapNavLabel;

  /// No description provided for @eventSubNavOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get eventSubNavOverview;

  /// No description provided for @eventScopedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active event'**
  String get eventScopedSubtitle;

  /// No description provided for @backToEventsAction.
  ///
  /// In en, this message translates to:
  /// **'Back to My home'**
  String get backToEventsAction;

  /// No description provided for @backToEventListAction.
  ///
  /// In en, this message translates to:
  /// **'Back to event list'**
  String get backToEventListAction;

  /// No description provided for @profileNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileNavLabel;

  /// No description provided for @notificationsNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsNavLabel;

  /// No description provided for @accountMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountMenuTooltip;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutButton;

  /// No description provided for @helpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTooltip;

  /// No description provided for @helpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get helpDialogTitle;

  /// No description provided for @helpDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Contact organizers at the support desk or send a message in Chat.'**
  String get helpDialogBody;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get verifyEmailTitle;

  /// No description provided for @loginHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage events, teams, submissions, scoring, messages and venue in one mobile app.'**
  String get loginHeroSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @universityLabel.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get universityLabel;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP code (6 digits)'**
  String get otpLabel;

  /// No description provided for @registerRoleHint.
  ///
  /// In en, this message translates to:
  /// **'New accounts are created as Participant. Verify email with OTP or link after sign-up.'**
  String get registerRoleHint;

  /// No description provided for @roleManagedHint.
  ///
  /// In en, this message translates to:
  /// **'Role is managed on your account profile.'**
  String get roleManagedHint;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordButton;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePasswordTooltip;

  /// No description provided for @showPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPasswordTooltip;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @confirmOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm OTP'**
  String get confirmOtpButton;

  /// No description provided for @backToLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToLoginButton;

  /// No description provided for @haveAccountButton.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get haveAccountButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createAccountButton;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginFailed;

  /// No description provided for @emailConfirmedWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Email confirmed. Welcome back!'**
  String get emailConfirmedWelcomeBack;

  /// No description provided for @noPendingVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'No email pending verification.'**
  String get noPendingVerificationEmail;

  /// No description provided for @registerSuccessPrefix.
  ///
  /// In en, this message translates to:
  /// **'Registration successful with'**
  String get registerSuccessPrefix;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @participantHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your events'**
  String get participantHomeTitle;

  /// No description provided for @participantHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap an event below to start — or continue from the progress card.'**
  String get participantHomeSubtitle;

  /// No description provided for @participantPickEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick an event to start'**
  String get participantPickEventTitle;

  /// No description provided for @participantPickEventBody.
  ///
  /// In en, this message translates to:
  /// **'You are not on a team yet. Tap an event in the list to view details and register.'**
  String get participantPickEventBody;

  /// No description provided for @judgeEventListHint.
  ///
  /// In en, this message translates to:
  /// **'Tap an open event to open the scoring queue.'**
  String get judgeEventListHint;

  /// No description provided for @mentorEventListHint.
  ///
  /// In en, this message translates to:
  /// **'Tap an assigned event to open chat with participants.'**
  String get mentorEventListHint;

  /// No description provided for @allEventsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get allEventsSectionTitle;

  /// No description provided for @journeyStepNeedsTeam.
  ///
  /// In en, this message translates to:
  /// **'No team yet'**
  String get journeyStepNeedsTeam;

  /// No description provided for @journeyStepNeedsSubmission.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get journeyStepNeedsSubmission;

  /// No description provided for @journeyStepAwaitingScore.
  ///
  /// In en, this message translates to:
  /// **'Awaiting score'**
  String get journeyStepAwaitingScore;

  /// No description provided for @journeyStepHasScore.
  ///
  /// In en, this message translates to:
  /// **'Scored'**
  String get journeyStepHasScore;

  /// No description provided for @journeyStepRegistrationClosed.
  ///
  /// In en, this message translates to:
  /// **'Registration closed'**
  String get journeyStepRegistrationClosed;

  /// No description provided for @journeyStepMissedSubmission.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline passed'**
  String get journeyStepMissedSubmission;

  /// No description provided for @journeyNextStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get journeyNextStepTitle;

  /// No description provided for @journeyActionJoinTeam.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team'**
  String get journeyActionJoinTeam;

  /// No description provided for @journeyActionBrowseEvents.
  ///
  /// In en, this message translates to:
  /// **'Browse other events'**
  String get journeyActionBrowseEvents;

  /// No description provided for @journeyActionContactOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Contact organizers'**
  String get journeyActionContactOrganizer;

  /// No description provided for @journeyActionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit now'**
  String get journeyActionSubmit;

  /// No description provided for @journeyActionViewSubmission.
  ///
  /// In en, this message translates to:
  /// **'View submission'**
  String get journeyActionViewSubmission;

  /// No description provided for @journeyActionViewScore.
  ///
  /// In en, this message translates to:
  /// **'View score'**
  String get journeyActionViewScore;

  /// No description provided for @journeyActionOpenMap.
  ///
  /// In en, this message translates to:
  /// **'View venue'**
  String get journeyActionOpenMap;

  /// No description provided for @journeyHelperRegistrationClosed.
  ///
  /// In en, this message translates to:
  /// **'Team registration is closed. Browse other events or contact organizers.'**
  String get journeyHelperRegistrationClosed;

  /// No description provided for @journeyHelperMissedSubmission.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline passed. Contact organizers if you need help.'**
  String get journeyHelperMissedSubmission;

  /// No description provided for @submissionReadOnlyScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring result'**
  String get submissionReadOnlyScoreTitle;

  /// No description provided for @notificationActionGoTeams.
  ///
  /// In en, this message translates to:
  /// **'Go to Teams'**
  String get notificationActionGoTeams;

  /// No description provided for @notificationActionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get notificationActionSubmit;

  /// No description provided for @notificationActionViewScore.
  ///
  /// In en, this message translates to:
  /// **'View score'**
  String get notificationActionViewScore;

  /// No description provided for @notificationActionViewEvent.
  ///
  /// In en, this message translates to:
  /// **'View event'**
  String get notificationActionViewEvent;

  /// No description provided for @notificationActionOpenJudge.
  ///
  /// In en, this message translates to:
  /// **'Open scoring'**
  String get notificationActionOpenJudge;

  /// No description provided for @submissionDraftAutoSaving.
  ///
  /// In en, this message translates to:
  /// **'Auto-saving draft'**
  String get submissionDraftAutoSaving;

  /// No description provided for @clearDraftButton.
  ///
  /// In en, this message translates to:
  /// **'Clear draft'**
  String get clearDraftButton;

  /// No description provided for @draftClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Draft cleared.'**
  String get draftClearedMessage;

  /// No description provided for @submitWizardStepTeam.
  ///
  /// In en, this message translates to:
  /// **'Choose team'**
  String get submitWizardStepTeam;

  /// No description provided for @submitWizardStepProject.
  ///
  /// In en, this message translates to:
  /// **'Project info'**
  String get submitWizardStepProject;

  /// No description provided for @submitWizardStepLinks.
  ///
  /// In en, this message translates to:
  /// **'Links & submit'**
  String get submitWizardStepLinks;

  /// No description provided for @submitWizardNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get submitWizardNext;

  /// No description provided for @submitWizardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get submitWizardBack;

  /// No description provided for @submitWizardReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review before submit'**
  String get submitWizardReviewTitle;

  /// No description provided for @organizerTodayModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get organizerTodayModeTitle;

  /// No description provided for @organizerShowDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get organizerShowDetailsButton;

  /// No description provided for @organizerHideDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get organizerHideDetailsButton;

  /// No description provided for @roleOnboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get roleOnboardingSkip;

  /// No description provided for @roleOnboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get roleOnboardingStart;

  /// No description provided for @roleOnboardingParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome participant'**
  String get roleOnboardingParticipantTitle;

  /// No description provided for @roleOnboardingParticipantBody.
  ///
  /// In en, this message translates to:
  /// **'Tap an event to start → create or accept a team invite → submit before the deadline.'**
  String get roleOnboardingParticipantBody;

  /// No description provided for @roleOnboardingJudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome judge'**
  String get roleOnboardingJudgeTitle;

  /// No description provided for @roleOnboardingJudgeBody.
  ///
  /// In en, this message translates to:
  /// **'Pick an open event → Scoring tab → select unscored submissions.'**
  String get roleOnboardingJudgeBody;

  /// No description provided for @roleOnboardingOrganizerTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome organizer'**
  String get roleOnboardingOrganizerTitle;

  /// No description provided for @roleOnboardingOrganizerBody.
  ///
  /// In en, this message translates to:
  /// **'Track unscored work, assign mentors and send announcements from Today.'**
  String get roleOnboardingOrganizerBody;

  /// No description provided for @roleOnboardingMentorTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome mentor'**
  String get roleOnboardingMentorTitle;

  /// No description provided for @roleOnboardingMentorBody.
  ///
  /// In en, this message translates to:
  /// **'Pick your assigned event → open Chat to reply to participants.'**
  String get roleOnboardingMentorBody;

  /// No description provided for @chatMentorRequestTemplate.
  ///
  /// In en, this message translates to:
  /// **'Hello organizers, I need a mentor assigned for my current event.'**
  String get chatMentorRequestTemplate;

  /// No description provided for @eventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track hackathons, deadlines and details.'**
  String get eventsSubtitle;

  /// No description provided for @eventSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, location or topic'**
  String get eventSearchHint;

  /// No description provided for @sortStartAsc.
  ///
  /// In en, this message translates to:
  /// **'Start date: earliest'**
  String get sortStartAsc;

  /// No description provided for @sortStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Start date: latest'**
  String get sortStartDesc;

  /// No description provided for @sortTitleAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A → Z'**
  String get sortTitleAsc;

  /// No description provided for @sortTitleDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z → A'**
  String get sortTitleDesc;

  /// No description provided for @sortDeadlineAsc.
  ///
  /// In en, this message translates to:
  /// **'Deadline: soonest'**
  String get sortDeadlineAsc;

  /// No description provided for @sortDeadlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Deadline: latest'**
  String get sortDeadlineDesc;

  /// No description provided for @noMatchingEvents.
  ///
  /// In en, this message translates to:
  /// **'No matching events.'**
  String get noMatchingEvents;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get noEventsYet;

  /// No description provided for @eventQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get eventQuickActionsTitle;

  /// No description provided for @clearSearchAction.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchAction;

  /// No description provided for @reloadEventsAction.
  ///
  /// In en, this message translates to:
  /// **'Reload events'**
  String get reloadEventsAction;

  /// No description provided for @registerTeamPill.
  ///
  /// In en, this message translates to:
  /// **'Register team'**
  String get registerTeamPill;

  /// No description provided for @registrationClosedPill.
  ///
  /// In en, this message translates to:
  /// **'Registration closed'**
  String get registrationClosedPill;

  /// No description provided for @eventDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Event details'**
  String get eventDetailTitle;

  /// No description provided for @eventDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline, rules, venue and leaderboard.'**
  String get eventDetailSubtitle;

  /// No description provided for @eventDetailLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Loading event data.'**
  String get eventDetailLoadingSubtitle;

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found.'**
  String get eventNotFound;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @prizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Prizes'**
  String get prizeTitle;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// No description provided for @noScoredSubmissionsYet.
  ///
  /// In en, this message translates to:
  /// **'No scored submissions yet.'**
  String get noScoredSubmissionsYet;

  /// No description provided for @noSubmissionsForEventYet.
  ///
  /// In en, this message translates to:
  /// **'No submissions for this event yet.'**
  String get noSubmissionsForEventYet;

  /// No description provided for @eventDetailStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Event stats'**
  String get eventDetailStatsTitle;

  /// No description provided for @eventTeamsMetric.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get eventTeamsMetric;

  /// No description provided for @eventSubmissionsMetric.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get eventSubmissionsMetric;

  /// No description provided for @eventUnscoredMetric.
  ///
  /// In en, this message translates to:
  /// **'Unscored'**
  String get eventUnscoredMetric;

  /// No description provided for @organizerShowAllEventsButton.
  ///
  /// In en, this message translates to:
  /// **'Show all events'**
  String get organizerShowAllEventsButton;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @timelineRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get timelineRegistration;

  /// No description provided for @timelineKickoff.
  ///
  /// In en, this message translates to:
  /// **'Kickoff'**
  String get timelineKickoff;

  /// No description provided for @timelineFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get timelineFinal;

  /// No description provided for @openJudgeQueueButton.
  ///
  /// In en, this message translates to:
  /// **'View unscored'**
  String get openJudgeQueueButton;

  /// No description provided for @openOrganizerDashboardButton.
  ///
  /// In en, this message translates to:
  /// **'Open organizer dashboard'**
  String get openOrganizerDashboardButton;

  /// No description provided for @openMentorChatButton.
  ///
  /// In en, this message translates to:
  /// **'Open mentor chat'**
  String get openMentorChatButton;

  /// No description provided for @manageTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Create or manage team'**
  String get manageTeamButton;

  /// No description provided for @viewMyTeamButton.
  ///
  /// In en, this message translates to:
  /// **'View my team'**
  String get viewMyTeamButton;

  /// No description provided for @joinOrCreateTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Create or join team'**
  String get joinOrCreateTeamButton;

  /// No description provided for @submitForEventButton.
  ///
  /// In en, this message translates to:
  /// **'Submit for this event'**
  String get submitForEventButton;

  /// No description provided for @myTeamForEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Your team'**
  String get myTeamForEventTitle;

  /// No description provided for @leaderboardPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Unscored'**
  String get leaderboardPendingTitle;

  /// No description provided for @awaitingScoreBadge.
  ///
  /// In en, this message translates to:
  /// **'Awaiting score'**
  String get awaitingScoreBadge;

  /// No description provided for @judgeQueueFilteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unscored submissions for the selected event.'**
  String get judgeQueueFilteredSubtitle;

  /// No description provided for @viewVenueButton.
  ///
  /// In en, this message translates to:
  /// **'View venue'**
  String get viewVenueButton;

  /// No description provided for @eventCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event created.'**
  String get eventCreatedSuccess;

  /// No description provided for @eventUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event updated.'**
  String get eventUpdatedSuccess;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamTitle;

  /// No description provided for @teamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create teams, invite members and manage participation.'**
  String get teamSubtitle;

  /// No description provided for @teamOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Team overview'**
  String get teamOverviewTitle;

  /// No description provided for @noTeamsYet.
  ///
  /// In en, this message translates to:
  /// **'No teams yet'**
  String get noTeamsYet;

  /// No description provided for @teamsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available teams'**
  String get teamsAvailable;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInLabel;

  /// No description provided for @checkInPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get checkInPending;

  /// No description provided for @checkInConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get checkInConfirmed;

  /// No description provided for @submitProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitProjectButton;

  /// No description provided for @createTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get createTeamButton;

  /// No description provided for @createTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get createTeamTitle;

  /// No description provided for @eventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventLabel;

  /// No description provided for @teamNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamNameLabel;

  /// No description provided for @loadEventsBeforeCreateTeam.
  ///
  /// In en, this message translates to:
  /// **'No events loaded. Load events before creating a team.'**
  String get loadEventsBeforeCreateTeam;

  /// No description provided for @roleViewOnlyTeams.
  ///
  /// In en, this message translates to:
  /// **'This role can only view teams.'**
  String get roleViewOnlyTeams;

  /// No description provided for @emptyTeamsMessage.
  ///
  /// In en, this message translates to:
  /// **'No teams yet. Create a team to continue.'**
  String get emptyTeamsMessage;

  /// No description provided for @myTeamsGroup.
  ///
  /// In en, this message translates to:
  /// **'My teams'**
  String get myTeamsGroup;

  /// No description provided for @otherTeamsGroup.
  ///
  /// In en, this message translates to:
  /// **'Other teams'**
  String get otherTeamsGroup;

  /// No description provided for @teamFullBadge.
  ///
  /// In en, this message translates to:
  /// **'Team full'**
  String get teamFullBadge;

  /// No description provided for @updateTeamDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update team'**
  String get updateTeamDialogTitle;

  /// No description provided for @leaveTeamDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave team?'**
  String get leaveTeamDialogTitle;

  /// No description provided for @leaveTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Leave team'**
  String get leaveTeamButton;

  /// No description provided for @joinTeamButton.
  ///
  /// In en, this message translates to:
  /// **'Join team'**
  String get joinTeamButton;

  /// No description provided for @inviteMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get inviteMemberTitle;

  /// No description provided for @memberEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Member email'**
  String get memberEmailLabel;

  /// No description provided for @sendInvitationButton.
  ///
  /// In en, this message translates to:
  /// **'Send invitation'**
  String get sendInvitationButton;

  /// No description provided for @invitationSendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Sending invitation...'**
  String get invitationSendingStatus;

  /// No description provided for @teamInvitationTitle.
  ///
  /// In en, this message translates to:
  /// **'Team invitation'**
  String get teamInvitationTitle;

  /// No description provided for @teamCreatedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Team created'**
  String get teamCreatedNotificationTitle;

  /// No description provided for @teamCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Team created.'**
  String get teamCreatedSuccess;

  /// No description provided for @teamJoinedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined team.'**
  String get teamJoinedSuccess;

  /// No description provided for @invitationSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent.'**
  String get invitationSentSuccess;

  /// No description provided for @invitationAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined team.'**
  String get invitationAcceptedSuccess;

  /// No description provided for @invitationDeclinedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined.'**
  String get invitationDeclinedSuccess;

  /// No description provided for @pendingInvitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get pendingInvitationsTitle;

  /// No description provided for @pendingInvitationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No team invitations.'**
  String get pendingInvitationsEmpty;

  /// No description provided for @acceptInvitationButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptInvitationButton;

  /// No description provided for @declineInvitationButton.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineInvitationButton;

  /// No description provided for @invitationStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get invitationStatusPending;

  /// No description provided for @invitationStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get invitationStatusAccepted;

  /// No description provided for @invitationStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get invitationStatusDeclined;

  /// No description provided for @teamUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Team updated.'**
  String get teamUpdatedSuccess;

  /// No description provided for @teamLeftSuccess.
  ///
  /// In en, this message translates to:
  /// **'Left team.'**
  String get teamLeftSuccess;

  /// No description provided for @invalidTeamError.
  ///
  /// In en, this message translates to:
  /// **'Invalid team.'**
  String get invalidTeamError;

  /// No description provided for @inviteUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get inviteUserNotFound;

  /// No description provided for @invitationAlreadyPending.
  ///
  /// In en, this message translates to:
  /// **'This person already has a pending invite for the team.'**
  String get invitationAlreadyPending;

  /// No description provided for @alreadyTeamMemberError.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this team.'**
  String get alreadyTeamMemberError;

  /// No description provided for @alreadyOnEventTeamError.
  ///
  /// In en, this message translates to:
  /// **'You are already on another team for this event. Leave your current team before joining a new one.'**
  String get alreadyOnEventTeamError;

  /// No description provided for @oneTeamPerEventBadge.
  ///
  /// In en, this message translates to:
  /// **'Already on a team for event'**
  String get oneTeamPerEventBadge;

  /// No description provided for @cannotChangeOwnRole.
  ///
  /// In en, this message translates to:
  /// **'You cannot change your own role.'**
  String get cannotChangeOwnRole;

  /// No description provided for @leaveTeamRegistrationClosedError.
  ///
  /// In en, this message translates to:
  /// **'Cannot leave team after registration closes.'**
  String get leaveTeamRegistrationClosedError;

  /// No description provided for @invitationNoLongerPending.
  ///
  /// In en, this message translates to:
  /// **'This invitation is no longer valid.'**
  String get invitationNoLongerPending;

  /// No description provided for @errorEventContextRequired.
  ///
  /// In en, this message translates to:
  /// **'Could not determine event. Try again from the event screen.'**
  String get errorEventContextRequired;

  /// No description provided for @errorEventEnded.
  ///
  /// In en, this message translates to:
  /// **'Event ended. Cannot create or join teams.'**
  String get errorEventEnded;

  /// No description provided for @errorRegistrationDeadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Team registration deadline passed for this event.'**
  String get errorRegistrationDeadlinePassed;

  /// No description provided for @errorSubmissionClosed.
  ///
  /// In en, this message translates to:
  /// **'Event ended. Cannot submit or update.'**
  String get errorSubmissionClosed;

  /// No description provided for @errorSubmissionNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Event has not started. Cannot submit yet.'**
  String get errorSubmissionNotStarted;

  /// No description provided for @errorJudgingNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Event has not started. Cannot score yet.'**
  String get errorJudgingNotStarted;

  /// No description provided for @errorJudgingClosed.
  ///
  /// In en, this message translates to:
  /// **'Event ended. Cannot score.'**
  String get errorJudgingClosed;

  /// No description provided for @teamInviteOnlyError.
  ///
  /// In en, this message translates to:
  /// **'You can only join a team via leader invitation.'**
  String get teamInviteOnlyError;

  /// No description provided for @teamInviteOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Invite only'**
  String get teamInviteOnlyBadge;

  /// No description provided for @teamInviteOnlyHelper.
  ///
  /// In en, this message translates to:
  /// **'Contact the team leader for an invitation.'**
  String get teamInviteOnlyHelper;

  /// No description provided for @submissionsRoleGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Only participants can submit.'**
  String get submissionsRoleGateMessage;

  /// No description provided for @submitScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitScreenTitle;

  /// No description provided for @submitScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send GitHub link, demo video and project description for judges.'**
  String get submitScreenSubtitle;

  /// No description provided for @projectInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Project info'**
  String get projectInfoSection;

  /// No description provided for @linksSection.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get linksSection;

  /// No description provided for @descriptionSection.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionSection;

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectNameLabel;

  /// No description provided for @githubUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'GitHub link'**
  String get githubUrlLabel;

  /// No description provided for @demoVideoUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo video link'**
  String get demoVideoUrlLabel;

  /// No description provided for @projectDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What problem does the project solve?'**
  String get projectDescriptionHint;

  /// No description provided for @submissionDescriptionTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: problem, solution, key features, tech stack and measurable impact.'**
  String get submissionDescriptionTip;

  /// No description provided for @joinTeamBeforeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team before submitting.'**
  String get joinTeamBeforeSubmit;

  /// No description provided for @updateSubmissionButton.
  ///
  /// In en, this message translates to:
  /// **'Update submission'**
  String get updateSubmissionButton;

  /// No description provided for @submitProjectAction.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitProjectAction;

  /// No description provided for @needsSubmissionStatus.
  ///
  /// In en, this message translates to:
  /// **'Submission needed'**
  String get needsSubmissionStatus;

  /// No description provided for @noProjectSubmittedHelper.
  ///
  /// In en, this message translates to:
  /// **'No submission yet.'**
  String get noProjectSubmittedHelper;

  /// No description provided for @reviewedStatus.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewedStatus;

  /// No description provided for @reviewedHelper.
  ///
  /// In en, this message translates to:
  /// **'Judge published feedback.'**
  String get reviewedHelper;

  /// No description provided for @submittedStatus.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submittedStatus;

  /// No description provided for @submittedHelper.
  ///
  /// In en, this message translates to:
  /// **'Waiting for judge scoring.'**
  String get submittedHelper;

  /// No description provided for @notSubmittedYet.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get notSubmittedYet;

  /// No description provided for @latestSubmissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest submission'**
  String get latestSubmissionTitle;

  /// No description provided for @selectTeamToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Select or create a team to submit.'**
  String get selectTeamToSubmit;

  /// No description provided for @goToTeamAction.
  ///
  /// In en, this message translates to:
  /// **'Go to Teams'**
  String get goToTeamAction;

  /// No description provided for @createTeamNowAction.
  ///
  /// In en, this message translates to:
  /// **'Create team now'**
  String get createTeamNowAction;

  /// No description provided for @teamHasNoSubmission.
  ///
  /// In en, this message translates to:
  /// **'This team has not submitted yet.'**
  String get teamHasNoSubmission;

  /// No description provided for @updateHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Update history'**
  String get updateHistoryTitle;

  /// No description provided for @judgeFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Judge feedback'**
  String get judgeFeedbackTitle;

  /// No description provided for @submissionSavedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Submission saved'**
  String get submissionSavedNotificationTitle;

  /// No description provided for @submissionCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submitted.'**
  String get submissionCreatedSuccess;

  /// No description provided for @submissionUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submission updated.'**
  String get submissionUpdatedSuccess;

  /// No description provided for @submissionStatusReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get submissionStatusReviewed;

  /// No description provided for @submissionStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submissionStatusSubmitted;

  /// No description provided for @submissionStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get submissionStatusDraft;

  /// No description provided for @submissionDraftRestored.
  ///
  /// In en, this message translates to:
  /// **'Unsent draft restored.'**
  String get submissionDraftRestored;

  /// No description provided for @chatRoleGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Chat is available for participants and mentors.'**
  String get chatRoleGateMessage;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Mentor chat'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talk with mentors assigned to your event.'**
  String get chatSubtitle;

  /// No description provided for @chatContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat with mentor'**
  String get chatContactLabel;

  /// No description provided for @noChatContactsMessage.
  ///
  /// In en, this message translates to:
  /// **'No mentor assigned to your event yet. Contact organizers for support.'**
  String get noChatContactsMessage;

  /// No description provided for @contactOrganizerForMentorAction.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get contactOrganizerForMentorAction;

  /// No description provided for @sendMentorRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendMentorRequestAction;

  /// No description provided for @mentorRequestSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mentor assignment request sent to organizers.'**
  String get mentorRequestSentSuccess;

  /// No description provided for @contactOrganizerHint.
  ///
  /// In en, this message translates to:
  /// **'Contact organizers to get a mentor for the event.'**
  String get contactOrganizerHint;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask mentor...'**
  String get chatInputHint;

  /// No description provided for @chatRealtimeConnected.
  ///
  /// In en, this message translates to:
  /// **'Realtime connected'**
  String get chatRealtimeConnected;

  /// No description provided for @chatRealtimeConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting realtime'**
  String get chatRealtimeConnecting;

  /// No description provided for @chatRealtimeOffline.
  ///
  /// In en, this message translates to:
  /// **'Manual sync'**
  String get chatRealtimeOffline;

  /// No description provided for @reloadChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload conversation'**
  String get reloadChatTooltip;

  /// No description provided for @messageSentStatus.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get messageSentStatus;

  /// No description provided for @sendMessageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendMessageTooltip;

  /// No description provided for @yourMessageSemantic.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessageSemantic;

  /// No description provided for @deleteMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get deleteMessageTitle;

  /// No description provided for @deleteMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Your message will be removed from the conversation.'**
  String get deleteMessageBody;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get noMessagesYet;

  /// No description provided for @selectConversationBeforeSend.
  ///
  /// In en, this message translates to:
  /// **'Select a conversation before sending.'**
  String get selectConversationBeforeSend;

  /// No description provided for @judgeRoleGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Only judges can access scoring.'**
  String get judgeRoleGateMessage;

  /// No description provided for @judgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get judgeTitle;

  /// No description provided for @judgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Score submissions on technical depth, UX and innovation.'**
  String get judgeSubtitle;

  /// No description provided for @filterUnscored.
  ///
  /// In en, this message translates to:
  /// **'Unscored'**
  String get filterUnscored;

  /// No description provided for @filterScored.
  ///
  /// In en, this message translates to:
  /// **'Scored'**
  String get filterScored;

  /// No description provided for @judgeSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search submission or team'**
  String get judgeSearchLabel;

  /// No description provided for @noMatchingSubmissions.
  ///
  /// In en, this message translates to:
  /// **'No matching submissions.'**
  String get noMatchingSubmissions;

  /// No description provided for @showAllSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAllSubmissions;

  /// No description provided for @selectSubmissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select submission'**
  String get selectSubmissionTitle;

  /// No description provided for @nextUnscoredButton.
  ///
  /// In en, this message translates to:
  /// **'Next unscored'**
  String get nextUnscoredButton;

  /// No description provided for @selectSubmissionToScore.
  ///
  /// In en, this message translates to:
  /// **'Select a submission to score.'**
  String get selectSubmissionToScore;

  /// No description provided for @needsScoringBadge.
  ///
  /// In en, this message translates to:
  /// **'Needs scoring'**
  String get needsScoringBadge;

  /// No description provided for @repositoryButton.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get repositoryButton;

  /// No description provided for @demoButton.
  ///
  /// In en, this message translates to:
  /// **'Demo video'**
  String get demoButton;

  /// No description provided for @rubricEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Rubric'**
  String get rubricEvaluationTitle;

  /// No description provided for @feedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackLabel;

  /// No description provided for @updateScoreDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update old score?'**
  String get updateScoreDialogTitle;

  /// No description provided for @currentScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Current score'**
  String get currentScoreLabel;

  /// No description provided for @feedbackReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get feedbackReady;

  /// No description provided for @feedbackMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get feedbackMissing;

  /// No description provided for @submitScoreButton.
  ///
  /// In en, this message translates to:
  /// **'Submit score'**
  String get submitScoreButton;

  /// No description provided for @updateScoreButton.
  ///
  /// In en, this message translates to:
  /// **'Update score'**
  String get updateScoreButton;

  /// No description provided for @scoringProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring progress'**
  String get scoringProgressTitle;

  /// No description provided for @scorePublishedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Score published'**
  String get scorePublishedNotificationTitle;

  /// No description provided for @scorePublishedSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Score published for submission.'**
  String get scorePublishedSnackBar;

  /// No description provided for @scoreSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Score saved.'**
  String get scoreSavedSuccess;

  /// No description provided for @judgeScoreParticipantHint.
  ///
  /// In en, this message translates to:
  /// **'Participants open notifications to view score and feedback.'**
  String get judgeScoreParticipantHint;

  /// No description provided for @scoreNotificationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring result'**
  String get scoreNotificationDialogTitle;

  /// No description provided for @announcementNotificationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcement from organizers'**
  String get announcementNotificationDialogTitle;

  /// No description provided for @viewSubmissionButton.
  ///
  /// In en, this message translates to:
  /// **'View submission'**
  String get viewSubmissionButton;

  /// No description provided for @closeDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeDialogButton;

  /// No description provided for @organizerRoleGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Only organizers can access operations.'**
  String get organizerRoleGateMessage;

  /// No description provided for @organizerTitle.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizerTitle;

  /// No description provided for @organizerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track events, team progress and scoring status.'**
  String get organizerSubtitle;

  /// No description provided for @sectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get sectionOverview;

  /// No description provided for @sectionOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get sectionOperations;

  /// No description provided for @sectionSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get sectionSubmissions;

  /// No description provided for @sectionEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get sectionEvents;

  /// No description provided for @sectionTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get sectionTeams;

  /// No description provided for @sendAnnouncementButton.
  ///
  /// In en, this message translates to:
  /// **'Send announcement'**
  String get sendAnnouncementButton;

  /// No description provided for @sendAnnouncementDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Send announcement'**
  String get sendAnnouncementDialogTitle;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipients'**
  String get recipientLabel;

  /// No description provided for @notificationTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notificationTitleLabel;

  /// No description provided for @notificationContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get notificationContentLabel;

  /// No description provided for @announcementPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview announcement'**
  String get announcementPreviewTitle;

  /// No description provided for @confirmSendAnnouncementButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm send'**
  String get confirmSendAnnouncementButton;

  /// No description provided for @announcementSendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Sending announcement...'**
  String get announcementSendingStatus;

  /// No description provided for @recipientCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient count'**
  String get recipientCountLabel;

  /// No description provided for @createEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get createEventTitle;

  /// No description provided for @editEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get editEventTitle;

  /// No description provided for @eventFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventFieldTitle;

  /// No description provided for @eventFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get eventFieldDescription;

  /// No description provided for @eventFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventFieldLocation;

  /// No description provided for @eventFieldBannerUrl.
  ///
  /// In en, this message translates to:
  /// **'Banner URL'**
  String get eventFieldBannerUrl;

  /// No description provided for @eventFieldStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get eventFieldStartDate;

  /// No description provided for @eventFieldEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get eventFieldEndDate;

  /// No description provided for @eventFieldRegistrationDeadline.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline'**
  String get eventFieldRegistrationDeadline;

  /// No description provided for @eventFieldSubmissionDeadline.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline'**
  String get eventFieldSubmissionDeadline;

  /// No description provided for @eventFieldSupportHotline.
  ///
  /// In en, this message translates to:
  /// **'Support hotline'**
  String get eventFieldSupportHotline;

  /// No description provided for @eventFieldOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get eventFieldOpeningHours;

  /// No description provided for @eventFieldMaxTeamSize.
  ///
  /// In en, this message translates to:
  /// **'Max team size'**
  String get eventFieldMaxTeamSize;

  /// No description provided for @eventFieldRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get eventFieldRules;

  /// No description provided for @eventFieldPrize.
  ///
  /// In en, this message translates to:
  /// **'Prize'**
  String get eventFieldPrize;

  /// No description provided for @eventFieldLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get eventFieldLatitude;

  /// No description provided for @eventFieldLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get eventFieldLongitude;

  /// No description provided for @selectOnMapButton.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get selectOnMapButton;

  /// No description provided for @eventStepInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get eventStepInfo;

  /// No description provided for @eventStepBanner.
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get eventStepBanner;

  /// No description provided for @eventStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventStepLocation;

  /// No description provided for @eventStepTime.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get eventStepTime;

  /// No description provided for @uploadBannerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadBannerTooltip;

  /// No description provided for @uploadBannerButton.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadBannerButton;

  /// No description provided for @changeBannerButton.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get changeBannerButton;

  /// No description provided for @removeBannerButton.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get removeBannerButton;

  /// No description provided for @bannerUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Banner uploaded successfully.'**
  String get bannerUploadSuccess;

  /// No description provided for @uploadBannerFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload image. Check Storage configuration.'**
  String get uploadBannerFailed;

  /// No description provided for @advancedCoordinatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced: coordinates'**
  String get advancedCoordinatesTitle;

  /// No description provided for @invalidEventDatesSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Invalid event dates. Check the format.'**
  String get invalidEventDatesSnackBar;

  /// No description provided for @closeRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Close registration?'**
  String get closeRegistrationTitle;

  /// No description provided for @closeRegistrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration closed for this event.'**
  String get closeRegistrationSuccess;

  /// No description provided for @recentSubmissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent submissions'**
  String get recentSubmissionsTitle;

  /// No description provided for @noSubmissionsYet.
  ///
  /// In en, this message translates to:
  /// **'No submissions yet.'**
  String get noSubmissionsYet;

  /// No description provided for @openTeamAction.
  ///
  /// In en, this message translates to:
  /// **'Open team'**
  String get openTeamAction;

  /// No description provided for @teamDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Team details'**
  String get teamDetailsTitle;

  /// No description provided for @noTeamsToView.
  ///
  /// In en, this message translates to:
  /// **'No teams to view.'**
  String get noTeamsToView;

  /// No description provided for @leaderboardCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard copied.'**
  String get leaderboardCopiedSuccess;

  /// No description provided for @manageUserRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage user roles'**
  String get manageUserRolesTitle;

  /// No description provided for @createStaffAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create judge/mentor account'**
  String get createStaffAccountTitle;

  /// No description provided for @createStaffAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createStaffAccountButton;

  /// No description provided for @createStaffAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create account. Check admin-create-user Edge Function.'**
  String get createStaffAccountFailed;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get noUsersYet;

  /// No description provided for @changeRoleDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change account role?'**
  String get changeRoleDialogTitle;

  /// No description provided for @exportLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Export leaderboard'**
  String get exportLeaderboardTitle;

  /// No description provided for @userRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'User roles'**
  String get userRolesTitle;

  /// No description provided for @userSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search name or email'**
  String get userSearchLabel;

  /// No description provided for @roleFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter role'**
  String get roleFilterLabel;

  /// No description provided for @noMatchingUsers.
  ///
  /// In en, this message translates to:
  /// **'No matching accounts.'**
  String get noMatchingUsers;

  /// No description provided for @manageScoreCriteriaTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage scoring criteria'**
  String get manageScoreCriteriaTitle;

  /// No description provided for @manageEventMentorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign event mentors'**
  String get manageEventMentorsTitle;

  /// No description provided for @manageEventMentorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick mentors to support participants per hackathon'**
  String get manageEventMentorsDescription;

  /// No description provided for @noEventsForMentorAssignment.
  ///
  /// In en, this message translates to:
  /// **'No events to assign mentors.'**
  String get noEventsForMentorAssignment;

  /// No description provided for @noMentorsAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'No mentor accounts. Create or assign roles first.'**
  String get noMentorsAvailableMessage;

  /// No description provided for @mentorAssignmentLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load assigned mentors.'**
  String get mentorAssignmentLoadFailed;

  /// No description provided for @manageScoreCriteriaDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a custom rubric per event'**
  String get manageScoreCriteriaDescription;

  /// No description provided for @addScoreCriterionButton.
  ///
  /// In en, this message translates to:
  /// **'Add criterion'**
  String get addScoreCriterionButton;

  /// No description provided for @scoreCriterionLabel.
  ///
  /// In en, this message translates to:
  /// **'Criterion name'**
  String get scoreCriterionLabel;

  /// No description provided for @scoreCriterionDescription.
  ///
  /// In en, this message translates to:
  /// **'Criterion description'**
  String get scoreCriterionDescription;

  /// No description provided for @scoreCriteriaSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Scoring criteria saved.'**
  String get scoreCriteriaSavedSuccess;

  /// No description provided for @defaultRubricHint.
  ///
  /// In en, this message translates to:
  /// **'This event uses the default rubric. Organizers can edit and save a custom rubric.'**
  String get defaultRubricHint;

  /// No description provided for @useDefaultRubricButton.
  ///
  /// In en, this message translates to:
  /// **'Use default rubric'**
  String get useDefaultRubricButton;

  /// No description provided for @unscoredMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Unscored'**
  String get unscoredMetricLabel;

  /// No description provided for @organizerTodayTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks for today'**
  String get organizerTodayTasksTitle;

  /// No description provided for @organizerUnscoredTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Unscored submissions'**
  String get organizerUnscoredTasksLabel;

  /// No description provided for @organizerTeamsNeedMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Teams need members'**
  String get organizerTeamsNeedMembersLabel;

  /// No description provided for @organizerClosingSoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration closing soon'**
  String get organizerClosingSoonLabel;

  /// No description provided for @organizerSendReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Send reminder'**
  String get organizerSendReminderButton;

  /// No description provided for @organizerAssignMentorButton.
  ///
  /// In en, this message translates to:
  /// **'Assign mentor'**
  String get organizerAssignMentorButton;

  /// No description provided for @organizerTaskUnscoredLabel.
  ///
  /// In en, this message translates to:
  /// **'Scoring reminder'**
  String get organizerTaskUnscoredLabel;

  /// No description provided for @organizerTaskTeamsLabel.
  ///
  /// In en, this message translates to:
  /// **'Team reminder'**
  String get organizerTaskTeamsLabel;

  /// No description provided for @organizerTaskClosingLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration reminder'**
  String get organizerTaskClosingLabel;

  /// No description provided for @otherActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other actions'**
  String get otherActionsTitle;

  /// No description provided for @dashboardChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring overview'**
  String get dashboardChartTitle;

  /// No description provided for @scoredBarLabel.
  ///
  /// In en, this message translates to:
  /// **'Scored'**
  String get scoredBarLabel;

  /// No description provided for @unscoredBarLabel.
  ///
  /// In en, this message translates to:
  /// **'Unscored'**
  String get unscoredBarLabel;

  /// No description provided for @loadMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMoreButton;

  /// No description provided for @announcementEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Link event (optional)'**
  String get announcementEventLabel;

  /// No description provided for @announcementNoEvent.
  ///
  /// In en, this message translates to:
  /// **'No linked event'**
  String get announcementNoEvent;

  /// No description provided for @viewEventFromAnnouncementButton.
  ///
  /// In en, this message translates to:
  /// **'View event'**
  String get viewEventFromAnnouncementButton;

  /// No description provided for @announcementTemplatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick templates'**
  String get announcementTemplatesLabel;

  /// No description provided for @announcementTemplateJudgingLabel.
  ///
  /// In en, this message translates to:
  /// **'Open judging'**
  String get announcementTemplateJudgingLabel;

  /// No description provided for @announcementTemplateJudgingTitle.
  ///
  /// In en, this message translates to:
  /// **'Judging room open'**
  String get announcementTemplateJudgingTitle;

  /// No description provided for @announcementTemplateJudgingBody.
  ///
  /// In en, this message translates to:
  /// **'Judges please open the Scoring tab. Official judging session is open.'**
  String get announcementTemplateJudgingBody;

  /// No description provided for @announcementTemplateDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get announcementTemplateDeadlineLabel;

  /// No description provided for @announcementTemplateDeadlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline reminder'**
  String get announcementTemplateDeadlineTitle;

  /// No description provided for @announcementTemplateDeadlineBody.
  ///
  /// In en, this message translates to:
  /// **'Teams that have not submitted please finish GitHub, demo video and description before the deadline.'**
  String get announcementTemplateDeadlineBody;

  /// No description provided for @announcementTemplateKickoffLabel.
  ///
  /// In en, this message translates to:
  /// **'Kickoff'**
  String get announcementTemplateKickoffLabel;

  /// No description provided for @announcementTemplateKickoffTitle.
  ///
  /// In en, this message translates to:
  /// **'Hackathon kickoff'**
  String get announcementTemplateKickoffTitle;

  /// No description provided for @announcementTemplateKickoffBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome teams to SEAL Innovation Hackathon 2026. Check Events for schedule and rules.'**
  String get announcementTemplateKickoffBody;

  /// No description provided for @newScoreSnackBar.
  ///
  /// In en, this message translates to:
  /// **'New score available. Open notifications to view.'**
  String get newScoreSnackBar;

  /// No description provided for @openInboxAction.
  ///
  /// In en, this message translates to:
  /// **'View notifications'**
  String get openInboxAction;

  /// No description provided for @inboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get inboxTitle;

  /// No description provided for @inboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scores, team invites and system updates.'**
  String get inboxSubtitle;

  /// No description provided for @inboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get inboxEmpty;

  /// No description provided for @reloadInboxAction.
  ///
  /// In en, this message translates to:
  /// **'Reload notifications'**
  String get reloadInboxAction;

  /// No description provided for @unreadGroup.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadGroup;

  /// No description provided for @readGroup.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readGroup;

  /// No description provided for @markAsReadAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsReadAction;

  /// No description provided for @deleteNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete notification?'**
  String get deleteNotificationTitle;

  /// No description provided for @deleteNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This item will be removed from the list.'**
  String get deleteNotificationBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage account info used across role flows.'**
  String get profileSubtitle;

  /// No description provided for @noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active session.'**
  String get noActiveSession;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @accountInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Account info'**
  String get accountInfoTitle;

  /// No description provided for @saveProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfileButton;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurityTitle;

  /// No description provided for @profileSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send password reset email to registered address. Contact organizers to change email.'**
  String get profileSecuritySubtitle;

  /// No description provided for @themeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeModeTitle;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageVi.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVi;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJa;

  /// No description provided for @sessionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get sessionSectionTitle;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Signing out clears local state and returns to sign in.'**
  String get logoutDescription;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get mapTitle;

  /// No description provided for @mapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Map, address and directions.'**
  String get mapSubtitle;

  /// No description provided for @noVenueYet.
  ///
  /// In en, this message translates to:
  /// **'No event venue yet.'**
  String get noVenueYet;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @openingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHoursLabel;

  /// No description provided for @hotlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Hotline'**
  String get hotlineLabel;

  /// No description provided for @coordinatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinatesLabel;

  /// No description provided for @defaultOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'08:00 - 18:00'**
  String get defaultOpeningHours;

  /// No description provided for @defaultHotline.
  ///
  /// In en, this message translates to:
  /// **'0900 000 000'**
  String get defaultHotline;

  /// No description provided for @copyAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Copy address'**
  String get copyAddressButton;

  /// No description provided for @addressCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Address copied.'**
  String get addressCopiedSuccess;

  /// No description provided for @openMapsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Maps'**
  String get openMapsButton;

  /// No description provided for @openExternalMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open external Maps?'**
  String get openExternalMapsTitle;

  /// No description provided for @openExternalMapsBody.
  ///
  /// In en, this message translates to:
  /// **'You will temporarily leave SEAL Hackathon to open Maps.'**
  String get openExternalMapsBody;

  /// No description provided for @mapPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick event location'**
  String get mapPickerTitle;

  /// No description provided for @mapPickerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Drag the map to place the pin at the event location'**
  String get mapPickerInstruction;

  /// No description provided for @openMapsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Maps on this device.'**
  String get openMapsFailed;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter email.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get validationPasswordMinLength;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password.'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordMismatch;

  /// No description provided for @validationOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP from email.'**
  String get validationOtpRequired;

  /// No description provided for @validationOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits.'**
  String get validationOtpInvalid;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter full name.'**
  String get validationFullNameRequired;

  /// No description provided for @validationFullNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters.'**
  String get validationFullNameMinLength;

  /// No description provided for @validationUniversityRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter university.'**
  String get validationUniversityRequired;

  /// No description provided for @validationUniversityMinLength.
  ///
  /// In en, this message translates to:
  /// **'University must be at least 2 characters.'**
  String get validationUniversityMinLength;

  /// No description provided for @validationSupabaseNotReady.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to system. Try again later.'**
  String get validationSupabaseNotReady;

  /// No description provided for @validationTeamNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter team name.'**
  String get validationTeamNameRequired;

  /// No description provided for @validationTeamNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Team name must be at least 2 characters.'**
  String get validationTeamNameMinLength;

  /// No description provided for @validationInviteEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid member email.'**
  String get validationInviteEmailInvalid;

  /// No description provided for @validationProjectNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter project name.'**
  String get validationProjectNameRequired;

  /// No description provided for @validationProjectNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Project name must be at least 2 characters.'**
  String get validationProjectNameMinLength;

  /// No description provided for @validationDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter project description.'**
  String get validationDescriptionRequired;

  /// No description provided for @validationDescriptionMinLength.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters.'**
  String get validationDescriptionMinLength;

  /// No description provided for @validationJoinTeamBeforeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team before submitting.'**
  String get validationJoinTeamBeforeSubmit;

  /// No description provided for @eventNotLoadedForSubmit.
  ///
  /// In en, this message translates to:
  /// **'Could not load team event info. Try reloading events.'**
  String get eventNotLoadedForSubmit;

  /// No description provided for @validationChatMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message cannot be empty.'**
  String get validationChatMessageRequired;

  /// No description provided for @validationNotificationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter notification title.'**
  String get validationNotificationTitleRequired;

  /// No description provided for @validationNotificationBodyRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter notification body.'**
  String get validationNotificationBodyRequired;

  /// No description provided for @validationNotificationTypeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid notification type.'**
  String get validationNotificationTypeInvalid;

  /// No description provided for @validationRecipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipients'**
  String get validationRecipientLabel;

  /// No description provided for @validationEventTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter event title.'**
  String get validationEventTitleRequired;

  /// No description provided for @validationEventTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Event title must be at least 2 characters.'**
  String get validationEventTitleMinLength;

  /// No description provided for @validationEventLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter event location.'**
  String get validationEventLocationRequired;

  /// No description provided for @validationEventLocationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Location must be at least 2 characters.'**
  String get validationEventLocationMinLength;

  /// No description provided for @validationLatitudeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter latitude.'**
  String get validationLatitudeRequired;

  /// No description provided for @validationLatitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be a valid number.'**
  String get validationLatitudeInvalid;

  /// No description provided for @validationLatitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90.'**
  String get validationLatitudeRange;

  /// No description provided for @validationLongitudeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter longitude.'**
  String get validationLongitudeRequired;

  /// No description provided for @validationLongitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be a valid number.'**
  String get validationLongitudeInvalid;

  /// No description provided for @validationLongitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180.'**
  String get validationLongitudeRange;

  /// No description provided for @validationMaxTeamSizeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter max team size.'**
  String get validationMaxTeamSizeRequired;

  /// No description provided for @validationMaxTeamSizeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Max team size must be a valid integer.'**
  String get validationMaxTeamSizeInvalid;

  /// No description provided for @validationEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date.'**
  String get validationEndAfterStart;

  /// No description provided for @validationDeadlineBeforeEnd.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline cannot be after event end.'**
  String get validationDeadlineBeforeEnd;

  /// No description provided for @validationSubmissionAfterStart.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline must be after event start.'**
  String get validationSubmissionAfterStart;

  /// No description provided for @validationSubmissionBeforeEnd.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline cannot be after event end.'**
  String get validationSubmissionBeforeEnd;

  /// No description provided for @validationScoreRange.
  ///
  /// In en, this message translates to:
  /// **'Score must be between 0 and 10.'**
  String get validationScoreRange;

  /// No description provided for @validationScoreCriteriaRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one scoring criterion required.'**
  String get validationScoreCriteriaRequired;

  /// No description provided for @validationScoreCriteriaLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 8 scoring criteria per event.'**
  String get validationScoreCriteriaLimit;

  /// No description provided for @validationScoreCriteriaLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter criterion name.'**
  String get validationScoreCriteriaLabelRequired;

  /// No description provided for @validationScoreCriteriaDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate criterion id. Remove and add again.'**
  String get validationScoreCriteriaDuplicate;

  /// No description provided for @validationScoreCriteriaWeight.
  ///
  /// In en, this message translates to:
  /// **'Criterion weight must be greater than 0.'**
  String get validationScoreCriteriaWeight;

  /// No description provided for @validationNoSubmissionSelected.
  ///
  /// In en, this message translates to:
  /// **'No submission selected to score.'**
  String get validationNoSubmissionSelected;

  /// No description provided for @validationInvalidJudgeSession.
  ///
  /// In en, this message translates to:
  /// **'Invalid judge session.'**
  String get validationInvalidJudgeSession;

  /// No description provided for @validationFeedbackRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback before submitting score.'**
  String get validationFeedbackRequired;

  /// No description provided for @validationInvalidRole.
  ///
  /// In en, this message translates to:
  /// **'Invalid role.'**
  String get validationInvalidRole;

  /// No description provided for @validationUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get validationUserLabel;

  /// No description provided for @validationBannerUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Banner URL'**
  String get validationBannerUrlLabel;

  /// No description provided for @openLinkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open link to verify'**
  String get openLinkTooltip;

  /// No description provided for @openLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this link.'**
  String get openLinkFailed;

  /// No description provided for @openExternalLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link on this device.'**
  String get openExternalLinkFailed;

  /// No description provided for @reloadTeamsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload teams'**
  String get reloadTeamsTooltip;

  /// No description provided for @reloadJudgeQueueTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload unscored queue'**
  String get reloadJudgeQueueTooltip;

  /// No description provided for @reloadDashboardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload dashboard'**
  String get reloadDashboardTooltip;

  /// No description provided for @judgePreviewOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in as Judge to submit official scores.'**
  String get judgePreviewOnlyMessage;

  /// No description provided for @judgeQueueSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort unscored queue'**
  String get judgeQueueSortLabel;

  /// No description provided for @sortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewestFirst;

  /// No description provided for @sortProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get sortProjectName;

  /// No description provided for @sortTeamName.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get sortTeamName;

  /// No description provided for @sortAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get sortAverageScore;

  /// No description provided for @judgeSubmissionToScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Submission to score'**
  String get judgeSubmissionToScoreLabel;

  /// No description provided for @unknownTeamLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown team'**
  String get unknownTeamLabel;

  /// No description provided for @teamNotLoadedYet.
  ///
  /// In en, this message translates to:
  /// **'Team not loaded'**
  String get teamNotLoadedYet;

  /// No description provided for @eventNotLoadedYet.
  ///
  /// In en, this message translates to:
  /// **'Event not loaded'**
  String get eventNotLoadedYet;

  /// No description provided for @averageScoreAbbrev.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get averageScoreAbbrev;

  /// No description provided for @judgeReviewReminder.
  ///
  /// In en, this message translates to:
  /// **'Review source code, demo quality, implementation depth and product impact before submitting.'**
  String get judgeReviewReminder;

  /// No description provided for @rubricTechnicalLabel.
  ///
  /// In en, this message translates to:
  /// **'Technical depth'**
  String get rubricTechnicalLabel;

  /// No description provided for @rubricTechnicalDescription.
  ///
  /// In en, this message translates to:
  /// **'Architecture, correctness, reliability and implementation depth.'**
  String get rubricTechnicalDescription;

  /// No description provided for @rubricUiLabel.
  ///
  /// In en, this message translates to:
  /// **'User experience'**
  String get rubricUiLabel;

  /// No description provided for @rubricUiDescription.
  ///
  /// In en, this message translates to:
  /// **'Mobile flow, clarity, accessibility and polish.'**
  String get rubricUiDescription;

  /// No description provided for @rubricInnovationLabel.
  ///
  /// In en, this message translates to:
  /// **'Innovation'**
  String get rubricInnovationLabel;

  /// No description provided for @rubricInnovationDescription.
  ///
  /// In en, this message translates to:
  /// **'Novelty, impact, useful AI/automation and product fit.'**
  String get rubricInnovationDescription;

  /// No description provided for @decreaseScoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decreaseScoreTooltip;

  /// No description provided for @increaseScoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increaseScoreTooltip;

  /// No description provided for @editEventMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get editEventMenuItem;

  /// No description provided for @closeRegistrationMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Close registration'**
  String get closeRegistrationMenuItem;

  /// No description provided for @closeRegistrationConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Close registration'**
  String get closeRegistrationConfirmButton;

  /// No description provided for @notificationActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notification options'**
  String get notificationActionsTooltip;

  /// No description provided for @eventActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Event actions'**
  String get eventActionsTooltip;

  /// No description provided for @submissionsMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get submissionsMetricLabel;

  /// No description provided for @scoresMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Score count'**
  String get scoresMetricLabel;

  /// No description provided for @systemStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get systemStatusTitle;

  /// No description provided for @systemStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track data loading and sync.'**
  String get systemStatusSubtitle;

  /// No description provided for @chatSuggestionSubmission.
  ///
  /// In en, this message translates to:
  /// **'Ask about submission'**
  String get chatSuggestionSubmission;

  /// No description provided for @chatSuggestionGithub.
  ///
  /// In en, this message translates to:
  /// **'Help review GitHub link'**
  String get chatSuggestionGithub;

  /// No description provided for @chatSuggestionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Submission checklist'**
  String get chatSuggestionChecklist;

  /// No description provided for @emailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get emailPrefix;

  /// No description provided for @averageScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get averageScoreTitle;

  /// No description provided for @judgeQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Unscored queue'**
  String get judgeQueueTitle;

  /// No description provided for @judgeQueueWaitingSuffix.
  ///
  /// In en, this message translates to:
  /// **' unscored submissions'**
  String get judgeQueueWaitingSuffix;

  /// No description provided for @exportLeaderboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Copy leaderboard data to clipboard'**
  String get exportLeaderboardDescription;

  /// No description provided for @userRolesDescription.
  ///
  /// In en, this message translates to:
  /// **'View and update account roles'**
  String get userRolesDescription;

  /// No description provided for @databaseConnectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Data ready'**
  String get databaseConnectedLabel;

  /// No description provided for @databaseMissingLabel.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get databaseMissingLabel;

  /// No description provided for @operationsDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Operations data'**
  String get operationsDataLabel;

  /// No description provided for @syncingLabel.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncingLabel;

  /// No description provided for @stateReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get stateReadyLabel;

  /// No description provided for @notLoggedInShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notLoggedInShortLabel;

  /// No description provided for @noApiErrorsLabel.
  ///
  /// In en, this message translates to:
  /// **'No data load errors'**
  String get noApiErrorsLabel;

  /// No description provided for @systemStatusSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'System operations status'**
  String get systemStatusSemanticLabel;

  /// No description provided for @profileFullNameFieldSemantic.
  ///
  /// In en, this message translates to:
  /// **'Profile full name field'**
  String get profileFullNameFieldSemantic;

  /// No description provided for @profileUniversityFieldSemantic.
  ///
  /// In en, this message translates to:
  /// **'Profile university field'**
  String get profileUniversityFieldSemantic;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Use your registered email or tap \"Create new account\".'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed. Check inbox or spam.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired OTP. Request a new activation email.'**
  String get errorInvalidOtp;

  /// No description provided for @errorConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Check network and try again.'**
  String get errorConnectionTimeout;

  /// No description provided for @errorRlsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Your account cannot perform this action.'**
  String get errorRlsPermissionDenied;

  /// No description provided for @errorDuplicateRecord.
  ///
  /// In en, this message translates to:
  /// **'This data already exists. Reload and update the existing record.'**
  String get errorDuplicateRecord;

  /// No description provided for @errorCheckConstraint.
  ///
  /// In en, this message translates to:
  /// **'Invalid data. Check your input and try again.'**
  String get errorCheckConstraint;

  /// No description provided for @otpHelpText.
  ///
  /// In en, this message translates to:
  /// **'The OTP is in your activation email. Check inbox or spam if you do not see it.'**
  String get otpHelpText;

  /// No description provided for @teamOverviewForEvent.
  ///
  /// In en, this message translates to:
  /// **'Team — {title}'**
  String teamOverviewForEvent(String title);

  /// No description provided for @scopedTeamsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} teams in this event'**
  String scopedTeamsAvailable(int count);

  /// No description provided for @pendingInvitationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending invitations'**
  String pendingInvitationsCount(int count);

  /// No description provided for @eventScheduleHours.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}'**
  String eventScheduleHours(String start, String end);

  /// No description provided for @activationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Activation email sent to {email}. Open the link or enter the 6-digit OTP below.'**
  String activationEmailSent(String email);

  /// No description provided for @emailActivatedWelcome.
  ///
  /// In en, this message translates to:
  /// **'Email activated. Welcome {email}!'**
  String emailActivatedWelcome(String email);

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}. Check your inbox or spam folder.'**
  String passwordResetEmailSent(String email);

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful with {email}.'**
  String registerSuccess(String email);

  /// No description provided for @organizerFocusEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Filtering by {title}.'**
  String organizerFocusEventSubtitle(String title);

  /// No description provided for @submissionEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event: {title}'**
  String submissionEventLabel(String title);

  /// No description provided for @judgeQueueForEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring: {title}'**
  String judgeQueueForEventTitle(String title);

  /// No description provided for @openEventSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Open event {title}'**
  String openEventSemanticLabel(String title);

  /// No description provided for @registerBeforeDate.
  ///
  /// In en, this message translates to:
  /// **'Register before {date}'**
  String registerBeforeDate(String date);

  /// No description provided for @registrationClosedByDate.
  ///
  /// In en, this message translates to:
  /// **'Registration closed {date}'**
  String registrationClosedByDate(String date);

  /// No description provided for @registrationOpenUntilDate.
  ///
  /// In en, this message translates to:
  /// **'Registration open until {date}'**
  String registrationOpenUntilDate(String date);

  /// No description provided for @maxMembersChip.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} members'**
  String maxMembersChip(int count);

  /// No description provided for @leaderPrefix.
  ///
  /// In en, this message translates to:
  /// **'Leader: {name}'**
  String leaderPrefix(String name);

  /// No description provided for @memberCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String memberCountLabel(int count);

  /// No description provided for @teamSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Team {name}, {memberCount} members, Leader: {leader}'**
  String teamSemanticLabel(String name, String memberCount, String leader);

  /// No description provided for @inviteTeamPrefix.
  ///
  /// In en, this message translates to:
  /// **'Team: {name}'**
  String inviteTeamPrefix(String name);

  /// No description provided for @leaveTeamDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You will leave {teamName}. After registration closes you cannot rejoin.'**
  String leaveTeamDialogBody(String teamName);

  /// No description provided for @teamInvitationBody.
  ///
  /// In en, this message translates to:
  /// **'You are invited to {teamName}. Open Teams to view and join if spots remain.'**
  String teamInvitationBody(String teamName);

  /// No description provided for @invitedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Invited by: {name}'**
  String invitedByLabel(String name);

  /// No description provided for @teamCreatedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{teamName} joined {eventTitle}.'**
  String teamCreatedNotificationBody(String teamName, String eventTitle);

  /// No description provided for @alreadyOnEventTeamNamedError.
  ///
  /// In en, this message translates to:
  /// **'You are already on team {teamName} for this event.'**
  String alreadyOnEventTeamNamedError(String teamName);

  /// No description provided for @teamFullForEventError.
  ///
  /// In en, this message translates to:
  /// **'{teamName} is full for this event.'**
  String teamFullForEventError(String teamName);

  /// No description provided for @submissionSavedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{projectName} was submitted successfully.'**
  String submissionSavedNotificationBody(String projectName);

  /// No description provided for @chatEventScopedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation for event {eventTitle}'**
  String chatEventScopedSubtitle(String eventTitle);

  /// No description provided for @mentorRequestNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Mentor request: {participantName}'**
  String mentorRequestNotificationTitle(String participantName);

  /// No description provided for @todayTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String todayTimestamp(String time);

  /// No description provided for @scoreOutOfTenLabel.
  ///
  /// In en, this message translates to:
  /// **'{score}/10'**
  String scoreOutOfTenLabel(String score);

  /// No description provided for @scoreWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight x{weight}'**
  String scoreWeightLabel(String weight);

  /// No description provided for @updateScoreDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your previous score for {projectName} will be replaced.'**
  String updateScoreDialogBody(String projectName);

  /// No description provided for @closeRegistrationBody.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline for {title} will be set to now.'**
  String closeRegistrationBody(String title);

  /// No description provided for @announcementSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Announcement sent to {count} users.'**
  String announcementSentSuccess(int count);

  /// No description provided for @announcementRolePreview.
  ///
  /// In en, this message translates to:
  /// **'Send to: {role}'**
  String announcementRolePreview(String role);

  /// No description provided for @recipientCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} accounts'**
  String recipientCountValue(int count);

  /// No description provided for @changeRoleDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Assign {name} as {role}.'**
  String changeRoleDialogBody(String name, String role);

  /// No description provided for @roleUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated role for {name}.'**
  String roleUpdatedSuccess(String name);

  /// No description provided for @cannotChangeOwnRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{email}\nYou cannot change your own role.'**
  String cannotChangeOwnRoleSubtitle(String email);

  /// No description provided for @sendPasswordResetTo.
  ///
  /// In en, this message translates to:
  /// **'Send password reset link to {email}'**
  String sendPasswordResetTo(String email);

  /// No description provided for @mapPickerCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates: {latitude}, {longitude}'**
  String mapPickerCoordinates(String latitude, String longitude);

  /// No description provided for @coordinatesPreview.
  ///
  /// In en, this message translates to:
  /// **'{latitude}, {longitude}'**
  String coordinatesPreview(String latitude, String longitude);

  /// No description provided for @staffAccountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Created account for {name}.'**
  String staffAccountCreatedSuccess(String name);

  /// No description provided for @mentorAssignmentSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Assigned {count} mentors to the event.'**
  String mentorAssignmentSavedSuccess(int count);

  /// No description provided for @organizerTaskUnscoredTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoring reminder — {eventTitle}'**
  String organizerTaskUnscoredTitle(String eventTitle);

  /// No description provided for @organizerTaskUnscoredBody.
  ///
  /// In en, this message translates to:
  /// **'{count} submissions still unscored. Please finish scoring today.'**
  String organizerTaskUnscoredBody(int count);

  /// No description provided for @organizerTaskTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Team reminder — {eventTitle}'**
  String organizerTaskTeamsTitle(String eventTitle);

  /// No description provided for @organizerTaskTeamsBody.
  ///
  /// In en, this message translates to:
  /// **'{count} teams still need members. Invite participants before the deadline.'**
  String organizerTaskTeamsBody(int count);

  /// No description provided for @organizerTaskClosingTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration closing — {eventTitle}'**
  String organizerTaskClosingTitle(String eventTitle);

  /// No description provided for @organizerTaskClosingBody.
  ///
  /// In en, this message translates to:
  /// **'{count} events close registration within 3 days. Finish registration early.'**
  String organizerTaskClosingBody(int count);

  /// No description provided for @organizerNotificationSuggestions.
  ///
  /// In en, this message translates to:
  /// **'{count} suggested announcements'**
  String organizerNotificationSuggestions(int count);

  /// No description provided for @journeyScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'Average score: {score}'**
  String journeyScoreSummary(String score);

  /// No description provided for @submissionDraftSavedAt.
  ///
  /// In en, this message translates to:
  /// **'Draft saved at {time}'**
  String submissionDraftSavedAt(String time);

  /// No description provided for @validationSearchMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Search keyword max {max} characters.'**
  String validationSearchMaxLength(int max);

  /// No description provided for @validationInvalidUser.
  ///
  /// In en, this message translates to:
  /// **'{label} is invalid.'**
  String validationInvalidUser(String label);

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter {label}.'**
  String validationFieldRequired(String label);

  /// No description provided for @validationInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'{label} must be a valid http/https URL.'**
  String validationInvalidUrl(String label);

  /// No description provided for @validationTeamNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Team name max {max} characters.'**
  String validationTeamNameMaxLength(int max);

  /// No description provided for @validationProjectNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Project name max {max} characters.'**
  String validationProjectNameMaxLength(int max);

  /// No description provided for @validationDescriptionMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Description max {max} characters.'**
  String validationDescriptionMaxLength(int max);

  /// No description provided for @validationChatMessageMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Message max {max} characters.'**
  String validationChatMessageMaxLength(int max);

  /// No description provided for @validationNotificationTitleMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Title max {max} characters.'**
  String validationNotificationTitleMaxLength(int max);

  /// No description provided for @validationNotificationBodyMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Body max {max} characters.'**
  String validationNotificationBodyMaxLength(int max);

  /// No description provided for @validationFeedbackMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Feedback max {max} characters.'**
  String validationFeedbackMaxLength(int max);

  /// No description provided for @validationMaxTeamSizeRange.
  ///
  /// In en, this message translates to:
  /// **'Max team size must be between {min} and {max}.'**
  String validationMaxTeamSizeRange(int min, int max);

  /// No description provided for @validationDateTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{label} must use format {format} (e.g. 2026-06-15 09:00).'**
  String validationDateTimeFormat(String label, String format);

  /// No description provided for @submissionQueueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} submissions in this queue'**
  String submissionQueueCountLabel(int count);

  /// No description provided for @scoreCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} scores'**
  String scoreCountLabel(int count);

  /// No description provided for @scoringProgressSemantic.
  ///
  /// In en, this message translates to:
  /// **'Scoring progress: {scored} scored and {unscored} unscored'**
  String scoringProgressSemantic(int scored, int unscored);

  /// No description provided for @memberCountWithLimit.
  ///
  /// In en, this message translates to:
  /// **'{current}/{limit} members'**
  String memberCountWithLimit(int current, int limit);

  /// No description provided for @apiErrorCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} errors'**
  String apiErrorCountLabel(int count);

  /// No description provided for @judgeQueueWaitingLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} unscored submissions'**
  String judgeQueueWaitingLabel(int count);

  /// No description provided for @scoreSliderSemantic.
  ///
  /// In en, this message translates to:
  /// **'{label} {value} points. {description}'**
  String scoreSliderSemantic(String label, String value, String description);

  /// No description provided for @messageTimestampSemantic.
  ///
  /// In en, this message translates to:
  /// **'{senderLabel} at {time}'**
  String messageTimestampSemantic(String senderLabel, String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
