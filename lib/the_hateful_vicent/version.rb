module TheHatefulVicent
  module Version
    #MAJOR: inclui alterações de API e pode quebrar compatibilidade com versões anteriores
    MAJOR = 0
    #MINOR: inclui novas funcionalidades, sem quebrar APIs existentes
    MINOR = 1
    #PATCH: corrige bugs ou traz melhorias em implementações já existentes
    PATCH = 0
    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}"
  end
end
