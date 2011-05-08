#!/usr/bin/env perl

use FindBin '$Bin';
use lib "$Bin/../lib";
use Mojolicious::Lite;
use Test::Mojo;
use Test::More tests => 18;

# Protect the admin interface
# (allow only admins who have a good user name / password combination) ;)
my $admin_route = app->routes->bridge('/admin')->to( cb => sub {
    my $self = shift;
    my $user = $self->param('user') || 'foo';
    my $pass = $self->param('pass') || 'bar';

    return 1 if $user eq $pass;
    
    $self->res->code(401);
    $self->res->body(<<'EOF');
<!doctype html><html>
<head><title>Authorization required</title></head>
<body><h1>401 Authorization required</h1></body>
EOF
});

# Content management configuration
plugin content_management => {
    source          => 'filesystem',
    source_conf     => { directory => 'test-content' },
    type            => 'plain',
    forbidden       => [ qr(/ba.*) ],
    admin_route     => $admin_route,
};

# Managed content goes here
get '/(*everything)' => ( content_management => 1 ) => 'page';

# Preparations
app->log->level('error');
app->renderer->root("$Bin/test-templates");
my $t = Test::Mojo->new;

# Backup
open my $bfh, '<', "$Bin/test-content/foo.html" or die $!;
my $backup = join '' => <$bfh>;
close $bfh;

# Unauthorized
$t->get_ok('/admin')->content_like(qr/Authorization required/);

# Authorized
$t->get_ok('/admin?user=foo&pass=foo');
$t->content_like(qr/Content Management Admin Interface/, 'got in');

# Get a page path
my $elink   = $t->tx->res->dom->at('a[href^=/admin/edit/foo.html]');
my $epath   = $elink->attrs('href');
my $path    = $elink->text;

# Find out how it looks
$t->get_ok($path);
my $content = $t->tx->res->dom->at('body')->text;

# Go to the edit form and look if it matches the page
$t->get_ok($epath);
my $preview = $t->tx->res->dom->at('#preview')->text;
is($content, $preview, 'edit form is right for the page');

# Preview
$t->post_form_ok($epath => {raw => 'foo', preview_button => 'Preview!'});
$preview = $t->tx->res->dom->at('#preview')->text;
is($preview, 'foo', 'got the right preview');
$t->get_ok($path);
my $content2 = $t->tx->res->dom->at('body')->text;
is($content2, $content, 'page is still in old state');

# Edit
$t->post_form_ok($epath => {raw => 'foo', update_button => 'Update!'});
$preview = $t->tx->res->dom->at('#preview')->text;
is($preview, 'foo', 'got the right preview');
$t->get_ok($path);
my $content3 = $t->tx->res->dom->at('body')->text;
is($content3, 'foo', 'page has changed');

# Undo
$t->post_form_ok($epath => {raw => $backup, update_button => 'Update!'});
$t->get_ok($path);
my $content4 = $t->tx->res->dom->at('body')->text;
is($content4, $content, 'changes undone');

__END__
