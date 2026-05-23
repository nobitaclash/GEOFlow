<?php
$file = 'composer.lock';
if (!file_exists($file)) exit(0);

$json = file_get_contents($file);
$data = json_decode($json, true);

foreach (['packages', 'packages-dev'] as $key) {
    if (isset($data[$key])) {
        foreach ($data[$key] as &$pkg) {
            if (isset($pkg['dist']['url']) && strpos($pkg['dist']['url'], 'api.github.com') !== false) {
                $pkg['dist']['url'] = preg_replace(
                    '#https://api\.github\.com/repos/([^/]+)/([^/]+)/zipball/([^/]+)#',
                    'https://ghproxy.net/https://github.com/$1/$2/archive/$3.zip',
                    $pkg['dist']['url']
                );
            }
        }
    }
}

file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
echo "Fixed composer.lock with ghproxy.net!\n";
