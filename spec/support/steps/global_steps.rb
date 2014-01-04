step 'Pry' do
  binding.pry
end

step 'the page should be valid HTML5' do
  expect(page.body).to be_valid_markup
end

step 'the CSS should be valid' do
  visit '/assets/application.css'
  expect(page.body).to be_valid_css3
end
