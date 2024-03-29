#!/usr/bin/env perl
#
# This file is part of Plack-Middleware-Pjax
#
# This software is copyright (c) 2011 by Matthew Phillips.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#

use Web::Simple 'PjaxDemo';
use Template;
use Plack::App::Directory;
use Plack::Middleware::Pjax;

{
    package PjaxDemo;

    use Plack::Builder;

    my $template = Template->new({
        INCLUDE_PATH => 'views/',
    });

    around 'to_psgi_app' => sub {
        my ($orig, $self) = (shift, shift);
        my $app = $self->$orig(@_);

        builder {
            enable 'Plack::Middleware::Pjax';
            mount '/' => $app;
        };
    };

    sub dispatch_request {
        sub (/) {
            my $out;
            $template->process('index.tt', {}, \$out);
            [ 200, [ 'Content-type', 'text/html' ], [ $out ] ]
        },
        sub (/dinosaurs+.html) {
            my $out;
            $template->process('dinosaurs.tt', {}, \$out);
            [ 200, [ 'Content-type', 'text/html' ], [ $out ] ]
        },
            sub (/aliens+.html) {
            my $out;
            $template->process('aliens.tt', {}, \$out);
            [ 200, [ 'Content-type', 'text/html' ], [ $out ] ]
        },
        sub (/static/...) { Plack::App::Directory->new({ root => "static/" }) },
    }

}

PjaxDemo->run_if_script;
