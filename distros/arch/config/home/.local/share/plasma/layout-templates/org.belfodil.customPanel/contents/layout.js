var panel = new Panel();
var panelScreen = panel.screen;

// No need to set panel.location as ShellCorona::addPanel will automatically pick one available edge

// For an Icons-Only Task Manager on the bottom, *3 is too much, *2 is too little
// Round down to next highest even number since the Panel size widget only displays
// even numbers
panel.height = 2 * Math.floor((gridUnit * 2.5) / 2);

// Restrict horizontal panel to a maximum size of a 21:9 monitor
const maximumAspectRatio = 21 / 9;
if (panel.formFactor === 'horizontal') {
    const geo = screenGeometry(panelScreen);
    const maximumWidth = Math.ceil(geo.height * maximumAspectRatio);

    if (geo.width > maximumWidth) {
        panel.alignment = 'center';
        panel.minimumLength = maximumWidth;
        panel.maximumLength = maximumWidth;
    }
}

panel.addWidget('org.kde.plasma.kickoff');
var iconTasksWidget = panel.addWidget('org.kde.plasma.icontasks');

panel.addWidget('org.kde.plasma.marginsseparator');

panel.addWidget('org.kde.plasma.mediacontroller');
panel.addWidget('org.kde.plasma.systemmonitor.cpucore');
panel.addWidget('org.kde.plasma.systemmonitor.memory');
panel.addWidget('org.kde.plasma.systemmonitor.net');
panel.addWidget('org.kde.plasma.systemmonitor.diskactivity');
var systemTrayWidget = panel.addWidget('org.kde.plasma.systemtray');
panel.addWidget('org.kde.plasma.digitalclock');
panel.addWidget('org.kde.plasma.pager');
panel.addWidget('org.kde.plasma.showdesktop');

iconTasksWidget.currentConfigGroup = ['General'];
iconTasksWidget.writeConfig('indicateAudioStreams', false);
iconTasksWidget.writeConfig('launchers', [
    'applications:librewolf.desktop',
    'applications:code.desktop',
    'applications:org.mozilla.Thunderbird.desktop',
    'applications:ferdium.desktop',
    'applications:spotify.desktop',
]);

systemtrayId = systemTrayWidget.readConfig('SystrayContainmentId');
var systray = desktopById(systemtrayId);
systray.currentConfigGroup = ['General'];
systray.writeConfig('extraItems', [
    'org.kde.plasma.bluetooth',
    'org.kde.plasma.cameraindicator',
    'org.kde.plasma.clipboard',
    'org.kde.plasma.devicenotifier',
    'org.kde.plasma.manage - inputmethod',
    'org.kde.plasma.notifications',
    'org.kde.plasma.keyboardindicator',
    'org.kde.kscreen',
    'org.kde.plasma.battery',
    'org.kde.plasma.brightness',
    'org.kde.plasma.keyboardlayout',
    'org.kde.plasma.networkmanagement',
    'org.kde.plasma.volume',
    'org.kde.plasma.vault',
    'org.kde.plasma.printmanager',
    'org.kde.kdeconnect',
    'org.kde.plasma.weather',
]);
systray.writeConfig('shownItems', ['org.kde.plasma.battery', 'org.kde.plasma.notifications']);
