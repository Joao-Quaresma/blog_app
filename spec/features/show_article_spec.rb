require "rails_helper"

RSpec.feature "Show an Article" do
  before do
    @john = User.create(email: "john@something.com", password: "password")
    @fred = User.create(email: "fred@something.com", password: "password")
    @article = Article.create(title: "The first article", body: "something", user: @john)
  end

  scenario "to non-signed user hide the Edite and Delete buttons" do
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "to non-owner user hide the Edite and Delete buttons" do
    login_as @fred
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "A signed in owner sees both the Edit and Delete buttons" do
    login_as @john
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).to have_link("Edit Article")
    expect(page).to have_link("Delete Article")
  end
end
