# Backlog Transition Net

## Do not forget to...

- Use `build_stubbed` method to create test data whenever possible!
  - Make sure that relationships are also created using the selected build/create strategy, see http://stackoverflow.com/questions/13308768!
- Use `it { should accept_nested_attributes_for :bla }` in specs!
- Add git push hook to automatically execute rip_hashrocket
- Add git push hook to automatically execute rails_best_practices
- Add git push hook to automatically execute rubocop
- validate_uniqueness_of needs an existing record at the moment but should be optimized in future, see https://github.com/thoughtbot/shoulda-matchers/issues/194
