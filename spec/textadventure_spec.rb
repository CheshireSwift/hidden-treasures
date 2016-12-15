require './textadventure'

RSpec.describe 'a tale' do
  context 'when being told' do
    before(:each) do 
      TextAdventure.begin_tale 'A Little Ditty'
    end
  
    it 'has an intro' do
      Introduction 'Slowly your eyes creak open.'
  
      expect(TextAdventure.tale.introduction).to eq TextAdventure::SectionData.new(
        :intro,
         'Slowly your eyes creak open.',
        {}
      )
    end
    
    context 'that has been introduced' do
      INTRO_TEXT = 'Slowly your eyes creak open.'
      sample_intro = TextAdventure::SectionData.new(:intro, INTRO_TEXT, {})
    
      before(:each) do 
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
    
        expect(TextAdventure.tale.sections['The Manor'].choices).to eq ({
          'weep openly' => 'Despair',
          'look for an alternative means of egress' => 'The Kitchen'
        })
      end
      
      it 'can have self-describing choices' do
        Section 'The Manor' -
          'You arrive just in time to see the door swing shut before you.'
    
        Choose to seek: 'Despair'
    
        expect(TextAdventure.tale.sections['The Manor'].choices).to eq ({
          'seek Despair' => 'Despair'
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
      
      it 'can access choices by string' do
        Section 'The Manor' -
          'You arrive just in time to see the door swing shut before you.'
    
        Choose to seek: 'Despair'
        
        expect(
          TextAdventure.tale.sections['The Manor'].choices['seek Despair']
        ).to eq 'Despair'
      end
    end
  end
    
  it 'can be told in its entirety' do
    So begins 'The Terrors of the Halls'
    
    Introduction 'Slowly your eyes creak open.'
      Choose to seek: 'The Manor'
    
    Section 'The Manor' -
      'You arrive just in time to see the door swing shut before you.'
    
      Choose to 'weep openly', seek: 'Despair'
      Choose to 'look for an alternative means of egress', seek: 'The Kitchen'
    
    Section 'Despair' -
      'You cry a bit. You feel better (maybe?). Let\'s get back to that manor.'
      
      Choose to 'pull yourself together', seek: 'The Manor'
      Choose to 'continue crying', seek: 'Despair'
    
    Section 'The Kitchen' -
      'The snacks are delicious.'
    
      Thus ends 'Terrors of the Halls'
    
    expect(TextAdventure.tale.title).to eq('The Terrors of the Halls')
    expect(TextAdventure.tale.sections).to eq({
      :intro => TextAdventure::SectionData.new(:intro, 'Slowly your eyes creak open.', { 'seek The Manor' => 'The Manor' }),
      'The Manor' => TextAdventure::SectionData.new('The Manor', 'You arrive just in time to see the door swing shut before you.', {
        'weep openly' => 'Despair',
        'look for an alternative means of egress' => 'The Kitchen'
      }),
      'Despair' => TextAdventure::SectionData.new('Despair', 'You cry a bit. You feel better (maybe?). Let\'s get back to that manor.', {
        'pull yourself together' => 'The Manor',
        'continue crying' => 'Despair'
      }),
      'The Kitchen' => TextAdventure::SectionData.new('The Kitchen', 'The snacks are delicious.', :end)
    })
  end
  
  it 'can be written down for later retelling' do
    require_relative '../example/terrors'
    
    expect(TextAdventure.tale.title).to eq('The Terrors of the Halls')
    expect(TextAdventure.tale.sections).to eq({
      :intro => TextAdventure::SectionData.new(:intro, 'Slowly your eyes creak open.', { 'investigate The Manor' => 'The Manor' }),
      'The Manor' => TextAdventure::SectionData.new('The Manor', 'You arrive just in time to see the door swing shut before you, trapping you inside!', {
        'weep openly' => 'Despair',
        'look for an alternative means of egress' => 'The Kitchen'
      }),
      'Despair' => TextAdventure::SectionData.new('Despair', 'You cry a bit. You feel better (maybe?). Let\'s get back to that manor.', {
        'pull yourself together' => 'The Manor',
        'continue crying' => 'Despair'
      }),
      'The Kitchen' => TextAdventure::SectionData.new('The Kitchen', 'The snacks are delicious.', :end)
    })
  end
end
