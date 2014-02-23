# Backlog Base Project

## Do not forget to...

- Use `build_stubbed` method to create test data whenever possible!
  - Make sure that relationships are also created using the selected build/create strategy, see http://stackoverflow.com/questions/13308768!
- Use `it { should accept_nested_attributes_for :bla }` in specs!
- Add git hook to automatically execute rip_hashrocket
- Add git hook to automatically execute rails_best_practices
- Add git hook to automatically execute rubocop
- Add source maps for [CoffeeScript](https://github.com/markbates/coffee-rails-source-maps/) and [Sass](https://github.com/vhyza/sass-rails-source-maps) (both gems seem not to work at the moment)
- Spring should be integrated into Rails 4.1?! Do we have to un-integrate our version?
- Do a `bundle outdated` from time to time and update the gems!
- Check back from time to time if SimpleForm officially supports Bootstrap3 now, and then refactor `simple_form_bootstrap.rb.`

## Known issues

- Guard config doesn't properly reload after change (manual restart needed), see https://github.com/guard/guard/issues/540
- validate_uniqueness_of needs an existing record at the moment but should be optimized in future, see https://github.com/thoughtbot/shoulda-matchers/issues/194

## Ideas/Brainstorming (with Markus)

- Gemüse-Abo
- Arbeitsgruppen/Workshops
- Artikel zu verschiedensten Themen
- Spiritualität / Schamanismus / Sexualität
- Urban Gardening
- Food-Coop.
- Leserbeiträge (Blogs?)
- Permakultur
- Eigene Währung (Minuto)
- Newsletter => automatisch generieren für jeden Benutzer aus den Themen, welche dieser angekreuzt hat
- Base Town => verschiedene Städte vernetzen?
- Gemeinschaften
- Sinnvolle Inserate & Werbung mit Mehrwert für Benutzer
- Partnerbörse
- Strohballenbau
- Kleininserate aller Art
- WG-/Wohnungs-/Hausbörse
- Events Kalender (bspw. mit Filme für die Erde)
- Liste: lokal einkaufen (bei Bauern, etc.)