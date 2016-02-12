# https://github.com/WizardOfOgz/atom-handler#integrating-with-bettererrors
if defined? BetterErrors
  BetterErrors.editor = "atm://open?url=file://%{file}&line=%{line}"
end
