# accented chars for copying into an editor: é ú á í ñ ó

class Hablaba

  class << self

    # Conjugate a Spanish verb
    #
    # Example:
    #   >> Hablaba.conjugate('yo', 'hablar')
    #   => hablo
    #
    # Arguments:
    #   pronoun: (String)
    #   verb: (String)
    #   tense: (Symbol)
    #     - optional, defaults to :present
    #     - options: :present, :preterite, :imperfect
    def conjugate(pronoun, verb, tense = :present)
      pronoun, verb = pronoun.downcase, verb.downcase
      case tense
      when :present
        conjugate_in_the_present(pronoun, verb)
      when :preterite
        conjugate_in_the_preterite(pronoun, verb)
      when :imperfect
        conjugate_in_the_imperfect(pronoun, verb)
      when :present_subjunctive
        conjugate_in_the_present_subjunctive(pronoun, verb)
      when :imperfect_subjunctive
        conjugate_in_the_imperfect_subjunctive(pronoun, verb)
      when :conditional
        conjugate_in_the_conditional(pronoun, verb)
      when :future
        conjugate_in_the_future(pronoun, verb)
      else
        # TODO: raise error
      end
    end

    private

    def pronouns
      %W[yo tú él ella nosotros vosotros ellos ellas usted ustedes]
    end

    def pronoun_index(pronoun)
      [/yo/,/tú/,/él\z|ella\z|usted\z/,/nosotros/,/vosotros/,/ellos|ellas|ustedes/].index { |p| p =~ pronoun }
    end

    def get_verb_ending_and_root(verb)
      verb_ending = /ar\z|er\z|ir\z/.match(verb)[0]
      root = verb.gsub(/#{verb_ending}\z/, '')
      return verb_ending, root
    end

    def conjugate_in_the_present(pronoun, verb)
      verb_ending, root = get_verb_ending_and_root(verb)
      case verb_ending
      when 'ar' then conjugate_ar_in_the_present(pronoun, root)
      when 'er' then conjugate_er_in_the_present(pronoun, root)
      when 'ir' then conjugate_ir_in_the_present(pronoun, root)
      end
    end

    def conjugate_ar_in_the_present(pronoun, root_of_verb)
      root_of_verb + %W[o as a amos áis an][pronoun_index(pronoun)]
    end

    def conjugate_er_in_the_present(pronoun, root_of_verb)
      root_of_verb + %W[o es e emos éis en][pronoun_index(pronoun)]
    end

    def conjugate_ir_in_the_present(pronoun, root_of_verb)
      root_of_verb + %W[o es e imos ís en][pronoun_index(pronoun)]
    end

    def conjugate_in_the_preterite(pronoun, verb)
      verb_ending, root = get_verb_ending_and_root(verb)
      if verb_ending == 'ar'
        conjugate_ar_in_the_preterite(pronoun, root)
      else # er and ir are the same
        conjugate_er_ir_in_the_preterite(pronoun, root)
      end
    end

    def conjugate_ar_in_the_preterite(pronoun, root_of_verb)
      root_of_verb + %W[é aste ó amos asteis aron][pronoun_index(pronoun)]
    end

    def conjugate_er_ir_in_the_preterite(pronoun, root_of_verb)
      root_of_verb + %W[í iste ió imos isteis ieron][pronoun_index(pronoun)]
    end

    def conjugate_in_the_imperfect(pronoun, verb)
      verb_ending, root = get_verb_ending_and_root(verb)
      if verb_ending == 'ar'
        conjugate_ar_in_the_imperfect(pronoun, root)
      else # er and ir are the same
        conjugate_er_ir_in_the_imperfect(pronoun, root)
      end
    end

    def conjugate_ar_in_the_imperfect(pronoun, root_of_verb)
      root_of_verb + %W[aba abas aba ábamos abais aban][pronoun_index(pronoun)]
    end

    def conjugate_er_ir_in_the_imperfect(pronoun, root_of_verb)
      root_of_verb + %W[ía ías ía íamos íais ían][pronoun_index(pronoun)]
    end

    # normally you would actually need to start by getting the verb in the first-person
    # present, but since this only handles regular verbs, this is easy enough to handle
    # with this method
    def conjugate_in_the_present_subjunctive(pronoun, verb)
      verb_ending, root = get_verb_ending_and_root(verb)
      if verb_ending == 'ar'
        root + %W[e es e emos éis en][pronoun_index(pronoun)]
      else # er and ir are the same
        root + %W[a as a amos áis an][pronoun_index(pronoun)]
      end
    end
        
    def conjugate_in_the_imperfect_subjunctive(pronoun, verb)
      verb_ending, root = get_verb_ending_and_root(verb)
      # get the third person preterite
      third_person_root = conjugate_in_the_preterite('ellos', verb).gsub(/on\z|an\z/i, '')
      third_person_root + %W[a as a amos ais an][pronoun_index(pronoun)]
    end

    def conjugate_in_the_conditional(pronoun, verb)
      verb + %W[ía ías ía íamos íais ían][pronoun_index(pronoun)]
    end
    
    def conjugate_in_the_future(pronoun, verb)
      verb + %W[é ás á emos éis án][pronoun_index(pronoun)]
    end

  end

end
