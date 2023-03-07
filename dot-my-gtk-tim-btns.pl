# ~/.my-tim-btns.pl

my $cmds = [
    {
        name => 'calibre',
        cmd => 'calibre',
        font => 'normal 28px serif',
    },

    {
        name => 'qjoypad',
        cmd => 'qjoypad',
        font => 'normal 28px serif',
    },

    {
        name => 'goldendict',
        cmd => 'goldendict',
        font => 'normal 28px serif',
    },

    {
        name => 'fm4u',
        cmd => 'x-terminal-emulator -e fm4u.pl',
        font => 'normal 24px serif',
    },

    {
        name => 'pavucontrol',
        cmd => 'pavucontrol',
        font => 'normal 20px serif',
    },

    {
        name => 'reboot',
        cmd => 'sh -c "zenity --question --text=\'reboot?\' && sudo reboot"',
        fg => 'yellow',
        bg => 'red',
    },

    {
        name => 'poweroff',
        cmd => 'sh -c "zenity --question --text=\'poweroff?\' && sudo poweroff"',
        fg => 'yellow',
        bg => 'red',
    },

  ];
