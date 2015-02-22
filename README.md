[![Build Status](https://travis-ci.org/shoichikaji/Distribution-Metadata.svg?branch=master)](https://travis-ci.org/shoichikaji/Distribution-Metadata)
# NAME

Distribution::Metadata - gather distribution metadata

# SYNOPSIS

    use Distribution::Metadata;

    my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");

    print $info->main_module;         # LWP
    print $info->main_module_version; # 6.08
    print $info->main_module_file;    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/LWP.pm

    print $info->packlist;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/auto/LWP/.packlist
    print $info->meta_directory;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08
    print $info->install_json;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08/install.json
    print $info->mymeta_json;
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/darwin-2level/.meta/libwww-perl-6.08/MYMETA.json

    print $_, "\n" for @{ $info->files };
    # /Users/skaji/.plenv/versions/5.20.1/bin/lwp-download
    # ...
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/LWP.pm
    # /Users/skaji/.plenv/versions/5.20.1/lib/site_perl/5.20.1/LWP/Authen/Basic.pm
    # ...

    my $install_json_hash = $info->install_json_hash;
    my $mymeta_json_hash = $info->mymeta_json_hash;

# DESCRIPTION

Distribution::Metadata gathers distribution metadata in local.
That is, this module tries to gather

- main module name, version, file
- `.packlist` file
- `.meta` directory
- `install.json` file
- `MYMETA.json` file

Note that `.meta` directory, `install.json` file and `MYMETA.json` file
seem to be available when you installed modules
with [cpanm](https://metacpan.org/pod/cpanm) 1.5000 (released 2011.10.13) or later.

# HOW IT WORKS

Let me explain how `$class->new_from_module($module, inc => $inc)` works.

- Get `$module_file` by

        Module::Metadata->new_from_module($module, inc => $inc)->filename.

- Find `$packlist` in which `$module_file` is listed.
- From `$packlist` pathname (eg: ...auto/LWP/.packlist), determine `$main_module` and main module search directory `$lib`.
- Get `$main_module_version` by

        Module::Metadata->new_from_module($main_module, inc => [$lib, "$lib/$Config{archname}"])->version

- Find install.json that has "name" eq `$main_module`, and provides `$main_module` with version `$main_module_version`.
- Get .meta directory and MYMETA.json with install.json.

## CONSTRUCTORS

- `my $info = $class->new_from_module($module, inc => \@dirs, fill_archlib => $bool)`

    Create Distribution::Metadata instance from module name.

    You can append `inc` argument
    to specify module/packlist/meta search paths. Default is `\@INC`.

    Also you can append `fill_archlib` argument
    so that archlibs are automatically added to `inc` if missing.

    Please note that, even if the module cannot be found,
    `new_from_module` returns a Distribution::Metadata instance.
    However almost all methods returns `undef` for such objects.
    If you want to know whether the distribution was found or not, try:

        my $info = $class->new_from_module($module);

        if ($info->packlist) {
            # found
        } else {
            # not found
        }

- `my $info = $class->new_from_file($file, inc => \@dirs, fill_archlib => $bool)`

    Create Distribution::Metadata instance from file path.
    You can append `inc` and `fill_archlib` arguments too.

    Also `new_from_file` retunes a Distribution::Metadata instance,
    even if file cannot be found.

## METHODS

Please note that the following methods return `undef`
when appropriate modules or files cannot be found.

- `my $file = $info->packlist`

    `.packlist` file path

- `my $dir = $info->meta_directory`

    `.meta` directory path

- `my $file = $info->install_json`

    `install.json` file path

- `my $file = $info->mymeta_json`

    `MYMETA.json` file path

- `my $main_module = $info->main_module`

    main module name

- `my $version = $info->main_module_version`

    main module version

- `my $file = $info->main_module_file`

    main module file path

- `my $files = $info->files`

    file paths which is listed in `.packlist` file

- `my $hash = $info->install_json_hash`

    a hash reference for `install.json`

        my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");
        my $install = $info->install_json_hash;
        $install->{version};  # 6.08
        $install->{dist};     # libwww-perl-6.08
        $install->{pathname}; # M/MS/MSCHILLI/libwww-perl-6.08.tar.gz
        ...

- `my $hash = $info->mymeta_json_hash`

    a hash reference for `MYMETA.json`

        my $info = Distribution::Metadata->new_from_module("LWP::UserAgent");
        my $meta = $info->mymeta_hash;
        $meta->{version};  # 6.08
        $meta->{abstract}; # The World-Wide Web library for Perl
        $meta->{prereqs};  # prereq hash
        ...

# SEE ALSO

[Module::Metadata](https://metacpan.org/pod/Module::Metadata)

[App::cpanminus](https://metacpan.org/pod/App::cpanminus)

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
