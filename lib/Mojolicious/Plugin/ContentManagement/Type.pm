package Mojolicious::Plugin::ContentManagement::Type;

use warnings;
use strict;

use Mojo::Base -base;

use Carp;

sub translate { croak 'Method unimplemented by subclass!' }

!! 42;
__END__

=head1 NAME

Mojolicious::Plugin::ContentManagement::Type - abstract managed content type

=head1 DESCRIPTION

A Mojolicious::Plugin::ContentManagement::Type is a thing that can translate
pages to html. This is an abstract base class.

=head1 IMPLEMENTATIONS SHIPPED WITH THIS DISTRIBUTION

=over 4

=item L<Mojolicious::Plugin::ContentManagement::Type::Plain>

This translator actually does nothing. Perfect if you want to store plain
html content pages

=item L<Mojolicious::Plugin::ContentManagement::Type::Markdown>

A Markdown translator. See L<Text::Markdown> for more details.

=back

=head1 METHODS

If you want to be a thing that can translate pages to html, you need to
implement the following methods:

=head2 translate

    my $html = $type->translate($input);

Output needs to be html.

=head1 SEE ALSO

L<Mojolicious::Plugin::ContentManagement>
