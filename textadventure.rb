module TextAdventure
  Tale = Struct.new(:title, :sections) do
    def introduction
      self.sections[:intro]
    end
  end
  SectionData = Struct.new(:title, :text, :choices)

  class << self
    attr_reader :tale
  end

  def self.begin_tale(title)
    @tale = TextAdventure::Tale.new(title, Hash.new)
  end
end

def Introduction(text)
  Section TextAdventure::SectionData.new(:intro, text, {})
end

def Section(section)
  @the_section = section
  TextAdventure.tale.sections[@the_section.title] = @the_section if @the_section
end

def to(action=:self_titled, sought)
  if action == :self_titled
    action = "#{sought.keys.first} #{sought.values.first}"
  end
  { action => sought.values.first }
end

def Choose(choice)
  @the_section.choices.merge! choice
end

def ends(tale_name)
  [:end, tale_name]
end

def begins(tale_name)
  [:begin, tale_name]
end

def So(action_tale_tuple)
  handle_tale_action(action_tale_tuple)
end

def Thus(action_tale_tuple)
  handle_tale_action(action_tale_tuple)
end

def handle_tale_action(action_tale_tuple)
  case action_tale_tuple[0]
    when :end
      @the_section.choices = :end
    when :begin
      TextAdventure.begin_tale action_tale_tuple[1]
  end
end

class String
  def -(text)
    return TextAdventure::SectionData.new(self, text, {})
  end
end
