class PersonTypeConstraint
  def self.collaborator
    new("Collaborator")
  end

  def self.dean
    new("Dean")
  end

  def initialize(type)
    @type = type
  end

  def matches?(request)
    person = request.env["warden"]&.authenticate(scope: :person)
    person&.is_a?(@type.constantize)
  end
end
