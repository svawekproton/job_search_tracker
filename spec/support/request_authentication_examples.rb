RSpec.shared_examples "requires authentication" do
  it "redirects to the login page" do
    make_request

    expect(response).to redirect_to(new_session_path)
  end
end
