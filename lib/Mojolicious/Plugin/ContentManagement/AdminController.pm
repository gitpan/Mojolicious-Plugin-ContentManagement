package Mojolicious::Plugin::ContentManagement::AdminController;

use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller';

sub list {
    # Nothing to do
    # the template content pages list from the renderer helper
}

sub edit {
    my $self = shift;

    # Try to get the page
    my $path = $self->stash('path');
    my $page = $self->content_load($path)->clone;

    # Shortcut
    unless ($page) {
        $self->app->static->serve_404;
        return;
    }

    # Edit
    if (defined(my $raw = $self->param('raw'))) {

        # Build the new page
        my $title   = $self->param('title') || 'Preview';
        my $html    = $self->content_translate($raw);
        $page->title($title)->raw($raw)->html($html);

        # Not just a preview
        if (defined( $self->param('update_button') )) {

            # Save to source
            $self->content_save($page);

            # Get the fresh content page
            $page = $self->content_load($path);
        }
    }

    # View
    $self->stash(page => $page);
}

!! 42;
__DATA__
