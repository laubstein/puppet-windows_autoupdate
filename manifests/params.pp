# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class windows_autoupdate::params
#
# This private class is meant to be called from `windows_autoupdate`
# It sets variables according to platform
#
class windows_autoupdate::params {

  $au_options                          = '4'
  $no_auto_reboot_with_logged_on_users = '0'
  $no_auto_update                      = '0'
  $reschedule_wait_time                = '10'
  $scheduled_install_day               = '1'
  $scheduled_install_time              = '10'
  $wu_server                           = ''
  $wu_status_server                    = ''
  $use_wuserver                        = '0'

  $p_reg_policies = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
  $p_reg_policies64 = 'HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate'

  if $::operatingsystemrelease == 'Server 2012' or $::operatingsystemrelease == '2012 R2' {
    $p_reg_key = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
    $p_reg_keyServ = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate'
  } else {
    $p_reg_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
    $p_reg_keyServ = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
  }

}
