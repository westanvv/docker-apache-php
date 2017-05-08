<?php

$cfg['blowfish_secret'] = 'docker'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

/*
 * Servers configuration
 */
$i = 0;

/*
 * First server
 */
$i++;
/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'config';
/* Server parameters */
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;
$cfg['Servers'][$i]['user'] = 'docker';
$cfg['Servers'][$i]['password'] = 'docker';

$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['MaxNavigationItems'] = 1000;
$cfg['CheckConfigurationPermissions'] = false;

?>