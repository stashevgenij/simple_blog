RSpec::Matchers.define :have_tags do |tags|
  match do |page|       
    expect(page).to have_content(tags[0])
    expect(page).to have_content(tags[1])
    expect(page).to have_content(tags[2])
    expect(Post.last.tags.map(&:tag_name)).to eq(tags)      
  end
end