require "test_helper"

class OwnerTest < ActiveSupport::TestCase
  test "should not save owner without first_name" do
    owner = Owner.new(last_name: "Smith", email: "test@test.com", phone: "123")
    assert_not owner.save, "Saved the owner without a first_name"
  end

  test "should save valid owner" do
    owner = Owner.new(first_name: "John", last_name: "Doe", email: "unique_email@test.com", phone: "12345")
    assert owner.save
  end

  test "should enforce unique email" do
    Owner.create!(first_name: "A", last_name: "B", email: "duplicate@test.com", phone: "1")
    duplicate = Owner.new(first_name: "C", last_name: "D", email: "duplicate@test.com", phone: "2")
    assert_not duplicate.save, "Saved a duplicate email"
  end
end
