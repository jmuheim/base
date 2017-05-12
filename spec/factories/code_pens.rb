FactoryGirl.define do
  factory :code_pen do
    title       'CodePen test title'
    identifier  'CodePen test identifier'
    description 'CodePen test description'
    html        'CodePen test html'
    css         'CodePen test css'
    js          'CodePen test js'
    creator_id 0
  end
end
