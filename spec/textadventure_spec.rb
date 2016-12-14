require './textadventure'

RSpec.describe 'a tale' do
  before do 
    TextAdventure.tale = TextAdventure::Tale.new(nil, Hash.new, nil)
  end

  it 'has an intro' do
    Introduction 'Slowly your eyes creak open.'

    expect(TextAdventure.tale.introduction).to eq TextAdventure::SectionData.new(
      :intro,
       'Slowly your eyes creak open.',
      {}
    )
  end

  INTRO_TEXT = 'Slowly your eyes creak open.'
  sample_intro = TextAdventure::SectionData.new(:intro, INTRO_TEXT, {})

  before do 
    Introduction INTRO_TEXT
  end

  it 'has sections' do
    Section 'The Manor' -
      'You arrive just in time to see the door swing shut before you.'

    expect(TextAdventure.tale.sections).to eq ({
      :intro => sample_intro,
      'The Manor' => TextAdventure::SectionData.new(
        'The Manor', 'You arrive just in time to see the door swing shut before you.', {})
    })
  end

  it 'gives choices at the end of each section' do
    Section 'The Manor' -
      'You arrive just in time to see the door swing shut before you.'

    Choose to 'weep openly', seek: 'Despair'
    Choose to 'look for an alternative means of egress', seek: 'The Kitchen'

    expect(TextAdventure.tale.sections).to eq ({
      :intro => sample_intro,
      'The Manor' => TextAdventure::SectionData.new(
        'The Manor',
        'You arrive just in time to see the door swing shut before you.',
        { 'weep openly' => 'Despair', 'look for an alternative means of egress' => 'The Kitchen' })
    })
  end

  it 'ends as described' do
    Section 'The Kitchen' -
      'The snacks are delicious.'
      
      Thus ends 'Terrors of the Halls'

    expect(TextAdventure.tale.sections).to eq({
      :intro => sample_intro,
      'The Kitchen' => TextAdventure::SectionData.new(
        'The Kitchen',
        'The snacks are delicious.',
        :end)
    })
  end
end

