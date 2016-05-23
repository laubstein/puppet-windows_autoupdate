# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class: windows_autoupdate
#
# Module to mananage the configuration of a machines autoupdate settings
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*no_auto_update*]
# Ensuring the state of automatic updates.
# 0: Automatic Updates is enabled (default)
# 1: Automatic Updates is disabled.
#
# [*au_options*]
# The option to configure what to do when an update is avaliable
# 1: Keep my computer up to date has been disabled in Automatic Updates.
# 2: Notify of download and installation.
# 3: Automatically download and notify of installation.
# 4: Automatically download and scheduled installation.
#
# [*scheduled_install_day*]
# The day of the week to install updates.
# 0: Every day.
# 1 through 7: The days of the week from Sunday (1) to Saturday (7).
#
# [*scheduled_install_time*]
# The time of day (in 24hr format) when to install updates.
#
# [*use_wuserver*]
# If set to 1, windows autoupdates will use a local WSUS server rather than windows update.
# 
# [*wu_server*]
# If use_wuserver is set to 1, windows autoupdates will use THIS local WSUS server rather than windows update.
#
# [*wu_status_server*]
# If use_wuserver is set to 1, windows autoupdates will use THIS local WSUS status server rather than windows update.
#
# [*reschedule_wait_time*]
# The time period to wait between the time Automatic Updates starts and the time it begins installations
# where the scheduled times have passed. The time is set in minutes from 1 to 60
#
# [*no_auto_reboot_with_logged_on_users*]
# If set to 1, Automatic Updates does not automatically restart a computer while users are logged on.
#
# === Examples
#
# Manage autoupdates with windows default settings:
#
#   include windows_autoupdate
#
# Disable auto updates (don't do this!):
#
#   class { 'windows_autoupdate': no_auto_update => '1' }
#
class windows_autoupdate(
  $au_options                          = $windows_autoupdate::params::au_options,
  $no_auto_reboot_with_logged_on_users = $windows_autoupdate::params::no_auto_reboot_with_logged_on_users,
  $no_auto_update                      = $windows_autoupdate::params::no_auto_update,
  $reschedule_wait_time                = $windows_autoupdate::params::reschedule_wait_time,
  $scheduled_install_day               = $windows_autoupdate::params::scheduled_install_day,
  $scheduled_install_time              = $windows_autoupdate::params::scheduled_install_time,
  $use_wuserver                        = $windows_autoupdate::params::use_wuserver,
  $wu_server                           = $windows_autoupdate::params::wu_server,
  $wu_status_server                    = $windows_autoupdate::params::wu_status_server,
) inherits windows_autoupdate::params {

  validate_re($no_auto_update,['^[0,1]$'])
  validate_re($au_options,['^[1-4]$'])
  validate_re($scheduled_install_day,['^[0-7]$'])
  validate_re($scheduled_install_time,['^(2[0-3]|1?[0-9])$'])
  validate_re($use_wuserver,['^[0,1]$'])
  validate_re($wu_server,['^*$'])
  validate_re($wu_status_server,['^*$'])
  validate_re($reschedule_wait_time,['^(60|[1-5][0-9]|[1-9])$'])
  validate_re($no_auto_reboot_with_logged_on_users,['^[0,1]$'])

  service { 'wuauserv':
    ensure    => 'running',
    enable    => true,
    subscribe => Registry_value["${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_key}\\AUOptions",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\AUOptions",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\AUOptions",
                                "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                                "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                                "${windows_autoupdate::params::p_reg_policies64}\\WUServer",
                                "${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoRebootWithLoggedOnUsers",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoRebootWithLoggedOnUsers",
                               ]
  }

  registry_key { [$windows_autoupdate::params::p_reg_key,
                  $windows_autoupdate::params::p_reg_keyServ,
                  $windows_autoupdate::params::p_reg_policies,
                  "$windows_autoupdate::params::p_reg_policies\\AU",
                  "$windows_autoupdate::params::p_reg_policies64\\AU",
                 ]:
    ensure => present,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoUpdate",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoUpdate",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $no_auto_update,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\AUOptions",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\AUOptions",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\AUOptions",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $au_options,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallDay",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallDay",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $scheduled_install_day,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallTime",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallTime",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $scheduled_install_time,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\UseWUServer",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\UseWUServer",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\UseWUServer",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $use_wuserver,
  }

  if ( $use_wuserver == '1') {
    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUServer",
                     ]:
      ensure => present,
      type   => 'string',
      data   => $wu_server
    }

    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer",
                     ]:
      ensure => present,
      type   => 'string',
      data   => $wu_status_server
    }
  } else {
    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUServer",
                      "${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer",
                     ]:
      ensure => absent,
    }
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\RescheduleWaitTime",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\RescheduleWaitTime",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $reschedule_wait_time,
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoRebootWithLoggedOnUsers",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoRebootWithLoggedOnUsers",
                   ]:
    ensure => present,
    type   => 'dword',
    data   => $no_auto_reboot_with_logged_on_users,
  }
}
