[![Build Status](https://travis-ci.org/shoichikaji/Distribution-Metadata.svg?branch=master)](https://travis-ci.org/shoichikaji/Distribution-Metadata)
# NAME

Distribution::Metadata - gather distribution metadata

# SYNOPSIS

    use Distribution::Metadata;

    my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");

    print $info->main_module;
    # LWP
    print $info->packlist;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/auto/LWP/.packlist
    print $info->meta_directory;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08
    print $info->install_json;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08/install.json
    print $info->mymeta;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08/MYMETA.json

    print "$_\n" for @{ $info->files };
    # /Users/skaji/.plenv/versions/5.20.1/bin/lwp-download
    # ...
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/LWP.pm
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/LWP/Authen/Basic.pm
    # ...

    my $install_json_hash = $info->install_json_hash;
    my $mymeta_hash = $info->mymeta_hash;

# DESCRIPTION

Distribution::Metadata gathers distribution metadata in local.
That is, this module tries to gather

- .packlist file
- .meta directory
- install.json file
- MYMETA.json (or MYMETA.yml) file

## CONSTRUCTORS

- $info = $class->new\_from\_module($module, inc => \\@dirs)

    Create Distribution::Metadata instance from module name.
    You can append `inc` argument
    to specify module/packlist/meta search paths. Default is `\@INC`.

    Please note that, even if the module cannot be found,
    `new_from_module` returns a Distribution::Metadata instance.
    However almost all methods returns `undef` for such objects.

- $info = $class->new\_from\_file($file, inc => \\@dirs)

    Create Distribution::Metadata instance from file path.
    You can append `inc` argument too.

    Also `new_from_file` retunes a Distribution::Metadata instance,
    even if file cannot be found.

## METHODS

- my $file = $info->packlist

    `.packlist` file path

- my $dir = $info->meta\_directory

    `.meta` directory path

- my $file = $info->mymeta

    `MYMETA.json` (or `MYMETA.yml`) file path

- my $main\_module = $info->main\_module

    main module name

- my $version = $info->main\_module\_version

    main module version

- my $files = $info->files

    file paths which is listed in `.packlist` file

- my $hash = $info->install\_json\_hash

    a hash reference for `install.json`

        my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");
        my $install = $info->install_json_hash;
        $install->{version};  # 6.08
        $install->{dist};     # libwww-perl-6.08
        $install->{pathname}; # M/MS/MSCHILLI/libwww-perl-6.08.tar.gz
        ...

- my $hash = $info->mymeta\_hash

    a hash reference for `MYMETA.json` (or `MYMETA.yml`)

        my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");
        my $meta = $info->mymeta_hash;
        $meta->{version};  # 6.08
        $meta->{abstract}; # The World-Wide Web library for Perl
        $meta->{prereqs};  # prereq hash
        ...

# SEE ALSO

[Module::Metadata](https://metacpan.org/pod/Module::Metadata)

[App::capnminus](https://metacpan.org/pod/App::capnminus)

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
