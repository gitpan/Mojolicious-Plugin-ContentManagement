#!/usr/bin/env perl

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mojolicious::Plugin::ContentManagement',
    AUTHOR              => 'Mirko Westermeier <mail@memowe.de>',
    VERSION_FROM        => 'lib/Mojolicious/Plugin/ContentManagement.pm',
    ABSTRACT_FROM       => 'lib/Mojolicious/Plugin/ContentManagement.pm',
    LICENSE             => 'mit',
    PL_FILES            => {},
    PREREQ_PM => {
        'Mojolicious'                   => 1.3,
        'Text::Markdown'                => 1.000031,
        'DBI'                           => 1.61,
        'DBD::SQLite'                   => 1.29
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Mojolicious-Plugin-ContentManagement-*' },
);
