require 'rails_helper'

feature 'Issues -' do

  UserPermission.destroy_all
  Issue.destroy_all
  Sector.destroy_all
  User.destroy_all

  # Users:
  joseph = User.create(name: 'Joseph', email: 'joseph@abilities.com', password: '123456')
  ana = User.create(name: 'Ana', email: 'ana@abilities.com', password: '123456')
  albert = User.create(name: 'Albert', email: 'albert@abilities.com', password: '123456')
  shirley = User.create(name: 'Shirley', email: 'shirley@abilities.com', password: '123456')

  # Sectors:
  storage = Sector.create(name: 'Storage')
  factory = Sector.create(name: 'Factory')

  # Permissions:
  # Joseph current BOSS from Storage Sector
  UserPermission.create(user: joseph, sector: storage, level: 'BOSS', start: 1.months.ago, end: 1.months.from_now)

  # Ana old BOSS from Storage Sector
  UserPermission.create(user: ana,    sector: storage, level: 'BOSS', start: 3.months.ago, end: 2.months.ago)

  # Albert current general BOSS
  UserPermission.create(user: albert, sector: storage, level: 'BOSS', start: 1.months.ago, end: 1.months.from_now)
  UserPermission.create(user: albert, sector: factory, level: 'BOSS', start: 1.months.ago, end: 1.months.from_now)

  # Shirley current general EMPLOYEE
  UserPermission.create(user: shirley, sector: storage, level: 'EMPLOYEE', start: 1.months.ago, end: 1.months.from_now)
  UserPermission.create(user: shirley, sector: factory, level: 'EMPLOYEE', start: 1.months.ago, end: 1.months.from_now)

  # Issues:
  issue_storage = Issue.create(sector: storage)
  issue_factory = Issue.create(sector: factory)


  context 'Accessing:' do
    scenario 'Joseph current BOSS from Storage Sector accessing issues' do
      warden_sign_in joseph

      visit issues_path

      expect(page).to     have_content("Destroy Issue #{issue_storage.id}")
      expect(page).to_not have_content("Destroy Issue #{issue_factory.id}")
    end

    scenario 'Ana old BOSS from Storage Sector accessing issues' do
      warden_sign_in ana

      visit issues_path

      expect(page).to_not have_content("Destroy Issue #{issue_storage.id}")
      expect(page).to_not have_content("Destroy Issue #{issue_factory.id}")
    end

    scenario 'Albert current general BOSS accessing issues' do
      warden_sign_in albert

      visit issues_path

      expect(page).to have_content("Destroy Issue #{issue_storage.id}")
      expect(page).to have_content("Destroy Issue #{issue_factory.id}")
    end

    scenario 'Shirley current general EMPLOYEE accessing issues' do
      warden_sign_in shirley

      visit issues_path

      expect(page).to_not have_content("Destroy Issue #{issue_storage.id}")
      expect(page).to_not have_content("Destroy Issue #{issue_factory.id}")
    end
  end
end
