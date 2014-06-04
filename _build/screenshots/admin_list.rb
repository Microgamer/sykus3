require_relative 'helper'

feature 'administrator' do
  before :each do
    log_in true

    find('.js-nav-module[data-id="admin"] a').click
  end

  # Users
  scenario 'benutzerliste' do
    find('.js-nav-module[data-id="users"] a').click
    find('.js-nav-submodule[data-id="users"] a').click
  end

  # Hosts
  scenario 'rechnerliste' do
    find('.js-nav-module[data-id="hosts"] a').click
    find('.js-nav-submodule[data-id="hosts"] a').click
  end

  scenario 'softwarepakete' do
    find('.js-nav-module[data-id="hosts"] a').click
    find('.js-nav-submodule[data-id="packages"] a').click
  end

  # Logs
  scenario 'logs-benutzeranmeldung' do
    find('.js-nav-module[data-id="logs"] a').click
    find('.js-nav-submodule[data-id="sessionlogs"] a').click
  end

  # Webfilter
  scenario 'internetfilter-filterlisten' do
    find('.js-nav-module[data-id="webfilter"] a').click
    find('.js-nav-submodule[data-id="categories"] a').click
  end

  scenario 'internetfilter-manuelle-eintraege' do
    find('.js-nav-module[data-id="webfilter"] a').click
    find('.js-nav-submodule[data-id="entries"] a').click
  end

  # Printers
  scenario 'druckerliste' do
    find('.js-nav-module[data-id="printers"] a').click
  end

  scenario 'drucker-bearbeiten' do
    find('.js-nav-module[data-id="printers"] a').click
    sleep 0.5

    find('tbody tr:first-child').click
    find('.popover .btn-primary').click
  end

end


