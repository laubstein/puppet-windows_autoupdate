# puppet-windows_autoupdate

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the windows_autoupdate module?](#module-description)
3. [Setup - The basics of getting started with windows_autoupdate](#setup)
    * [What windows_autoupdate affects](#what-autoupdates-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with windows_autoupdate](#beginning-with-autoupdates)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module for managing [Microsoft Windows Automatic Updates](http://support.microsoft.com/kb/328010).

[![Build Status](https://travis-ci.org/voxpupuli/puppet-windows_autoupdate.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-windows_autoupdate)

## Module Description

This module configures all the relevant windows registry keys used to manage windows automatic update settings on your windows machine.

## Setup

### What autoupdates affects

* Configures registry keys/values

### Beginning with autoupdate

Manage autoupdates with default settings:

```puppet
   include windows_autoupdate
```

Disable auto updates:

```puppet
   class { 'windows_autoupdate': noAutoUpdate => '1' }
```

## Usage

### Classes and Defined Types

#### Class: `windows_autoupdate`

The autoupdate module primary classes, `windows_autoupdate`, configures all the registry settings required to manage auto updates.

**Parameters within `windows_autoupdates`:**
##### `no_auto_update`

* 0 - Enable Automatic Updates (Default)
* 1 - Disable Automatic Updates

##### `au_options`

* 2 - Notify for download and notify for install
* 3 - Auto download and notify for install
* 4 - Auto download and schedule the install

##### `scheduled_install_day`

* 0 - Install every day
* 1 to 7 - Install on specific day of the week from Sunday (1) to Saturday (7).

##### `scheduled_install_time`

* 0 to 23 - Install time of day in 24-hour format

##### `use_wuserver`

* 1 to use custom update server

#####`wu_server`

* custom update server

#####`wu_status_server`

* custom update status server

##### `reschedule_wait_time`

* The number of minutes to wait after service start time before performing the installation.

##### `no_auto_reboot_with_logged_on_users`

* 1 to prevent automatic reboot while users are logged on.

## Reference

### Classes

#### Public Classes

* [`windows_autoupdates`](#class_autoupdates): Guides the basic management of windows auto update settings.

## Limitations

This module is tested on the following platforms:

* Windows 2008 R2

It is tested with the OSS version of Puppet only.

## Development

### Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
