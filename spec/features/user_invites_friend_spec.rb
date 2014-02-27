require 'spec_helper'

feature "User invites friend" do
	scenario "User successfully invites friend and invitation is accepted" do
		alice = Fabricate(:user)
		sign_in(alice)

		invite_a_friend
		friend_accepts_invitation
		friend_signs_in
		friend_should_follow(alice)
		inviter_should_follow_friend(alice)

		clear_email
	end

	def invite_a_friend
		visit new_invitation_path
		fill_in "Friend's Name", with: "Kobe Bryant"
		fill_in "Friend's Email Address", with: "kobe@example.com"
		fill_in "Invitation Message", with: "come to join MyFlix!"
		click_button "Send Invitation"
		sign_out
	end

	def friend_accepts_invitation
		open_email "kobe@example.com"
		current_email.click_link "Accept this invitation"

		fill_in "Password", with: "password"
		fill_in "Full Name", with: "Kobe Bryant"
		click_button "Sign Up"
	end

	def friend_signs_in
		fill_in "Email Address", with: "kobe@example.com"
		fill_in "Password", with: "password"
		click_button "Sign in"
	end

	def friend_should_follow(user)
		click_link "People"
		expect(page).to have_content user.full_name
		sign_out
	end

	def inviter_should_follow_friend(inviter)
		sign_in(inviter)
		click_link "People"
		expect(page).to have_content "Kobe Bryant"
	end
end