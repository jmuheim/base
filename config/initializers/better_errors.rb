# https://github.com/WizardOfOgz/atom-handler#integrating-with-bettererrors
if defined? BetterErrors
  # Atom
  # BetterErrors.editor = "atm://open?url=file://%{file}&line=%{line}"

  # TextMate
  BetterErrors.editor = :txmt
end
