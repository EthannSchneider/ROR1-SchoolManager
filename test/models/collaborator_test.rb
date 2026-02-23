class CollaboratorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    collaborator = Collaborator.new(contract_start: Date.today, contract_end: Date.tomorrow, firstname: "John", lastname: "Doe", email: "john@example.com", avs_number: "12345678901", password: "password123")
    assert collaborator.valid?
  end

  test "should be invalid without contract_start" do
    collaborator = Collaborator.new(contract_end: Date.tomorrow)
    assert_not collaborator.valid?
  end

  test "should be invalid without contract_end" do
    collaborator = Collaborator.new(contract_start: Date.today)
    assert_not collaborator.valid?
  end
end
