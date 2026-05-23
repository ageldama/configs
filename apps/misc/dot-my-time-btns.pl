# ~/.my-tim-btns.pl

my $cmds = [
    {
        name => 'calibre',
        cmd => 'calibre',
        font => 'serif 28',
    },

    {
        name => 'qjoypad',
        cmd => 'qjoypad',
        font => 'serif 28',
    },

    {
        name => 'goldendict',
        cmd => 'goldendict',
        font => 'serif 28',
    },

    {
        name => 'fm4u',
        cmd => 'x-terminal-emulator -e fm4u.pl',
        font => 'serif 24 normal',
    },
    
    {
        name => 'pavucontrol',
        cmd => 'pavucontrol',
        font => 'serif 20',
    },

    {
        name => 'reboot',
        cmd => 'sh -c "yesno.pl \'reboot?\' && sudo reboot"',
        fg => 'yellow',
        bg => 'red',
    },

    {
        name => 'poweroff',
        cmd => 'sh -c "yesno.pl \'poweroff?\' && sudo poweroff"',
        fg => 'yellow',
        bg => 'red',
    },

    
    ];
