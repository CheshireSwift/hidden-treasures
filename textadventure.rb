module TextAdventure
  Tale = Struct.new(:title, :sections, :introduction)
  SectionData = Struct.new(:title, :text, :choices)

  class << self
    attr_accessor :tale
  end

  @tale = Tale.new(nil, Hash.new, nil)
end

def Introduction(text)
  TextAdventure.tale.introduction = TextAdventure::SectionData.new(:intro, text, {})
  Section TextAdventure.tale.introduction
end

def Section(section)
  @the_section = section
  TextAdventure.tale.sections[@the_section.title] = @the_section if @the_section
end

def to(arg1, arg2)
  { arg1 => arg2.values.first }
end

def Choose(choice)
  @the_section.choices.merge! choice
end

def ends(text)
  :end
end

def Thus(action)
  @the_section.choices = action
end

class String
  def -(text)
    return TextAdventure::SectionData.new(self, text, {})
  end
end

