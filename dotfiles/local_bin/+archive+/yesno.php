#!/usr/bin/env php
<?php

$q = "really???";
if(count($argv) > 1){
    $q = $argv[1];
}

$cmd = "rofi -theme-str 'window {width: 200px; height: 150px;}' -dmenu -p '$q' -sep '\\0' -eh 2 -markup-rows -format i";
$proc = proc_open($cmd, [
   0 => ["pipe", "r"],
   1 => ["pipe", "w"],
   2 => ["pipe", "r"],
], $pipes);

if (is_resource($proc)) {
    fwrite($pipes[0], "<span size='x-large' weight='heavy'>Yes</span>\0");
    fwrite($pipes[0], "<span size='x-large' weight='heavy'>No</span>\0");
    fclose($pipes[0]);

    $stdout = stream_get_contents($pipes[1]);
    $stdout = trim($stdout);
    fclose($pipes[1]);

    $return_value = proc_close($proc);
    echo "command returned: $return_value\n";
    echo "stdout[$stdout]\n";

    if($return_value == 0 && $stdout === '0'){
        exit(0);
    }else{
        exit(-1);
    }
}
