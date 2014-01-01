# Backlog Transition Net

## Do not forget to...

- Use `build_stubbed` method to create test data whenever possible!
  - Make sure that relationships are also created using the selected build/create strategy, see http://stackoverflow.com/questions/13308768!
- Use `it { should accept_nested_attributes_for :bla }` in specs!
- Add git push hook to automatically execute rip_hashrocket
