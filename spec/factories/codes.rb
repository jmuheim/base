FactoryGirl.define do
  factory :code do
    title       'Code test title'
    identifier  'Code test identifier'
    description 'Code test description'
    html        'Code test html'
    css         'Code test css'
    js          'Code test js'
    creator_id 0
  end
end
