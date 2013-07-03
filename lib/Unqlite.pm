package Unqlite;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;
__END__

=encoding utf-8

=head1 NAME

Unqlite - Perl bindings for Unqlite

=head1 SYNOPSIS

    use Unqlite;

    my $db = Unqlite->open('foo.db');
    $db->kv_store('foo', 'bar');
    say $db->kv_fetch('foo'); # => bar
    $db->kv_delete('foo');
    undef $db; # close database

=head1 DESCRIPTION

UnQLite is a in-process software library which implements a self-contained, serverless, zero-configuration, transactional NoSQL database engine. UnQLite is a document store database similar to MongoDB, Redis, CouchDB etc. as well a standard Key/Value store similar to BerkeleyDB, LevelDB, etc.  

This module is Perl5 binding for Unqlite.

If you want to know more information about Unqlite, see L<http://unqlite.org/>.

Current version of Unqlite.pm supports only some C<kv_*> methods. Patches welcome.

=head1 METHODS

=over 4

=item C<< my $db = Unqlite->open('foo.db'[, $mode]); >>

Open the database.

=item C<< $db->kv_store($key, $value); >>

Store the entry to database.

=item C<< $db->kv_fetch($key); >>

Fetch data from database.

=item C<< $db->kv_delete($key); >>

Delte C< $key > from database.

=back

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

