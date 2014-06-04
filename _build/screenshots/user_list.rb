require_relative 'helper'

feature 'benutzer' do
  before :each do
    log_in
  end

  # Overview
  scenario 'startseite' do
    # nothing to do
  end

  scenario 'eigene-geraete' do
    find('.js-nav-submodule[data-id="remote"] a').click
  end

  # Files 
  scenario 'dateien' do
    find('.js-nav-module[data-id="files"] a').click
  end

  # Teacher
  scenario 'raumsteuerung' do
    find('.js-nav-module[data-id="teacher"] a').click
    find('.js-nav-submodule[data-id="roomctl"] a').click

    find('.js-chooser [data-id="1"]').click

    find('.js-btn-printerlock').click
  end

  scenario 'benutzergruppen' do
    find('.js-nav-module[data-id="teacher"] a').click
    find('.js-nav-submodule[data-id="usergroups"] a').click
  end

  scenario 'benutzergruppe-bearbeiten' do
    find('.js-nav-module[data-id="teacher"] a').click
    find('.js-nav-submodule[data-id="usergroups"] a').click
    sleep 0.5

    find('tbody tr:first-child').click
    find('.popover .btn-primary').click
  end
end


