use v5.24;
use warnings;
use experimental qw(lexical_subs signatures);

use Test::More;
use Distribution::Metadata;
use File::Temp 'tempdir';
use Config;
use File::Find 'find';
use File::Basename 'basename';
use File::pushd 'tempd';
use File::Spec;
sub cpanm (@args) { !system "cpanm", "-nq", "--reinstall", @args or die "cpanm fail"; }

subtest basic => sub (@) {
    my $tempdir = tempdir CLEANUP => 1;
    cpanm "-l$tempdir/local", 'Role::Identifiable::HasIdent@0.007';
    my $info = Distribution::Metadata->new_from_module(
        "Role::Identifiable::HasIdent",
        inc => ["$tempdir/local/lib/perl5"],
    );
    ok $info->install_json;
    ok $info->mymeta_json;
    is $info->main_module, "Role::Identifiable";
    is $info->main_module_file, undef;
};

done_testing;
