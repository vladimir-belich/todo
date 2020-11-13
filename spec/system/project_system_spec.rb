require 'rails_helper'

RSpec.describe Project, type: :system do
  it 'signs up visitor' do
    visit('/')

    click_on 'Sign up'
    fill_in 'user_email', with: 'bv@elfa.ua'
    fill_in 'user_password', with: '111111'
    fill_in 'user_password_confirmation', with: '111111'
    click_on 'Sign up'
  end

  describe 'Create' do
    it 'creates the project', js: true do
      sign_in

      click_on 'Add TODO list'

      fill_in 'project_name', with: 'Auto test'
      click_on 'Save'

      expect(page).to have_content 'Auto test'
      expect(Project.last).to have_attributes(name: 'Auto test')
    end
  end

  describe 'Update' do
    let(:project) { Project.find_by_name('Auto test') }

    it 'updates the project', js: true do
      sign_in

      click_on "edit_project_#{project.id}"
      fill_in 'project_name', with: 'Edited auto test'
      click_on 'Save'

      expect(page).to have_content 'Edited auto test'

      expect(project.reload).to have_attributes(name: 'Edited auto test')
    end
  end

  describe 'Destroy' do
    let(:project) { Project.find_by_name('Edited auto test') }

    it 'destroys the project', js: true do
      sign_in

      accept_alert do
        click_on "del_project_#{project.id}"
      end

      expect(page).not_to have_content 'Edited auto test'
      expect(Project.exists?(project.id)).to be false
    end
  end

  def sign_in
    visit('/')
    fill_in 'user_email', with: 'bv@elfa.ua'
    fill_in 'user_password', with: '111111'
    click_on 'Log in'
  end
end
