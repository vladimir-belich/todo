require 'rails_helper'

RSpec.describe Task, type: :system do
  it 'signs up visitor' do
    visit('/')

    click_on 'Sign up'
    fill_in 'user_email', with: 'bv@elfa.ua'
    fill_in 'user_password', with: '111111'
    fill_in 'user_password_confirmation', with: '111111'
    click_on 'Sign up'
  end


  it 'creates the project', js: true do
    sign_in

    click_on 'Add TODO list'

    fill_in 'project_name', with: 'Auto test'
    click_on 'Save'

    expect(page).to have_content 'Auto test'
    expect(Project.last).to have_attributes(name: 'Auto test')
  end

  describe 'Add' do
    let(:project) { Project.find_by_name('Auto test') }

    it 'adds a task to project', js: true do
      sign_in

      find("#pr_#{project.id}").find("#new_task_name").fill_in with: 'New task'
      find("#pr_#{project.id}").click_on 'Add Task'

      expect(page).to have_content 'New task'
      expect(Task.last).to have_attributes(name: 'New task')
    end
  end

  describe 'Update' do
    let(:project) { Project.find_by_name('Auto test') }
    let(:task) { Task.where(project_id: project.id).last }

    it 'updates the task name', js: true do
      sign_in

      click_on "edit_tsk_#{task.id}"
      fill_in 'task_name', with: 'Edited new task'
      click_on 'Update Task'

      expect(page).to have_content 'Edited new task'
      expect(task.reload).to have_attributes(name: 'Edited new task')
    end

    it 'marks the task as done', js: true do
      sign_in

      click_on "edit_tsk_#{task.id}"
      find("#task_status").set(true)
      click_on 'Update Task'

      expect(find("#tsk_#{task.id}")).to have_field('task_status', with: 1, disabled: true)
      expect(task.reload).to have_attributes(status: true)
    end

    it 'updates the task deadline', js: true do
      sign_in

      click_on "edit_tsk_#{task.id}"
      fill_in 'task_deadline', with: "11-15-2020"
      click_on 'Update Task'
      sleep(0.1)

      expect(task.reload).to have_attributes(deadline: Date.parse("2020-11-15"))
    end

    it 'increases the priority of the task', js: true do
      sign_in

      find("#tsk_#{task.id}").find("#inc").click
      sleep(0.1)

      expect{ task.reload }.to change{ task.priority }.from(1).to(0)
    end

    it 'lowervs the priority of the task', js: true do
      sign_in

      find("#tsk_#{task.id}").find("#low").click
      sleep(0.1)

      expect{ task.reload }.to change{ task.priority }.from(0).to(1)
    end
  end

  describe 'Destroy' do
    let(:project) { Project.find_by_name('Auto test') }
    let(:task) { Task.where(project_id: project.id).last }

    it 'destroys the task', js: true do
      sign_in

      accept_alert do
        click_on "del_tsk_#{task.id}"
      end

      expect(page).not_to have_content task.name
      expect(Task.exists?(task.id)).to be false
     end
  end

  def sign_in
    visit('/')
    fill_in 'user_email', with: 'bv@elfa.ua'
    fill_in 'user_password', with: '111111'
    click_on 'Log in'
  end
end
