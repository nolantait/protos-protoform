# frozen_string_literal: true

require "ostruct"

RSpec.describe Protoform do
  before do
    stub_const "Model", Struct.new(:name, :nicknames, :addresses)
    stub_const "Address", Struct.new(:street, :city, :state)
    stub_const "Name", Struct.new(:first, :last) # rubocop:disable Lint/StructNewOverride
  end

  let(:user) do
    Model.new(
      name: Name.new(first: "William", last: "Bills"),
      nicknames: %w[Bill Billy Will],
      addresses: [
        Address.new(street: "Birch Ave", city: "Williamsburg", state: "New Mexico"),
        Address.new(street: "Main St", city: "Salem", state: "Indiana")
      ]
    )
  end

  let(:params) do
    {
      name: { first: "Brad", last: "Gessler", admin: true },
      admin: true,
      nicknames: %w[Brad Bradley],
      addresses: [
        { street: "Main St", city: "Salem" },
        { street: "Wall St", city: "New York", state: "New York", admin: true }
      ],
      one: { two: { three: { four: 100 } } }
    }
  end

  let(:form) do
    Protoform :user, object: user do |form|
      form.namespace(:name) do |name|
        name.field(:first)
        name.field(:last)
      end
      form.field(:nicknames).collection(&:value)
      form.collection(:addresses) do |address|
        address.field(:street)
        address.field(:city)
        address.field(:state)
      end
      form.namespace(:one).namespace(:two).namespace(:three).field(:four).value = 100
    end
  end

  it "serializes form" do
    expect(form.serialize).to eql(
      {
        name: { first: "William", last: "Bills" },
        nicknames: %w[Bill Billy Will],
        addresses: [
          { street: "Birch Ave", city: "Williamsburg", state: "New Mexico" },
          { street: "Main St", city: "Salem", state: "Indiana" }
        ],
        one: { two: { three: { four: 100 } } }
      }
    )
  end

  context "with existing params" do
    it "assigns params to form and discards garbage" do
      form.assign(params)
      expect(form.serialize).to eql(
        {
          name: { first: "Brad", last: "Gessler" },
          nicknames: %w[Brad Bradley],
          addresses: [
            { street: "Main St", city: "Salem", state: "New Mexico" },
            { street: "Wall St", city: "New York", state: "New York" }
          ],
          one: { two: { three: { four: 100 } } }
        }
      )
    end
  end

  context "with new object" do
    let(:user) do
      Model.new(
        addresses: [
          Address.new(street: nil, city: nil, state: nil),
          Address.new(street: nil, city: nil, state: nil)
        ]
      )
    end

    it "assigns params to form and discards garbage" do
      form.assign(params)
      expect(form.serialize).to eql(
        {
          name: { first: "Brad", last: "Gessler" },
          nicknames: %w[Brad Bradley],
          addresses: [
            { street: "Main St", city: "Salem", state: nil },
            { street: "Wall St", city: "New York", state: "New York" }
          ],
          one: { two: { three: { four: 100 } } }
        }
      )
    end
  end

  it "has correct DOM names" do
    Protoform :user, object: user do |form|
      form.namespace(:name) do |name|
        name.field(:first).dom.tap do |dom|
          expect(dom.id).to eql("user_name_first")
          expect(dom.name).to eql("user[name][first]")
        end
      end
      form.field(:nicknames).collection do |field|
        field.dom.tap do |dom|
          expect(dom.id).to match(/user_nicknames_\d+/)
          expect(dom.name).to eql("user[nicknames][]")
        end
      end
      form.collection(:addresses) do |address|
        address.field(:street).dom.tap do |dom|
          expect(dom.id).to match(/user_addresses_\d_street+/)
          expect(dom.name).to eql("user[addresses][][street]")
        end
        address.field(:city)
        address.field(:state)
      end
      form.namespace(:one).namespace(:two).namespace(:three).field(:four).dom.tap do |dom|
        expect(dom.id).to eql("user_one_two_three_four")
        expect(dom.name).to eql("user[one][two][three][four]")
      end
    end
  end
end
