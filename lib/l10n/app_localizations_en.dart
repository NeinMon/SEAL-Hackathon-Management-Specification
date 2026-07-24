// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sessionBootstrapMessage => 'Restoring sign-in session...';

  @override
  String get statusRegistrationClosing => 'Registration closing soon';

  @override
  String get statusJudging => 'Judging in progress';

  @override
  String get allEventsFilter => 'All events';

  @override
  String get myTeamReadyBadge => 'On a team';

  @override
  String get myTeamPendingBadge => 'No team yet';

  @override
  String get weightedScoreHint =>
      'Displayed score is a weighted rubric average saved to the system.';

  @override
  String get scorePublishedWithHintSnackBar =>
      'Scores published. Participants will be notified in their inbox.';

  @override
  String get demoResetTitle => 'Reset demo data';

  @override
  String get demoResetDescription =>
      'Deletes all users, events, teams, submissions and scores in the current environment. Demo local only.';

  @override
  String get demoResetConfirmLabel => 'Type RESET to confirm';

  @override
  String get demoResetSuccess => 'Demo data reset.';

  @override
  String get eventSupportHotline =>
      'Contact organizers via Chat or notifications';

  @override
  String get demoOnboardingTitle => 'Quick demo guide';

  @override
  String get demoOnboardingStartButton => 'Start demo';

  @override
  String get demoOnboardingParticipantTitle => 'Participant';

  @override
  String get demoOnboardingParticipantBody =>
      'Event → Team → Submit. Use a demo account if the environment is seeded.';

  @override
  String get demoOnboardingJudgeTitle => 'Judge';

  @override
  String get demoOnboardingJudgeBody =>
      'Scoring tab → pick a submission → enter criteria and feedback → Submit score.';

  @override
  String get demoOnboardingAlertsTitle => 'Notifications';

  @override
  String get demoOnboardingAlertsBody =>
      'Bell icon top-right. Tap a score notification to view details.';

  @override
  String get appName => 'SEAL Hackathon';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get deleteButton => 'Delete';

  @override
  String get sendButton => 'Send';

  @override
  String get doneButton => 'Done';

  @override
  String get resetButton => 'Reset';

  @override
  String get updateButton => 'Update';

  @override
  String get retryButton => 'Retry';

  @override
  String get stayButton => 'Stay';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get confirmDelete => 'Are you sure you want to delete?';

  @override
  String get detailsButton => 'Details';

  @override
  String get editButton => 'Edit';

  @override
  String get inviteButton => 'Invite';

  @override
  String get allFilter => 'All';

  @override
  String get sortLabel => 'Sort';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get leaderBadge => 'Leader';

  @override
  String get meLabel => 'Me';

  @override
  String get statusActive => 'Open';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusClosed => 'Closed';

  @override
  String get filterRegistrationOpen => 'Registration open';

  @override
  String get networkOfflineMessage =>
      'No network connection. Check your connection and try again.';

  @override
  String get networkError => 'Cannot connect to server';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get accessDeniedTitle => 'Access denied';

  @override
  String get accessDeniedSubtitle =>
      'This feature is not available for your role.';

  @override
  String get accessDeniedDefaultMessage =>
      'Please sign in with an appropriate account.';

  @override
  String get backToEventsButton => 'Back to events';

  @override
  String get loginRequiredTitle => 'Please sign in';

  @override
  String get loginRequiredSubtitle =>
      'Sign in to continue using SEAL Hackathon.';

  @override
  String get goToLoginButton => 'Go to sign in';

  @override
  String get supabaseRequiredTitle => 'Cannot connect to system';

  @override
  String get supabaseRequiredBody =>
      'The app is not ready to load data. Try again later or contact organizers.';

  @override
  String get notLoggedInMessage => 'You are not signed in.';

  @override
  String get logoutFailedMessage => 'Could not sign out. Try again.';

  @override
  String get saveSuccess => 'Data saved successfully';

  @override
  String get updateSuccess => 'Updated successfully';

  @override
  String get deleteSuccess => 'Deleted successfully';

  @override
  String get roleParticipant => 'Participant';

  @override
  String get roleJudge => 'Judge';

  @override
  String get roleMentor => 'Mentor';

  @override
  String get roleOrganizer => 'Organizer';

  @override
  String get eventsNavLabel => 'Events';

  @override
  String get myHomeNavLabel => 'My home';

  @override
  String get teamNavLabel => 'Team';

  @override
  String get submitNavLabel => 'Submit';

  @override
  String get judgeNavLabel => 'Scoring';

  @override
  String get dashboardNavLabel => 'Dashboard';

  @override
  String get chatNavLabel => 'Chat';

  @override
  String get mapNavLabel => 'Map';

  @override
  String get eventSubNavOverview => 'Overview';

  @override
  String get eventScopedSubtitle => 'Active event';

  @override
  String get backToEventsAction => 'Back to My home';

  @override
  String get backToEventListAction => 'Back to event list';

  @override
  String get profileNavLabel => 'Profile';

  @override
  String get notificationsNavLabel => 'Notifications';

  @override
  String get accountMenuTooltip => 'Account';

  @override
  String get logoutButton => 'Sign out';

  @override
  String get helpTooltip => 'Help';

  @override
  String get helpDialogTitle => 'Need help?';

  @override
  String get helpDialogBody =>
      'Contact organizers at the support desk or send a message in Chat.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get verifyEmailTitle => 'Verify email';

  @override
  String get loginHeroSubtitle =>
      'Manage events, teams, submissions, scoring, messages and venue in one mobile app.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get universityLabel => 'University';

  @override
  String get otpLabel => 'OTP code (6 digits)';

  @override
  String get registerRoleHint =>
      'New accounts are created as Participant. Verify email with the OTP after sign-up.';

  @override
  String get roleManagedHint => 'Role is managed on your account profile.';

  @override
  String get forgotPasswordButton => 'Forgot password?';

  @override
  String get hidePasswordTooltip => 'Hide password';

  @override
  String get showPasswordTooltip => 'Show password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerButton => 'Register';

  @override
  String get confirmOtpButton => 'Confirm OTP';

  @override
  String get backToLoginButton => 'Back to sign in';

  @override
  String get haveAccountButton => 'I already have an account';

  @override
  String get createAccountButton => 'Create new account';

  @override
  String get loginSuccess => 'Signed in successfully';

  @override
  String get loginFailed => 'Invalid email or password';

  @override
  String get emailConfirmedWelcomeBack => 'Email confirmed. Welcome back!';

  @override
  String get noPendingVerificationEmail => 'No email pending verification.';

  @override
  String get registerSuccessPrefix => 'Registration successful with';

  @override
  String get eventsTitle => 'Events';

  @override
  String get participantHomeTitle => 'Your events';

  @override
  String get participantHomeSubtitle =>
      'Tap an event below to start — or continue from the progress card.';

  @override
  String get participantPickEventTitle => 'Pick an event to start';

  @override
  String get participantPickEventBody =>
      'You are not on a team yet. Tap an event in the list to view details and register.';

  @override
  String get judgeEventListHint =>
      'Tap an open event to open the scoring queue.';

  @override
  String get mentorEventListHint =>
      'Tap an assigned event to open chat with participants.';

  @override
  String get allEventsSectionTitle => 'All events';

  @override
  String get journeyStepNeedsTeam => 'No team yet';

  @override
  String get journeyStepNeedsSubmission => 'Not submitted';

  @override
  String get journeyStepAwaitingScore => 'Awaiting score';

  @override
  String get journeyStepHasScore => 'Scored';

  @override
  String get journeyStepRegistrationClosed => 'Registration closed';

  @override
  String get journeyStepMissedSubmission => 'Submission deadline passed';

  @override
  String get journeyNextStepTitle => 'Next step';

  @override
  String get journeyActionJoinTeam => 'Create or join a team';

  @override
  String get journeyActionBrowseEvents => 'Browse other events';

  @override
  String get journeyActionContactOrganizer => 'Contact organizers';

  @override
  String get journeyActionSubmit => 'Submit now';

  @override
  String get journeyActionViewSubmission => 'View submission';

  @override
  String get journeyActionViewScore => 'View score';

  @override
  String get journeyActionOpenMap => 'View venue';

  @override
  String get journeyHelperRegistrationClosed =>
      'Team registration is closed. Browse other events or contact organizers.';

  @override
  String get journeyHelperMissedSubmission =>
      'Submission deadline passed. Contact organizers if you need help.';

  @override
  String get submissionReadOnlyScoreTitle => 'Scoring result';

  @override
  String get notificationActionGoTeams => 'Go to Teams';

  @override
  String get notificationActionSubmit => 'Submit';

  @override
  String get notificationActionViewScore => 'View score';

  @override
  String get notificationActionViewEvent => 'View event';

  @override
  String get notificationActionOpenJudge => 'Open scoring';

  @override
  String get submissionDraftAutoSaving => 'Auto-saving draft';

  @override
  String get clearDraftButton => 'Clear draft';

  @override
  String get draftClearedMessage => 'Draft cleared.';

  @override
  String get submitWizardStepTeam => 'Choose team';

  @override
  String get submitWizardStepProject => 'Project info';

  @override
  String get submitWizardStepLinks => 'Links & submit';

  @override
  String get submitWizardNext => 'Next';

  @override
  String get submitWizardBack => 'Back';

  @override
  String get submitWizardReviewTitle => 'Review before submit';

  @override
  String get organizerTodayModeTitle => 'Today';

  @override
  String get organizerShowDetailsButton => 'Show details';

  @override
  String get organizerHideDetailsButton => 'Collapse';

  @override
  String get roleOnboardingSkip => 'Skip';

  @override
  String get roleOnboardingStart => 'Start';

  @override
  String get roleOnboardingParticipantTitle => 'Welcome participant';

  @override
  String get roleOnboardingParticipantBody =>
      'Tap an event to start → create or accept a team invite → submit before the deadline.';

  @override
  String get roleOnboardingJudgeTitle => 'Welcome judge';

  @override
  String get roleOnboardingJudgeBody =>
      'Pick an open event → Scoring tab → select unscored submissions.';

  @override
  String get roleOnboardingOrganizerTitle => 'Welcome organizer';

  @override
  String get roleOnboardingOrganizerBody =>
      'Track unscored work, assign mentors and send announcements from Today.';

  @override
  String get roleOnboardingMentorTitle => 'Welcome mentor';

  @override
  String get roleOnboardingMentorBody =>
      'Pick your assigned event → open Chat to reply to participants.';

  @override
  String get chatMentorRequestTemplate =>
      'Hello organizers, I need a mentor assigned for my current event.';

  @override
  String get eventsSubtitle => 'Track hackathons, deadlines and details.';

  @override
  String get eventSearchHint => 'Search by name, location or topic';

  @override
  String get sortStartAsc => 'Start date: earliest';

  @override
  String get sortStartDesc => 'Start date: latest';

  @override
  String get sortTitleAsc => 'Name A → Z';

  @override
  String get sortTitleDesc => 'Name Z → A';

  @override
  String get sortDeadlineAsc => 'Deadline: soonest';

  @override
  String get sortDeadlineDesc => 'Deadline: latest';

  @override
  String get noMatchingEvents => 'No matching events.';

  @override
  String get noEventsYet => 'No events yet.';

  @override
  String get eventQuickActionsTitle => 'Quick actions';

  @override
  String get clearSearchAction => 'Clear search';

  @override
  String get reloadEventsAction => 'Reload events';

  @override
  String get registerTeamPill => 'Register team';

  @override
  String get registrationClosedPill => 'Registration closed';

  @override
  String get eventDetailTitle => 'Event details';

  @override
  String get eventDetailSubtitle => 'Timeline, rules, venue and leaderboard.';

  @override
  String get eventDetailLoadingSubtitle => 'Loading event data.';

  @override
  String get eventNotFound => 'Event not found.';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get prizeTitle => 'Prizes';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get noScoredSubmissionsYet => 'No scored submissions yet.';

  @override
  String get noSubmissionsForEventYet => 'No submissions for this event yet.';

  @override
  String get eventDetailStatsTitle => 'Event stats';

  @override
  String get eventTeamsMetric => 'Teams';

  @override
  String get eventSubmissionsMetric => 'Submissions';

  @override
  String get eventUnscoredMetric => 'Unscored';

  @override
  String get organizerShowAllEventsButton => 'Show all events';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelineRegistration => 'Registration';

  @override
  String get timelineKickoff => 'Kickoff';

  @override
  String get timelineFinal => 'Final';

  @override
  String get openJudgeQueueButton => 'View unscored';

  @override
  String get openOrganizerDashboardButton => 'Open organizer dashboard';

  @override
  String get openMentorChatButton => 'Open mentor chat';

  @override
  String get manageTeamButton => 'Create or manage team';

  @override
  String get viewMyTeamButton => 'View my team';

  @override
  String get joinOrCreateTeamButton => 'Create or join team';

  @override
  String get submitForEventButton => 'Submit for this event';

  @override
  String get myTeamForEventTitle => 'Your team';

  @override
  String get leaderboardPendingTitle => 'Unscored';

  @override
  String get awaitingScoreBadge => 'Awaiting score';

  @override
  String get judgeQueueFilteredSubtitle =>
      'Unscored submissions for the selected event.';

  @override
  String get viewVenueButton => 'View venue';

  @override
  String get eventCreatedSuccess => 'Event created.';

  @override
  String get eventUpdatedSuccess => 'Event updated.';

  @override
  String get teamTitle => 'Team';

  @override
  String get teamSubtitle =>
      'Create teams, invite members and manage participation.';

  @override
  String get teamOverviewTitle => 'Team overview';

  @override
  String get noTeamsYet => 'No teams yet';

  @override
  String get teamsAvailable => 'Available teams';

  @override
  String get checkInLabel => 'Check-in';

  @override
  String get checkInPending => 'Pending';

  @override
  String get checkInConfirmed => 'Confirmed';

  @override
  String get submitProjectButton => 'Submit';

  @override
  String get createTeamButton => 'Create team';

  @override
  String get createTeamTitle => 'Create team';

  @override
  String get eventLabel => 'Event';

  @override
  String get teamNameLabel => 'Team name';

  @override
  String get loadEventsBeforeCreateTeam =>
      'No events loaded. Load events before creating a team.';

  @override
  String get roleViewOnlyTeams => 'This role can only view teams.';

  @override
  String get emptyTeamsMessage => 'No teams yet. Create a team to continue.';

  @override
  String get myTeamsGroup => 'My teams';

  @override
  String get otherTeamsGroup => 'Other teams';

  @override
  String get teamFullBadge => 'Team full';

  @override
  String get updateTeamDialogTitle => 'Update team';

  @override
  String get leaveTeamDialogTitle => 'Leave team?';

  @override
  String get leaveTeamButton => 'Leave team';

  @override
  String get joinTeamButton => 'Join team';

  @override
  String get inviteMemberTitle => 'Invite member';

  @override
  String get memberEmailLabel => 'Member email';

  @override
  String get sendInvitationButton => 'Send invitation';

  @override
  String get invitationSendingStatus => 'Sending invitation...';

  @override
  String get teamInvitationTitle => 'Team invitation';

  @override
  String get teamCreatedNotificationTitle => 'Team created';

  @override
  String get teamCreatedSuccess => 'Team created.';

  @override
  String get teamJoinedSuccess => 'Joined team.';

  @override
  String get invitationSentSuccess => 'Invitation sent.';

  @override
  String get invitationAcceptedSuccess => 'Joined team.';

  @override
  String get invitationDeclinedSuccess => 'Invitation declined.';

  @override
  String get pendingInvitationsTitle => 'Pending invitations';

  @override
  String get pendingInvitationsEmpty => 'No team invitations.';

  @override
  String get acceptInvitationButton => 'Accept';

  @override
  String get declineInvitationButton => 'Decline';

  @override
  String get invitationStatusPending => 'Pending';

  @override
  String get invitationStatusAccepted => 'Accepted';

  @override
  String get invitationStatusDeclined => 'Declined';

  @override
  String get teamUpdatedSuccess => 'Team updated.';

  @override
  String get teamLeftSuccess => 'Left team.';

  @override
  String get invalidTeamError => 'Invalid team.';

  @override
  String get inviteUserNotFound => 'No account found with this email.';

  @override
  String get invitationAlreadyPending =>
      'This person already has a pending invite for the team.';

  @override
  String get alreadyTeamMemberError => 'You are already a member of this team.';

  @override
  String get alreadyOnEventTeamError =>
      'You are already on another team for this event. Leave your current team before joining a new one.';

  @override
  String get oneTeamPerEventBadge => 'Already on a team for event';

  @override
  String get cannotChangeOwnRole => 'You cannot change your own role.';

  @override
  String get leaveTeamRegistrationClosedError =>
      'Cannot leave team after registration closes.';

  @override
  String get invitationNoLongerPending => 'This invitation is no longer valid.';

  @override
  String get errorEventContextRequired =>
      'Could not determine event. Try again from the event screen.';

  @override
  String get errorEventEnded => 'Event ended. Cannot create or join teams.';

  @override
  String get errorRegistrationDeadlinePassed =>
      'Team registration deadline passed for this event.';

  @override
  String get errorSubmissionClosed => 'Event ended. Cannot submit or update.';

  @override
  String get errorSubmissionNotStarted =>
      'Event has not started. Cannot submit yet.';

  @override
  String get errorJudgingNotStarted =>
      'Event has not started. Cannot score yet.';

  @override
  String get errorJudgingClosed => 'Event ended. Cannot score.';

  @override
  String get teamInviteOnlyError =>
      'You can only join a team via leader invitation.';

  @override
  String get teamInviteOnlyBadge => 'Invite only';

  @override
  String get teamInviteOnlyHelper =>
      'Contact the team leader for an invitation.';

  @override
  String get submissionsRoleGateMessage => 'Only participants can submit.';

  @override
  String get submitScreenTitle => 'Submit';

  @override
  String get submitScreenSubtitle =>
      'Send GitHub link, demo video and project description for judges.';

  @override
  String get projectInfoSection => 'Project info';

  @override
  String get linksSection => 'Links';

  @override
  String get descriptionSection => 'Description';

  @override
  String get projectNameLabel => 'Project name';

  @override
  String get githubUrlLabel => 'GitHub link';

  @override
  String get demoVideoUrlLabel => 'Demo video link';

  @override
  String get projectDescriptionHint => 'What problem does the project solve?';

  @override
  String get submissionDescriptionTip =>
      'Tip: problem, solution, key features, tech stack and measurable impact.';

  @override
  String get joinTeamBeforeSubmit => 'Create or join a team before submitting.';

  @override
  String get updateSubmissionButton => 'Update submission';

  @override
  String get submitProjectAction => 'Submit';

  @override
  String get needsSubmissionStatus => 'Submission needed';

  @override
  String get noProjectSubmittedHelper => 'No submission yet.';

  @override
  String get reviewedStatus => 'Reviewed';

  @override
  String get reviewedHelper => 'Judge published feedback.';

  @override
  String get submittedStatus => 'Submitted';

  @override
  String get submittedHelper => 'Waiting for judge scoring.';

  @override
  String get notSubmittedYet => 'Not submitted';

  @override
  String get latestSubmissionTitle => 'Latest submission';

  @override
  String get selectTeamToSubmit => 'Select or create a team to submit.';

  @override
  String get goToTeamAction => 'Go to Teams';

  @override
  String get createTeamNowAction => 'Create team now';

  @override
  String get teamHasNoSubmission => 'This team has not submitted yet.';

  @override
  String get updateHistoryTitle => 'Update history';

  @override
  String get judgeFeedbackTitle => 'Judge feedback';

  @override
  String get submissionSavedNotificationTitle => 'Submission saved';

  @override
  String get submissionCreatedSuccess => 'Submitted.';

  @override
  String get submissionUpdatedSuccess => 'Submission updated.';

  @override
  String get submissionStatusReviewed => 'Reviewed';

  @override
  String get submissionStatusSubmitted => 'Submitted';

  @override
  String get submissionStatusDraft => 'Draft';

  @override
  String get submissionDraftRestored => 'Unsent draft restored.';

  @override
  String get chatRoleGateMessage =>
      'Chat is available for participants and mentors.';

  @override
  String get chatTitle => 'Mentor chat';

  @override
  String get chatSubtitle => 'Talk with mentors assigned to your event.';

  @override
  String get chatContactLabel => 'Chat with mentor';

  @override
  String get noChatContactsMessage =>
      'No mentor assigned to your event yet. Contact organizers for support.';

  @override
  String get contactOrganizerForMentorAction => 'Copy message';

  @override
  String get sendMentorRequestAction => 'Send request';

  @override
  String get mentorRequestSentSuccess =>
      'Mentor assignment request sent to organizers.';

  @override
  String get contactOrganizerHint =>
      'Contact organizers to get a mentor for the event.';

  @override
  String get chatInputHint => 'Ask mentor...';

  @override
  String get chatRealtimeConnected => 'Messages are updating';

  @override
  String get chatRealtimeConnecting => 'Opening chat';

  @override
  String get chatRealtimeOffline => 'Reload messages';

  @override
  String get reloadChatTooltip => 'Reload conversation';

  @override
  String get messageSentStatus => 'Sent';

  @override
  String get sendMessageTooltip => 'Send';

  @override
  String get yourMessageSemantic => 'Your message';

  @override
  String get deleteMessageTitle => 'Delete message?';

  @override
  String get deleteMessageBody =>
      'Your message will be removed from the conversation.';

  @override
  String get noMessagesYet => 'No messages yet.';

  @override
  String get selectConversationBeforeSend =>
      'Select a conversation before sending.';

  @override
  String get judgeRoleGateMessage => 'Only judges can access scoring.';

  @override
  String get judgeTitle => 'Scoring';

  @override
  String get judgeSubtitle =>
      'Score submissions on solution quality, UX and innovation.';

  @override
  String get filterUnscored => 'Unscored';

  @override
  String get filterScored => 'Scored';

  @override
  String get judgeSearchLabel => 'Search submission or team';

  @override
  String get noMatchingSubmissions => 'No matching submissions.';

  @override
  String get showAllSubmissions => 'Show all';

  @override
  String get selectSubmissionTitle => 'Select submission';

  @override
  String get nextUnscoredButton => 'Next unscored';

  @override
  String get selectSubmissionToScore => 'Select a submission to score.';

  @override
  String get needsScoringBadge => 'Needs scoring';

  @override
  String get repositoryButton => 'Source code';

  @override
  String get demoButton => 'Demo video';

  @override
  String get rubricEvaluationTitle => 'Rubric';

  @override
  String get feedbackLabel => 'Feedback';

  @override
  String get updateScoreDialogTitle => 'Update old score?';

  @override
  String get currentScoreLabel => 'Current score';

  @override
  String get feedbackReady => 'Ready';

  @override
  String get feedbackMissing => 'Missing';

  @override
  String get submitScoreButton => 'Submit score';

  @override
  String get updateScoreButton => 'Update score';

  @override
  String get scoringProgressTitle => 'Scoring progress';

  @override
  String get scorePublishedNotificationTitle => 'Score published';

  @override
  String get scorePublishedSnackBar => 'Score published for submission.';

  @override
  String get scoreSavedSuccess => 'Score saved.';

  @override
  String get judgeScoreParticipantHint =>
      'Participants open notifications to view score and feedback.';

  @override
  String get scoreNotificationDialogTitle => 'Scoring result';

  @override
  String get announcementNotificationDialogTitle =>
      'Announcement from organizers';

  @override
  String get viewSubmissionButton => 'View submission';

  @override
  String get closeDialogButton => 'Close';

  @override
  String get organizerRoleGateMessage =>
      'Only organizers can access operations.';

  @override
  String get organizerTitle => 'Organizer';

  @override
  String get organizerSubtitle =>
      'Track events, team progress and scoring status.';

  @override
  String get sectionOverview => 'Overview';

  @override
  String get sectionOperations => 'Operations';

  @override
  String get sectionSubmissions => 'Submissions';

  @override
  String get sectionEvents => 'Events';

  @override
  String get sectionTeams => 'Teams';

  @override
  String get sendAnnouncementButton => 'Send announcement';

  @override
  String get sendAnnouncementDialogTitle => 'Send announcement';

  @override
  String get recipientLabel => 'Recipients';

  @override
  String get notificationTitleLabel => 'Title';

  @override
  String get notificationContentLabel => 'Content';

  @override
  String get announcementPreviewTitle => 'Preview announcement';

  @override
  String get confirmSendAnnouncementButton => 'Confirm send';

  @override
  String get announcementSendingStatus => 'Sending announcement...';

  @override
  String get recipientCountLabel => 'Recipient count';

  @override
  String get createEventTitle => 'Create event';

  @override
  String get editEventTitle => 'Edit event';

  @override
  String get eventFieldTitle => 'Title';

  @override
  String get eventFieldDescription => 'Description';

  @override
  String get eventFieldLocation => 'Location';

  @override
  String get eventFieldBannerUrl => 'Banner URL';

  @override
  String get eventFieldStartDate => 'Start date';

  @override
  String get eventFieldEndDate => 'End date';

  @override
  String get eventFieldRegistrationDeadline => 'Registration deadline';

  @override
  String get eventFieldSubmissionDeadline => 'Submission deadline';

  @override
  String get eventFieldSupportHotline => 'Support hotline';

  @override
  String get eventFieldOpeningHours => 'Opening hours';

  @override
  String get eventFieldMaxTeamSize => 'Max team size';

  @override
  String get eventFieldRules => 'Rules';

  @override
  String get eventFieldPrize => 'Prize';

  @override
  String get eventFieldLatitude => 'Latitude';

  @override
  String get eventFieldLongitude => 'Longitude';

  @override
  String get selectOnMapButton => 'Pick on map';

  @override
  String get eventStepInfo => 'Info';

  @override
  String get eventStepBanner => 'Banner';

  @override
  String get eventStepLocation => 'Location';

  @override
  String get eventStepTime => 'Schedule';

  @override
  String get uploadBannerTooltip => 'Upload image';

  @override
  String get uploadBannerButton => 'Upload image';

  @override
  String get changeBannerButton => 'Change image';

  @override
  String get removeBannerButton => 'Remove image';

  @override
  String get bannerUploadSuccess => 'Banner uploaded successfully.';

  @override
  String get uploadBannerFailed =>
      'Could not upload image. Check Storage configuration.';

  @override
  String get advancedCoordinatesTitle => 'Advanced: coordinates';

  @override
  String get invalidEventDatesSnackBar =>
      'Invalid event dates. Check the format.';

  @override
  String get closeRegistrationTitle => 'Close registration?';

  @override
  String get closeRegistrationSuccess => 'Registration closed for this event.';

  @override
  String get recentSubmissionsTitle => 'Recent submissions';

  @override
  String get noSubmissionsYet => 'No submissions yet.';

  @override
  String get openTeamAction => 'Open team';

  @override
  String get teamDetailsTitle => 'Team details';

  @override
  String get noTeamsToView => 'No teams to view.';

  @override
  String get leaderboardCopiedSuccess => 'Leaderboard copied.';

  @override
  String get manageUserRolesTitle => 'Manage user roles';

  @override
  String get createStaffAccountTitle => 'Create judge/mentor account';

  @override
  String get createStaffAccountButton => 'Create account';

  @override
  String get createStaffAccountFailed =>
      'Could not create account. Check admin-create-user Edge Function.';

  @override
  String get noUsersYet => 'No users yet.';

  @override
  String get changeRoleDialogTitle => 'Change account role?';

  @override
  String get exportLeaderboardTitle => 'Export leaderboard';

  @override
  String get userRolesTitle => 'User roles';

  @override
  String get userSearchLabel => 'Search name or email';

  @override
  String get roleFilterLabel => 'Filter role';

  @override
  String get noMatchingUsers => 'No matching accounts.';

  @override
  String get manageScoreCriteriaTitle => 'Manage scoring criteria';

  @override
  String get manageEventMentorsTitle => 'Assign event mentors';

  @override
  String get manageEventMentorsDescription =>
      'Pick mentors to support participants per hackathon';

  @override
  String get noEventsForMentorAssignment => 'No events to assign mentors.';

  @override
  String get noMentorsAvailableMessage =>
      'No mentor accounts. Create or assign roles first.';

  @override
  String get mentorAssignmentLoadFailed => 'Could not load assigned mentors.';

  @override
  String get manageScoreCriteriaDescription =>
      'Create a custom rubric per event';

  @override
  String get addScoreCriterionButton => 'Add criterion';

  @override
  String get scoreCriterionLabel => 'Criterion name';

  @override
  String get scoreCriterionDescription => 'Criterion description';

  @override
  String get scoreCriteriaSavedSuccess => 'Scoring criteria saved.';

  @override
  String get defaultRubricHint =>
      'This event uses the default rubric. Organizers can edit and save a custom rubric.';

  @override
  String get useDefaultRubricButton => 'Use default rubric';

  @override
  String get unscoredMetricLabel => 'Unscored';

  @override
  String get organizerTodayTasksTitle => 'Tasks for today';

  @override
  String get organizerUnscoredTasksLabel => 'Unscored submissions';

  @override
  String get organizerTeamsNeedMembersLabel => 'Teams need members';

  @override
  String get organizerClosingSoonLabel => 'Registration closing soon';

  @override
  String get organizerSendReminderButton => 'Send reminder';

  @override
  String get organizerAssignMentorButton => 'Assign mentor';

  @override
  String get organizerTaskUnscoredLabel => 'Scoring reminder';

  @override
  String get organizerTaskTeamsLabel => 'Team reminder';

  @override
  String get organizerTaskClosingLabel => 'Registration reminder';

  @override
  String get otherActionsTitle => 'Other actions';

  @override
  String get dashboardChartTitle => 'Scoring overview';

  @override
  String get scoredBarLabel => 'Scored';

  @override
  String get unscoredBarLabel => 'Unscored';

  @override
  String get loadMoreButton => 'Load more';

  @override
  String get announcementEventLabel => 'Link event (optional)';

  @override
  String get announcementNoEvent => 'No linked event';

  @override
  String get viewEventFromAnnouncementButton => 'View event';

  @override
  String get announcementTemplatesLabel => 'Quick templates';

  @override
  String get announcementTemplateJudgingLabel => 'Open judging';

  @override
  String get announcementTemplateJudgingTitle => 'Judging room open';

  @override
  String get announcementTemplateJudgingBody =>
      'Judges please open the Scoring tab. Official judging session is open.';

  @override
  String get announcementTemplateDeadlineLabel => 'Deadline';

  @override
  String get announcementTemplateDeadlineTitle =>
      'Submission deadline reminder';

  @override
  String get announcementTemplateDeadlineBody =>
      'Teams that have not submitted please finish GitHub, demo video and description before the deadline.';

  @override
  String get announcementTemplateKickoffLabel => 'Kickoff';

  @override
  String get announcementTemplateKickoffTitle => 'Hackathon kickoff';

  @override
  String get announcementTemplateKickoffBody =>
      'Welcome teams to SEAL Innovation Hackathon 2026. Check Events for schedule and rules.';

  @override
  String get newScoreSnackBar =>
      'New score available. Open notifications to view.';

  @override
  String get openInboxAction => 'View notifications';

  @override
  String get inboxTitle => 'Notifications';

  @override
  String get inboxSubtitle => 'Scores, team invites and system updates.';

  @override
  String get inboxEmpty => 'No notifications yet.';

  @override
  String get reloadInboxAction => 'Reload notifications';

  @override
  String get unreadGroup => 'Unread';

  @override
  String get readGroup => 'Read';

  @override
  String get markAsReadAction => 'Mark as read';

  @override
  String get deleteNotificationTitle => 'Delete notification?';

  @override
  String get deleteNotificationBody =>
      'This item will be removed from the list.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSubtitle => 'Manage account info used across role flows.';

  @override
  String get noActiveSession => 'No active session.';

  @override
  String get roleLabel => 'Role';

  @override
  String get accountInfoTitle => 'Account info';

  @override
  String get saveProfileButton => 'Save profile';

  @override
  String get profileUpdatedSuccess => 'Profile updated.';

  @override
  String get profileSecurityTitle => 'Security';

  @override
  String get profileSecuritySubtitle =>
      'Send password reset email to registered address. Contact organizers to change email.';

  @override
  String get themeModeTitle => 'Appearance';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeSystem => 'System';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageVi => 'Vietnamese';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => 'Japanese';

  @override
  String get sessionSectionTitle => 'Session';

  @override
  String get logoutDescription =>
      'Signing out clears local state and returns to sign in.';

  @override
  String get mapTitle => 'Venue';

  @override
  String get mapSubtitle => 'Map, address and directions.';

  @override
  String get noVenueYet => 'No event venue yet.';

  @override
  String get addressLabel => 'Address';

  @override
  String get openingHoursLabel => 'Opening hours';

  @override
  String get hotlineLabel => 'Hotline';

  @override
  String get coordinatesLabel => 'Coordinates';

  @override
  String get defaultOpeningHours => '08:00 - 18:00';

  @override
  String get defaultHotline => '0900 000 000';

  @override
  String get copyAddressButton => 'Copy address';

  @override
  String get addressCopiedSuccess => 'Address copied.';

  @override
  String get openMapsButton => 'Open Maps';

  @override
  String get openExternalMapsTitle => 'Open external Maps?';

  @override
  String get openExternalMapsBody =>
      'You will temporarily leave SEAL Hackathon to open Maps.';

  @override
  String get mapPickerTitle => 'Pick event location';

  @override
  String get mapPickerInstruction =>
      'Drag the map to place the pin at the event location';

  @override
  String get openMapsFailed => 'Could not open Maps on this device.';

  @override
  String get validationEmailRequired => 'Enter email.';

  @override
  String get validationEmailInvalid => 'Enter a valid email.';

  @override
  String get validationPasswordRequired => 'Enter password.';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 6 characters.';

  @override
  String get validationConfirmPasswordRequired => 'Confirm password.';

  @override
  String get validationPasswordMismatch => 'Passwords do not match.';

  @override
  String get validationOtpRequired => 'Enter OTP from email.';

  @override
  String get validationOtpInvalid => 'OTP must be 6 digits.';

  @override
  String get validationFullNameRequired => 'Enter full name.';

  @override
  String get validationFullNameMinLength =>
      'Full name must be at least 2 characters.';

  @override
  String get validationUniversityRequired => 'Enter university.';

  @override
  String get validationUniversityMinLength =>
      'University must be at least 2 characters.';

  @override
  String get validationSupabaseNotReady =>
      'Cannot connect to system. Try again later.';

  @override
  String get validationTeamNameRequired => 'Enter team name.';

  @override
  String get validationTeamNameMinLength =>
      'Team name must be at least 2 characters.';

  @override
  String get validationInviteEmailInvalid => 'Enter a valid member email.';

  @override
  String get validationProjectNameRequired => 'Enter project name.';

  @override
  String get validationProjectNameMinLength =>
      'Project name must be at least 2 characters.';

  @override
  String get validationDescriptionRequired => 'Enter project description.';

  @override
  String get validationDescriptionMinLength =>
      'Description must be at least 10 characters.';

  @override
  String get validationJoinTeamBeforeSubmit =>
      'Create or join a team before submitting.';

  @override
  String get eventNotLoadedForSubmit =>
      'Could not load team event info. Try reloading events.';

  @override
  String get validationChatMessageRequired => 'Message cannot be empty.';

  @override
  String get validationNotificationTitleRequired => 'Enter notification title.';

  @override
  String get validationNotificationBodyRequired => 'Enter notification body.';

  @override
  String get validationNotificationTypeInvalid => 'Invalid notification type.';

  @override
  String get validationRecipientLabel => 'Recipients';

  @override
  String get validationEventTitleRequired => 'Enter event title.';

  @override
  String get validationEventTitleMinLength =>
      'Event title must be at least 2 characters.';

  @override
  String get validationEventLocationRequired => 'Enter event location.';

  @override
  String get validationEventLocationMinLength =>
      'Location must be at least 2 characters.';

  @override
  String get validationLatitudeRequired => 'Enter latitude.';

  @override
  String get validationLatitudeInvalid => 'Latitude must be a valid number.';

  @override
  String get validationLatitudeRange => 'Latitude must be between -90 and 90.';

  @override
  String get validationLongitudeRequired => 'Enter longitude.';

  @override
  String get validationLongitudeInvalid => 'Longitude must be a valid number.';

  @override
  String get validationLongitudeRange =>
      'Longitude must be between -180 and 180.';

  @override
  String get validationMaxTeamSizeRequired => 'Enter max team size.';

  @override
  String get validationMaxTeamSizeInvalid =>
      'Max team size must be a valid integer.';

  @override
  String get validationEndAfterStart => 'End date must be after start date.';

  @override
  String get validationDeadlineBeforeEnd =>
      'Registration deadline cannot be after event end.';

  @override
  String get validationSubmissionAfterStart =>
      'Submission deadline must be after event start.';

  @override
  String get validationSubmissionBeforeEnd =>
      'Submission deadline cannot be after event end.';

  @override
  String get validationScoreRange => 'Score must be between 0 and 10.';

  @override
  String get validationScoreCriteriaRequired =>
      'At least one scoring criterion required.';

  @override
  String get validationScoreCriteriaLimit =>
      'Maximum 8 scoring criteria per event.';

  @override
  String get validationScoreCriteriaLabelRequired => 'Enter criterion name.';

  @override
  String get validationScoreCriteriaDuplicate =>
      'Duplicate criterion id. Remove and add again.';

  @override
  String get validationScoreCriteriaWeight =>
      'Criterion weight must be greater than 0.';

  @override
  String get validationNoSubmissionSelected =>
      'No submission selected to score.';

  @override
  String get validationInvalidJudgeSession => 'Invalid judge session.';

  @override
  String get validationFeedbackRequired =>
      'Enter feedback before submitting score.';

  @override
  String get validationInvalidRole => 'Invalid role.';

  @override
  String get validationUserLabel => 'User';

  @override
  String get validationBannerUrlLabel => 'Banner URL';

  @override
  String get openLinkTooltip => 'Open link to verify';

  @override
  String get openLinkFailed => 'Could not open this link.';

  @override
  String get openExternalLinkFailed => 'Could not open link on this device.';

  @override
  String get reloadTeamsTooltip => 'Reload teams';

  @override
  String get reloadJudgeQueueTooltip => 'Reload unscored queue';

  @override
  String get reloadDashboardTooltip => 'Reload dashboard';

  @override
  String get judgePreviewOnlyMessage =>
      'Sign in as Judge to submit official scores.';

  @override
  String get judgeQueueSortLabel => 'Sort unscored queue';

  @override
  String get sortNewestFirst => 'Newest first';

  @override
  String get sortProjectName => 'Project name';

  @override
  String get sortTeamName => 'Team';

  @override
  String get sortAverageScore => 'Average score';

  @override
  String get judgeSubmissionToScoreLabel => 'Submission to score';

  @override
  String get unknownTeamLabel => 'Unknown team';

  @override
  String get teamNotLoadedYet => 'Team not loaded';

  @override
  String get eventNotLoadedYet => 'Event not loaded';

  @override
  String get averageScoreAbbrev => 'Avg';

  @override
  String get judgeReviewReminder =>
      'Review source code, demo quality, implementation depth and product impact before submitting.';

  @override
  String get rubricTechnicalLabel => 'Solution quality';

  @override
  String get rubricTechnicalDescription =>
      'Architecture, correctness, reliability and implementation depth.';

  @override
  String get rubricUiLabel => 'User experience';

  @override
  String get rubricUiDescription =>
      'Mobile flow, clarity, accessibility and polish.';

  @override
  String get rubricInnovationLabel => 'Innovation';

  @override
  String get rubricInnovationDescription =>
      'Novelty, impact, useful AI/automation and product fit.';

  @override
  String get decreaseScoreTooltip => 'Decrease';

  @override
  String get increaseScoreTooltip => 'Increase';

  @override
  String get editEventMenuItem => 'Edit event';

  @override
  String get closeRegistrationMenuItem => 'Close registration';

  @override
  String get closeRegistrationConfirmButton => 'Close registration';

  @override
  String get notificationActionsTooltip => 'Notification options';

  @override
  String get eventActionsTooltip => 'Event actions';

  @override
  String get submissionsMetricLabel => 'Submissions';

  @override
  String get scoresMetricLabel => 'Score count';

  @override
  String get systemStatusTitle => 'System status';

  @override
  String get systemStatusSubtitle => 'Track data status and updates.';

  @override
  String get chatSuggestionSubmission => 'Ask about submission';

  @override
  String get chatSuggestionGithub => 'Help review GitHub link';

  @override
  String get chatSuggestionChecklist => 'Submission checklist';

  @override
  String get emailPrefix => 'Email:';

  @override
  String get averageScoreTitle => 'Average score';

  @override
  String get judgeQueueTitle => 'Unscored queue';

  @override
  String get judgeQueueWaitingSuffix => ' unscored submissions';

  @override
  String get exportLeaderboardDescription =>
      'Copy leaderboard data to clipboard';

  @override
  String get userRolesDescription => 'View and update account roles';

  @override
  String get databaseConnectedLabel => 'Data ready';

  @override
  String get databaseMissingLabel => 'No data yet';

  @override
  String get operationsDataLabel => 'Operations data';

  @override
  String get syncingLabel => 'Updating';

  @override
  String get stateReadyLabel => 'Ready';

  @override
  String get notLoggedInShortLabel => 'Not signed in';

  @override
  String get noApiErrorsLabel => 'No data load errors';

  @override
  String get systemStatusSemanticLabel => 'System operations status';

  @override
  String get profileFullNameFieldSemantic => 'Profile full name field';

  @override
  String get profileUniversityFieldSemantic => 'Profile university field';

  @override
  String get errorInvalidCredentials =>
      'Incorrect email or password. Use your registered email or tap \"Create new account\".';

  @override
  String get errorEmailNotConfirmed =>
      'Email not confirmed. Check inbox or spam.';

  @override
  String get errorInvalidOtp =>
      'Invalid or expired OTP. Request a new activation email.';

  @override
  String get errorConnectionTimeout =>
      'Connection timed out. Check network and try again.';

  @override
  String get errorRlsPermissionDenied =>
      'Your account cannot perform this action.';

  @override
  String get errorDuplicateRecord =>
      'This data already exists. Reload and update the existing record.';

  @override
  String get errorCheckConstraint =>
      'Invalid data. Check your input and try again.';

  @override
  String get otpHelpText =>
      'The OTP is in your activation email. Check inbox or spam if you do not see it.';

  @override
  String teamOverviewForEvent(String title) {
    return 'Team — $title';
  }

  @override
  String scopedTeamsAvailable(int count) {
    return '$count teams in this event';
  }

  @override
  String pendingInvitationsCount(int count) {
    return '$count pending invitations';
  }

  @override
  String eventScheduleHours(String start, String end) {
    return '$start - $end';
  }

  @override
  String activationEmailSent(String email) {
    return 'Activation email sent to $email. Enter the 6-digit OTP from the email below.';
  }

  @override
  String emailActivatedWelcome(String email) {
    return 'Email activated. Welcome $email!';
  }

  @override
  String passwordResetEmailSent(String email) {
    return 'Password reset link sent to $email. Check your inbox or spam folder.';
  }

  @override
  String registerSuccess(String email) {
    return 'Registration successful with $email.';
  }

  @override
  String organizerFocusEventSubtitle(String title) {
    return 'Filtering by $title.';
  }

  @override
  String submissionEventLabel(String title) {
    return 'Event: $title';
  }

  @override
  String judgeQueueForEventTitle(String title) {
    return 'Scoring: $title';
  }

  @override
  String openEventSemanticLabel(String title) {
    return 'Open event $title';
  }

  @override
  String registerBeforeDate(String date) {
    return 'Register before $date';
  }

  @override
  String registrationClosedByDate(String date) {
    return 'Registration closed $date';
  }

  @override
  String registrationOpenUntilDate(String date) {
    return 'Registration open until $date';
  }

  @override
  String maxMembersChip(int count) {
    return 'Up to $count members';
  }

  @override
  String leaderPrefix(String name) {
    return 'Leader: $name';
  }

  @override
  String memberCountLabel(int count) {
    return '$count members';
  }

  @override
  String teamSemanticLabel(String name, String memberCount, String leader) {
    return 'Team $name, $memberCount members, Leader: $leader';
  }

  @override
  String inviteTeamPrefix(String name) {
    return 'Team: $name';
  }

  @override
  String leaveTeamDialogBody(String teamName) {
    return 'You will leave $teamName. After registration closes you cannot rejoin.';
  }

  @override
  String teamInvitationBody(String teamName) {
    return 'You are invited to $teamName. Open Teams to view and join if spots remain.';
  }

  @override
  String invitedByLabel(String name) {
    return 'Invited by: $name';
  }

  @override
  String teamCreatedNotificationBody(String teamName, String eventTitle) {
    return '$teamName joined $eventTitle.';
  }

  @override
  String alreadyOnEventTeamNamedError(String teamName) {
    return 'You are already on team $teamName for this event.';
  }

  @override
  String teamFullForEventError(String teamName) {
    return '$teamName is full for this event.';
  }

  @override
  String submissionSavedNotificationBody(String projectName) {
    return '$projectName was submitted successfully.';
  }

  @override
  String chatEventScopedSubtitle(String eventTitle) {
    return 'Conversation for event $eventTitle';
  }

  @override
  String mentorRequestNotificationTitle(String participantName) {
    return 'Mentor request: $participantName';
  }

  @override
  String todayTimestamp(String time) {
    return 'Today, $time';
  }

  @override
  String scoreOutOfTenLabel(String score) {
    return '$score/10';
  }

  @override
  String scoreWeightLabel(String weight) {
    return 'Weight x$weight';
  }

  @override
  String updateScoreDialogBody(String projectName) {
    return 'Your previous score for $projectName will be replaced.';
  }

  @override
  String closeRegistrationBody(String title) {
    return 'Registration deadline for $title will be set to now.';
  }

  @override
  String announcementSentSuccess(int count) {
    return 'Announcement sent to $count users.';
  }

  @override
  String announcementRolePreview(String role) {
    return 'Send to: $role';
  }

  @override
  String recipientCountValue(int count) {
    return '$count accounts';
  }

  @override
  String changeRoleDialogBody(String name, String role) {
    return 'Assign $name as $role.';
  }

  @override
  String roleUpdatedSuccess(String name) {
    return 'Updated role for $name.';
  }

  @override
  String cannotChangeOwnRoleSubtitle(String email) {
    return '$email\nYou cannot change your own role.';
  }

  @override
  String sendPasswordResetTo(String email) {
    return 'Send password reset link to $email';
  }

  @override
  String mapPickerCoordinates(String latitude, String longitude) {
    return 'Coordinates: $latitude, $longitude';
  }

  @override
  String coordinatesPreview(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String staffAccountCreatedSuccess(String name) {
    return 'Created account for $name.';
  }

  @override
  String mentorAssignmentSavedSuccess(int count) {
    return 'Assigned $count mentors to the event.';
  }

  @override
  String organizerTaskUnscoredTitle(String eventTitle) {
    return 'Scoring reminder — $eventTitle';
  }

  @override
  String organizerTaskUnscoredBody(int count) {
    return '$count submissions still unscored. Please finish scoring today.';
  }

  @override
  String organizerTaskTeamsTitle(String eventTitle) {
    return 'Team reminder — $eventTitle';
  }

  @override
  String organizerTaskTeamsBody(int count) {
    return '$count teams still need members. Invite participants before the deadline.';
  }

  @override
  String organizerTaskClosingTitle(String eventTitle) {
    return 'Registration closing — $eventTitle';
  }

  @override
  String organizerTaskClosingBody(int count) {
    return '$count events close registration within 3 days. Finish registration early.';
  }

  @override
  String organizerNotificationSuggestions(int count) {
    return '$count suggested announcements';
  }

  @override
  String journeyScoreSummary(String score) {
    return 'Average score: $score';
  }

  @override
  String submissionDraftSavedAt(String time) {
    return 'Draft saved at $time';
  }

  @override
  String validationSearchMaxLength(int max) {
    return 'Search keyword max $max characters.';
  }

  @override
  String validationInvalidUser(String label) {
    return '$label is invalid.';
  }

  @override
  String validationFieldRequired(String label) {
    return 'Enter $label.';
  }

  @override
  String validationInvalidUrl(String label) {
    return '$label must be a valid http/https URL.';
  }

  @override
  String validationTeamNameMaxLength(int max) {
    return 'Team name max $max characters.';
  }

  @override
  String validationProjectNameMaxLength(int max) {
    return 'Project name max $max characters.';
  }

  @override
  String validationDescriptionMaxLength(int max) {
    return 'Description max $max characters.';
  }

  @override
  String validationChatMessageMaxLength(int max) {
    return 'Message max $max characters.';
  }

  @override
  String validationNotificationTitleMaxLength(int max) {
    return 'Title max $max characters.';
  }

  @override
  String validationNotificationBodyMaxLength(int max) {
    return 'Body max $max characters.';
  }

  @override
  String validationFeedbackMaxLength(int max) {
    return 'Feedback max $max characters.';
  }

  @override
  String validationMaxTeamSizeRange(int min, int max) {
    return 'Max team size must be between $min and $max.';
  }

  @override
  String validationDateTimeFormat(String label, String format) {
    return '$label must use format $format (e.g. 2026-06-15 09:00).';
  }

  @override
  String submissionQueueCountLabel(int count) {
    return '$count submissions in this queue';
  }

  @override
  String scoreCountLabel(int count) {
    return '$count scores';
  }

  @override
  String scoringProgressSemantic(int scored, int unscored) {
    return 'Scoring progress: $scored scored and $unscored unscored';
  }

  @override
  String memberCountWithLimit(int current, int limit) {
    return '$current/$limit members';
  }

  @override
  String apiErrorCountLabel(int count) {
    return '$count errors';
  }

  @override
  String judgeQueueWaitingLabel(int count) {
    return '$count unscored submissions';
  }

  @override
  String scoreSliderSemantic(String label, String value, String description) {
    return '$label $value points. $description';
  }

  @override
  String messageTimestampSemantic(String senderLabel, String time) {
    return '$senderLabel at $time';
  }
}
