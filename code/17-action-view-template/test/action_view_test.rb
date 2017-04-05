require "test_helper"

class ActionViewTest < Minitest::Test
  def test_render_template
    template = ActionView::Template.new("<p>Hello</p>", "test_render_template")

    context = ActionView::Base.new
    assert_equal "<p>Hello</p>", template.render(context)
  end

  def test_render_with_vars
    template = ActionView::Template.new("<p><%= @var %></p>", "test_render_with_vars")

    context = ActionView::Base.new var: "var value"
    assert_equal "<p>var value</p>", template.render(context)
  end

  def test_render_with_yield
    template = ActionView::Template.new("<p><%= yield %></p>",
      "test_render_with_yield")

    context = ActionView::Base.new
    assert_equal "<p>yielded content</p>",
      template.render(context) { "yielded content" }
  end

  def test_render_with_helper
    template = ActionView::Template.new("<%= link_to 'title', '/url' %>",
      "test_render_with_helper")

    context = ActionView::Base.new
    assert_equal "<a href=\"/url\">title</a>", template.render(context)
  end
end