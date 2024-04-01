# frozen_string_literal: true

class TestForm < Protoform::Rails::Form
  def template
    render field(:name).input(type: :text)
  end
end

RSpec.describe Protoform::Rails::Form, type: :view do
  before do
    model_name = double("ModelName", param_key: "something")
    model = double("Model", model_name:, persisted?: true)
    helpers = double("Helpers", form_authenticity_token: "token", url_for: "/")
    render TestForm.new(model, helpers:)
  end

  it "renders the form" do
    expect(page).to have_css("form")
  end

  it "renders the rails based form fields" do
    expect(page).to have_field(type: "hidden", name: "authenticity_token", with: "token")
    expect(page).to have_field(type: "hidden", name: "_method", with: "patch")
  end

  it "renders the form fields" do
    expect(page).to have_field(type: "text", name: "something[name]")
  end
end
